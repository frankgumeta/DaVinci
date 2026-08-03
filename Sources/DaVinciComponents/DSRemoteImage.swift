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
public struct DSRemoteImage: View {

    // MARK: - ContentMode

    /// Content mode for the loaded image.
    public enum ContentMode: Sendable {
        case fill
        case fit
    }

    // MARK: - LoadPhase

    private enum LoadPhase: Sendable {
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
    private let width: CGFloat
    private let height: CGFloat
    private let cornerRadius: CGFloat
    private let contentMode: ContentMode
    private let showsShimmer: Bool
    private let placeholderSystemImage: String?
    private let label: String?
    private let isDecorative: Bool

    @State private var phase: LoadPhase = .loading
    @State private var decodedImage: Image?

    // MARK: - Init

    /// Creates a remotely loaded image with an explicit frame.
    ///
    /// Set `isDecorative` to `true` only when the image communicates no
    /// information; decorative images are hidden from assistive technologies.
    public init(
        url: URL?,
        width: CGFloat,
        height: CGFloat,
        cornerRadius: CGFloat = RadiusTokens.extraSmall,
        contentMode: ContentMode = .fill,
        showsShimmer: Bool = true,
        placeholderSystemImage: String? = nil,
        accessibilityLabel: String? = nil,
        isDecorative: Bool = false
    ) {
        self.url = url
        self.width = width
        self.height = height
        self.cornerRadius = cornerRadius
        self.contentMode = contentMode
        self.showsShimmer = showsShimmer
        self.placeholderSystemImage = placeholderSystemImage
        self.label = accessibilityLabel
        self.isDecorative = isDecorative
    }

    /// Convenience initializer accepting a `CGSize`.
    ///
    /// Set `isDecorative` to `true` only when the image communicates no
    /// information; decorative images are hidden from assistive technologies.
    public init(
        url: URL?,
        size: CGSize,
        cornerRadius: CGFloat = RadiusTokens.extraSmall,
        contentMode: ContentMode = .fill,
        showsShimmer: Bool = true,
        placeholderSystemImage: String? = nil,
        accessibilityLabel: String? = nil,
        isDecorative: Bool = false
    ) {
        self.init(
            url: url,
            width: size.width,
            height: size.height,
            cornerRadius: cornerRadius,
            contentMode: contentMode,
            showsShimmer: showsShimmer,
            placeholderSystemImage: placeholderSystemImage,
            accessibilityLabel: accessibilityLabel,
            isDecorative: isDecorative
        )
    }

    // MARK: - Body

    public var body: some View {
        content
            .frame(width: width, height: height)
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
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
                height: height,
                width: width,
                cornerRadius: cornerRadius,
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

            Image(systemName: placeholderSystemImage ?? "photo")
                .font(.system(size: min(width, height) * 0.3))
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
            return customLabel ?? "Loading image"
        case .success:
            return customLabel ?? (url != nil ? "Remote image" : "Placeholder image")
        case .failure:
            return customLabel ?? "Image failed to load"
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
            value = "Loading"
            traits = .updatesFrequently
        case .success:
            value = nil
            traits = .isImage
        case .failure:
            value = "Failed to load"
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

    private func load(_ url: URL?) async {
        phase = .loading
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

// MARK: - Preview Loaders

/// A preview loader that sleeps to simulate network latency, then succeeds.
private struct SlowPreviewImageLoader: DSImageLoading {
    func loadImageData(from url: URL) async throws -> Data {
        try await Task.sleep(for: .seconds(2))
        return generateSolidImageData(color: .systemBlue)
    }
}

/// A preview loader that returns image data immediately.
private struct SuccessPreviewImageLoader: DSImageLoading {
    func loadImageData(from url: URL) async throws -> Data {
        generateSolidImageData(color: .systemTeal)
    }
}

/// A preview loader that always fails.
private struct FailingPreviewImageLoader: DSImageLoading {
    func loadImageData(from url: URL) async throws -> Data {
        throw URLError(.badServerResponse)
    }
}

// MARK: - Preview Helpers

/// Generate a solid-color 100×100 PNG for previews.
private func generateSolidImageData(color: PlatformColor) -> Data {
    #if canImport(UIKit)
    let renderer = UIGraphicsImageRenderer(size: CGSize(width: 100, height: 100))
    return renderer.pngData { ctx in
        color.setFill()
        ctx.fill(CGRect(x: 0, y: 0, width: 100, height: 100))
    }
    #elseif canImport(AppKit)
    let image = NSImage(size: NSSize(width: 100, height: 100))
    image.lockFocus()
    color.setFill()
    NSRect(x: 0, y: 0, width: 100, height: 100).fill()
    image.unlockFocus()
    guard let tiff = image.tiffRepresentation,
          let rep = NSBitmapImageRep(data: tiff),
          let png = rep.representation(using: .png, properties: [:]) else {
        return Data()
    }
    return png
    #else
    return Data()
    #endif
}

#if canImport(UIKit)
private typealias PlatformColor = UIColor
#elseif canImport(AppKit)
private typealias PlatformColor = NSColor
#endif

// MARK: - Preview Blocks

#Preview("DSRemoteImage — Loading") {
    DSRemoteImage(
        url: URL(string: "https://example.com/photo.jpg"),
        width: 120,
        height: 120,
        cornerRadius: RadiusTokens.medium
    )
    .padding()
    .environment(\.dsImageLoader, SlowPreviewImageLoader())
    .dsTheme(.defaultTheme)
}

#Preview("DSRemoteImage — Success") {
    VStack(spacing: 16) {
        DSRemoteImage(
            url: URL(string: "https://example.com/photo.jpg"),
            width: 200,
            height: 150,
            cornerRadius: RadiusTokens.large,
            contentMode: .fill
        )
        DSRemoteImage(
            url: URL(string: "https://example.com/photo.jpg"),
            size: CGSize(width: 100, height: 100),
            cornerRadius: RadiusTokens.extraSmall,
            contentMode: .fit
        )
    }
    .padding()
    .environment(\.dsImageLoader, SuccessPreviewImageLoader())
    .dsTheme(.defaultTheme)
}

#Preview("DSRemoteImage — Failure") {
    VStack(spacing: 16) {
        DSRemoteImage(
            url: URL(string: "https://example.com/broken.jpg"),
            width: 120,
            height: 120,
            placeholderSystemImage: "exclamationmark.triangle"
        )
        DSRemoteImage(
            url: nil,
            width: 80,
            height: 80
        )
    }
    .padding()
    .environment(\.dsImageLoader, FailingPreviewImageLoader())
    .dsTheme(.defaultTheme)
}

#Preview("DSRemoteImage — Dark") {
    VStack(spacing: 16) {
        DSRemoteImage(
            url: URL(string: "https://example.com/photo.jpg"),
            width: 120,
            height: 120
        )
        DSRemoteImage(
            url: nil,
            width: 120,
            height: 120,
            placeholderSystemImage: "person.crop.circle"
        )
    }
    .padding()
    .environment(\.dsImageLoader, SuccessPreviewImageLoader())
    .dsTheme(.defaultTheme)
    .preferredColorScheme(.dark)
}

#Preview("DSRemoteImage — Custom Label") {
    DSRemoteImage(
        url: URL(string: "https://example.com/avatar.jpg"),
        width: 80,
        height: 80,
        cornerRadius: 40,
        accessibilityLabel: "User avatar"
    )
    .padding()
    .environment(\.dsImageLoader, SuccessPreviewImageLoader())
    .dsTheme(.defaultTheme)
}
