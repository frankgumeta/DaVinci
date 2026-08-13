import SwiftUI
import DaVinciTokens
import Foundation

#if canImport(UIKit)
import UIKit
#elseif canImport(AppKit)
import AppKit
#endif

// MARK: - Preview Loaders

/// A preview loader that sleeps to simulate network latency, then succeeds.
struct SlowPreviewImageLoader: DSImageLoading {
    func loadImageData(from url: URL) async throws -> Data {
        try await Task.sleep(for: .seconds(2))
        return generateSolidImageData(color: .systemBlue)
    }
}

/// A preview loader that returns image data immediately.
struct SuccessPreviewImageLoader: DSImageLoading {
    func loadImageData(from url: URL) async throws -> Data {
        generateSolidImageData(color: .systemTeal)
    }
}

/// A preview loader that always fails.
struct FailingPreviewImageLoader: DSImageLoading {
    func loadImageData(from url: URL) async throws -> Data {
        throw URLError(.badServerResponse)
    }
}

// MARK: - Preview Helpers

/// Generate a solid-color 100×100 PNG for previews.
func generateSolidImageData(color: PlatformColor) -> Data {
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
typealias PlatformColor = UIColor
#elseif canImport(AppKit)
typealias PlatformColor = NSColor
#endif

// MARK: - Preview Blocks

#Preview("DSRemoteImage — Loading") {
    DSRemoteImage(
        url: URL(string: "https://example.com/photo.jpg"),
        geometry: .rounded(
            size: CGSize(width: 120, height: 120),
            cornerRadius: RadiusTokens.medium
        )
    )
    .padding()
    .environment(\.dsImageLoader, SlowPreviewImageLoader())
    .dsTheme(.defaultTheme)
}

#Preview("DSRemoteImage — Success") {
    VStack(spacing: 16) {
        DSRemoteImage(
            url: URL(string: "https://example.com/photo.jpg"),
            geometry: .rounded(
                size: CGSize(width: 200, height: 150),
                cornerRadius: RadiusTokens.large
            ),
            contentMode: .fill
        )
        DSRemoteImage(
            url: URL(string: "https://example.com/photo.jpg"),
            geometry: .rounded(
                size: CGSize(width: 100, height: 100),
                cornerRadius: RadiusTokens.extraSmall
            ),
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
            geometry: .rounded(
                size: CGSize(width: 120, height: 120),
                cornerRadius: RadiusTokens.extraSmall
            ),
            placeholder: DSSymbol(systemName: "exclamationmark.triangle")
        )
        DSRemoteImage(
            url: nil,
            geometry: .rounded(
                size: CGSize(width: 80, height: 80),
                cornerRadius: RadiusTokens.extraSmall
            )
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
            geometry: .rounded(
                size: CGSize(width: 120, height: 120),
                cornerRadius: RadiusTokens.extraSmall
            )
        )
        DSRemoteImage(
            url: nil,
            geometry: .rounded(
                size: CGSize(width: 120, height: 120),
                cornerRadius: RadiusTokens.extraSmall
            ),
            placeholder: DSSymbol(systemName: "person.crop.circle")
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
        geometry: .circle(diameter: 80),
        accessibilityLabel: "User avatar"
    )
    .padding()
    .environment(\.dsImageLoader, SuccessPreviewImageLoader())
    .dsTheme(.defaultTheme)
}

#Preview("DSRemoteImage — Geometry") {
    HStack(spacing: SpacingTokens.space4) {
        DSRemoteImage(
            url: URL(string: "https://example.com/avatar.jpg"),
            geometry: .circle(diameter: 80),
            placeholder: DSSymbol(systemName: "person.crop.circle")
        )
        DSRemoteImage(
            url: URL(string: "https://example.com/photo.jpg"),
            geometry: .rounded(
                size: CGSize(width: 120, height: 80),
                cornerRadius: RadiusTokens.medium
            )
        )
    }
    .padding()
    .environment(\.dsImageLoader, SuccessPreviewImageLoader())
    .dsTheme(.defaultTheme)
}
