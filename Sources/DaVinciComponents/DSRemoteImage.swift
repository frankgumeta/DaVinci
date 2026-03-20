import SwiftUI
import DaVinciTokens

// MARK: - DSRemoteImage

/// An async image loader that shows a shimmering skeleton while loading,
/// the remote image on success, or a placeholder on failure.
///
/// Uses the `dsImageLoader` environment value for data fetching (testable)
/// and an internal in-memory cache to avoid redundant downloads.
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

    /// Fully `Sendable` load phase — stores raw `Data`, not `Image`.
    /// Decoding to `SwiftUI.Image` happens synchronously in the view body.
    private enum LoadPhase: Sendable, Equatable {
        case loading
        case success(Data)
        case failure
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

    @State private var phase: LoadPhase = .loading
    @State private var decodedImage: Image?

    // MARK: - Init

    public init(
        url: URL?,
        width: CGFloat,
        height: CGFloat,
        cornerRadius: CGFloat = RadiusTokens.extraSmall,
        contentMode: ContentMode = .fill,
        showsShimmer: Bool = true,
        placeholderSystemImage: String? = nil,
        accessibilityLabel: String? = nil
    ) {
        self.url = url
        self.width = width
        self.height = height
        self.cornerRadius = cornerRadius
        self.contentMode = contentMode
        self.showsShimmer = showsShimmer
        self.placeholderSystemImage = placeholderSystemImage
        self.label = accessibilityLabel
    }

    /// Convenience initializer accepting a `CGSize`.
    public init(
        url: URL?,
        size: CGSize,
        cornerRadius: CGFloat = RadiusTokens.extraSmall,
        contentMode: ContentMode = .fill,
        showsShimmer: Bool = true,
        placeholderSystemImage: String? = nil,
        accessibilityLabel: String? = nil
    ) {
        self.init(
            url: url,
            width: size.width,
            height: size.height,
            cornerRadius: cornerRadius,
            contentMode: contentMode,
            showsShimmer: showsShimmer,
            placeholderSystemImage: placeholderSystemImage,
            accessibilityLabel: accessibilityLabel
        )
    }

    // MARK: - Body

    public var body: some View {
        content
            .frame(width: width, height: height)
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
            .accessibilityLabel(resolvedAccessibilityLabel)
            .accessibilityAddTraits(phase == .loading ? .updatesFrequently : [])
            .task(id: url) {
                await load(url)
            }
            .onChange(of: phase) { _, newPhase in
                if case .success(let data) = newPhase {
                    decodedImage = Self.decodeImage(from: data)
                } else {
                    decodedImage = nil
                }
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

    private var resolvedAccessibilityLabel: String {
        let accessibilityPhase: AccessibilityPhase
        switch phase {
        case .loading: accessibilityPhase = .loading
        case .success: accessibilityPhase = .success
        case .failure: accessibilityPhase = .failure
        }
        return Self.resolveAccessibilityLabel(
            phase: accessibilityPhase, customLabel: label, url: url
        )
    }

    // MARK: - Loading

    private func load(_ url: URL?) async {
        await MainActor.run { phase = .loading }

        guard let url else {
            await MainActor.run { phase = .failure }
            return
        }

        // Check cache first
        if let cached = await DSImageCache.shared.data(for: url) {
            await MainActor.run { phase = .success(cached) }
            return
        }

        // Fetch from network
        do {
            let data = try await loader.loadImageData(from: url)
            guard !Task.isCancelled else { return }
            await DSImageCache.shared.setData(data, for: url)
            await MainActor.run { phase = .success(data) }
        } catch {
            guard !Task.isCancelled else { return }
            await MainActor.run { phase = .failure }
        }
    }

    // MARK: - Decoding

    private static func decodeImage(from data: Data) -> Image? {
        #if canImport(UIKit)
        guard let uiImage = UIImage(data: data) else { return nil }
        return Image(uiImage: uiImage)
        #elseif canImport(AppKit)
        guard let nsImage = NSImage(data: data) else { return nil }
        return Image(nsImage: nsImage)
        #else
        return nil
        #endif
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
