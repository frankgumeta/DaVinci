import SwiftUI
import DaVinciTokens

// MARK: - DSRemoteImage

/// An async image loader that shows a shimmering skeleton while loading,
/// the remote image on success, or a placeholder on failure.
///
/// Uses the `dsImageLoader` environment value for data fetching (testable)
/// and an internal, cost-limited pipeline to validate, deduplicate, decode,
/// and cache images.
///
/// The default policy rejects payloads above 20 MB or 40 megapixels and keeps
/// up to 50 MB of validated decoded images in a shared LRU cache. Failures are
/// not retried automatically. Cancelling one consumer does not cancel shared
/// work that another image view may still need.
///
/// Lifecycle is managed via `.task(id:)` — changing the URL automatically
/// cancels the previous load and starts a new one.
///
/// A `nil` URL is resolved synchronously to the placeholder state, so the view
/// never renders a shimmering skeleton for content that can never load.
public struct DSRemoteImage: View {

    // MARK: - ContentMode

    /// Content mode for the loaded image.
    public enum ContentMode: Sendable {
        case fill
        case fit
    }

    // MARK: - LoadPhase

    internal enum LoadPhase: Sendable, Equatable {
        case loading
        case success
        case failure
    }

    internal enum LoadResult: Sendable {
        case success(DSDecodedImage)
        case failure
        case cancelled
    }

    // MARK: - Properties

    @Environment(\.dsTheme) private var theme
    @Environment(\.dsImageLoader) private var loader

    private let url: URL?
    internal let geometry: Geometry
    private let contentMode: ContentMode
    private let showsShimmer: Bool
    private let placeholder: DSSymbol?
    private let label: String?
    private let isDecorative: Bool

    @State private var phase: LoadPhase
    @State private var decodedImage: Image?

    // MARK: - Init

    /// Creates a remotely loaded image with explicit geometry.
    public init(
        url: URL?,
        geometry: Geometry,
        contentMode: ContentMode = .fill,
        showsShimmer: Bool = true,
        placeholder: DSSymbol? = nil,
        accessibilityLabel: String? = nil,
        isDecorative: Bool = false
    ) {
        self.url = url
        self.geometry = geometry.normalized
        self.contentMode = contentMode
        self.showsShimmer = showsShimmer
        self.placeholder = placeholder
        self.label = accessibilityLabel
        self.isDecorative = isDecorative
        _phase = State(initialValue: Self.initialPhase(for: url))
    }

    // MARK: - Body

    public var body: some View {
        content
            .frame(width: geometry.size.width, height: geometry.size.height)
            .clipShape(geometry.clipShape)
            .modifier(DSAccessibilityModifier(descriptor: accessibilityDescriptor))
            .task(id: url) {
                await load(url)
            }
    }

    // MARK: - Content

    @ViewBuilder
    private var content: some View {
        switch phase {
        case .loading:
            DSSkeletonBlock(
                height: geometry.size.height,
                width: geometry.size.width,
                cornerRadius: geometry.cornerRadius,
                isShimmering: showsShimmer
            )

        case .success:
            if let decodedImage {
                switch contentMode {
                case .fill:
                    decodedImage
                        .resizable()
                        .scaledToFill()
                case .fit:
                    decodedImage
                        .resizable()
                        .scaledToFit()
                }
            } else {
                placeholderView
            }

        case .failure:
            placeholderView
        }
    }

    private var placeholderView: some View {
        ZStack {
            Rectangle()
                .fill(theme.colors.semantic.bgSecondary)

            (placeholder ?? .imagePlaceholder).image
                .font(.system(size: min(geometry.size.width, geometry.size.height) * 0.3))
                .foregroundStyle(theme.colors.semantic.textTertiary)
        }
    }

    internal enum AccessibilityPhase: Sendable {
        case loading, success, failure
    }

    internal static func resolveAccessibilityLabel(
        phase: AccessibilityPhase, customLabel: String?, url: URL?
    ) -> String {
        switch phase {
        case .loading:
            return customLabel ?? DSLocalizedStrings.value(.imageLoading)
        case .success:
            return customLabel ?? DSLocalizedStrings.value(
                url != nil ? .imageRemote : .imagePlaceholder
            )
        case .failure:
            // A missing URL is not a failure: nothing was ever requested.
            return customLabel ?? DSLocalizedStrings.value(
                url != nil ? .imageFailed : .imagePlaceholder
            )
        }
    }

    internal static func accessibilityDescriptor(
        phase: AccessibilityPhase,
        customLabel: String?,
        url: URL?,
        isDecorative: Bool
    ) -> DSAccessibilityDescriptor {
        let value: String?
        let traits: AccessibilityTraits
        switch phase {
        case .loading:
            value = DSLocalizedStrings.value(.loading)
            traits = .updatesFrequently
        case .success:
            value = nil
            traits = .isImage
        case .failure:
            value = url != nil ? DSLocalizedStrings.value(.imageFailedValue) : nil
            traits = .isImage
        }
        return DSAccessibilityDescriptor(
            label: resolveAccessibilityLabel(phase: phase, customLabel: customLabel, url: url),
            value: value,
            traits: traits,
            isHidden: isDecorative
        )
    }

    private var accessibilityPhase: AccessibilityPhase {
        switch phase {
        case .loading: .loading
        case .success: .success
        case .failure: .failure
        }
    }

    internal var accessibilityDescriptor: DSAccessibilityDescriptor {
        Self.accessibilityDescriptor(
            phase: accessibilityPhase,
            customLabel: label,
            url: url,
            isDecorative: isDecorative
        )
    }

    // MARK: - Loading

    /// The phase a freshly created or re-identified view starts in.
    ///
    /// A `nil` URL can never succeed, so it resolves to `.failure` synchronously.
    /// This keeps the rendered output deterministic instead of depending on when
    /// SwiftUI schedules the asynchronous load.
    internal static func initialPhase(for url: URL?) -> LoadPhase {
        url == nil ? .failure : .loading
    }

    private func load(_ url: URL?) async {
        phase = Self.initialPhase(for: url)
        decodedImage = nil

        let result = await Self.loadImage(from: url, using: loader)
        guard !Task.isCancelled else { return }

        switch result {
        case .success(let decoded):
            #if canImport(UIKit)
            decodedImage = Image(uiImage: decoded.image)
            #elseif canImport(AppKit)
            decodedImage = Image(nsImage: decoded.image)
            #endif
            phase = .success
        case .failure:
            phase = .failure
        case .cancelled:
            break
        }
    }

    internal static func loadImage(
        from url: URL?,
        using loader: any DSImageLoading,
        pipeline: DSImagePipeline = .shared
    ) async -> LoadResult {
        guard let url else { return .failure }

        do {
            let image = try await pipeline.image(for: url, using: loader)
            try Task.checkCancellation()
            return .success(image)
        } catch is CancellationError {
            return .cancelled
        } catch {
            return .failure
        }
    }
}
