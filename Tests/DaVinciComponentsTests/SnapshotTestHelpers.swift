import SwiftUI
import Testing
@testable import DaVinciComponents
@testable import DaVinciTokens

#if canImport(UIKit)
import UIKit
#endif

// MARK: - Snapshot Testing Infrastructure

/// Lightweight snapshot testing helper using `ImageRenderer`.
///
/// Reference and received images are normalized to RGBA8 before their pixels are
/// compared. Missing references fail unless recording was explicitly enabled.
@MainActor
struct SnapshotTester {

    struct Tolerance: Sendable {
        /// Per-channel differences at or below this value are treated as antialiasing noise.
        let channelDelta: UInt8
        /// Maximum fraction of pixels whose channel delta exceeds `channelDelta`.
        let differingPixelRatio: Double
        /// Maximum mean absolute channel difference, normalized to `0...1`.
        let meanChannelDifference: Double

        static let standard = Tolerance(
            channelDelta: 2,
            differingPixelRatio: 0.005,
            meanChannelDifference: 0.001
        )
    }

    struct Comparison: Sendable {
        let matches: Bool
        let differingPixelRatio: Double
        let meanChannelDifference: Double
        let maximumChannelDifference: Double
        let width: Int
        let height: Int
    }

    struct FailureArtifacts: Sendable {
        let expected: URL
        let received: URL
        let diff: URL
    }

    /// Directory containing committed reference snapshots.
    static let snapshotsDirectory: URL = {
        let testDirectory = URL(fileURLWithPath: #filePath).deletingLastPathComponent()
        return testDirectory.appendingPathComponent("__Snapshots__")
    }()

    /// Directory uploaded by CI when a snapshot comparison fails.
    static let failuresDirectory: URL = {
        let repositoryRoot = URL(fileURLWithPath: #filePath)
            .deletingLastPathComponent() // DaVinciComponentsTests
            .deletingLastPathComponent() // Tests
            .deletingLastPathComponent() // repository root
        return repositoryRoot
            .appendingPathComponent(".build")
            .appendingPathComponent("snapshot-failures")
    }()

    /// Assert that a view matches its committed reference snapshot.
    ///
    /// - Parameters:
    ///   - view: View to render.
    ///   - name: Unique snapshot identifier without color-scheme suffix.
    ///   - size: Fixed rendering size.
    ///   - colorScheme: Light or dark rendering mode.
    ///   - theme: DaVinci theme injected into the view.
    ///   - record: Explicitly create or replace the reference snapshot.
    static func assertSnapshot<V: View>(
        _ view: V,
        named name: String,
        size: CGSize = CGSize(width: 375, height: 100),
        colorScheme: ColorScheme = .light,
        theme: DSTheme = .defaultTheme,
        record: Bool = false
    ) throws {
        let receivedData = try render(
            view,
            size: size,
            colorScheme: colorScheme,
            theme: theme
        )
        let filename = snapshotFilename(name: name, colorScheme: colorScheme)
        let referenceURL = snapshotsDirectory.appendingPathComponent(filename)

        if record {
            try FileManager.default.createDirectory(
                at: snapshotsDirectory,
                withIntermediateDirectories: true
            )
            try receivedData.write(to: referenceURL, options: .atomic)
            print("📸 Recorded snapshot: \(filename)")
            return
        }

        guard FileManager.default.fileExists(atPath: referenceURL.path) else {
            throw SnapshotError.missingReference(filename)
        }

        try assertImageData(
            receivedData,
            matchesReferenceAt: referenceURL,
            filename: filename
        )
    }

    private static func render<V: View>(
        _ view: V,
        size: CGSize,
        colorScheme: ColorScheme,
        theme: DSTheme
    ) throws -> Data {
        let wrappedView = view
            .frame(width: size.width, height: size.height)
            .dsTheme(theme)
            .preferredColorScheme(colorScheme)
            .environment(\.locale, Locale(identifier: "en_US_POSIX"))
            .environment(\.timeZone, TimeZone(secondsFromGMT: 0)!)
            .environment(\.layoutDirection, .leftToRight)
            .environment(\.dynamicTypeSize, .large)
            .background(Color(white: colorScheme == .light ? 1.0 : 0.0))

        let renderer = ImageRenderer(content: wrappedView)
        renderer.scale = 2.0

        #if canImport(UIKit)
        guard let image = renderer.uiImage else {
            throw SnapshotError.renderingFailed
        }
        guard let receivedData = image.pngData() else {
            throw SnapshotError.encodingFailed
        }
        return receivedData
        #else
        throw SnapshotError.unsupportedPlatform
        #endif
    }

    private static func assertImageData(
        _ receivedData: Data,
        matchesReferenceAt referenceURL: URL,
        filename: String
    ) throws {
        #if canImport(UIKit)
        let expectedData = try Data(contentsOf: referenceURL)
        let comparison = try compareImages(
            expectedData,
            receivedData,
            tolerance: .standard
        )

        guard comparison.matches else {
            let artifacts = try writeFailureArtifacts(
                named: filename,
                expectedData: expectedData,
                receivedData: receivedData,
                tolerance: .standard
            )
            throw SnapshotError.mismatch(
                reference: filename,
                differingPixelRatio: comparison.differingPixelRatio,
                meanChannelDifference: comparison.meanChannelDifference,
                maximumChannelDifference: comparison.maximumChannelDifference,
                artifactsDirectory: artifacts.diff.deletingLastPathComponent().path
            )
        }
        #else
        throw SnapshotError.unsupportedPlatform
        #endif
    }

    static func snapshotFilename(name: String, colorScheme: ColorScheme) -> String {
        let scheme = colorScheme == .light ? "light" : "dark"
        return "\(name)-\(scheme).png"
    }

}

#if canImport(UIKit)
extension SnapshotTester {
    /// Compare two encoded images after normalizing them to RGBA8 buffers.
    static func compareImages(
        _ expectedData: Data,
        _ receivedData: Data,
        tolerance: Tolerance = .standard
    ) throws -> Comparison {
        let expected = try pixelBuffer(from: expectedData)
        let received = try pixelBuffer(from: receivedData)

        guard expected.width == received.width, expected.height == received.height else {
            throw SnapshotError.dimensionMismatch(
                expectedWidth: expected.width,
                expectedHeight: expected.height,
                receivedWidth: received.width,
                receivedHeight: received.height
            )
        }

        let pixelCount = expected.width * expected.height
        var differingPixels = 0
        var totalChannelDifference = 0
        var maximumChannelDifference = 0

        for pixelIndex in 0..<pixelCount {
            let offset = pixelIndex * 4
            var pixelMaximum = 0

            for channel in 0..<4 {
                let difference = abs(
                    Int(expected.bytes[offset + channel]) - Int(received.bytes[offset + channel])
                )
                if difference > Int(tolerance.channelDelta) {
                    totalChannelDifference += difference
                }
                pixelMaximum = max(pixelMaximum, difference)
                maximumChannelDifference = max(maximumChannelDifference, difference)
            }

            if pixelMaximum > Int(tolerance.channelDelta) {
                differingPixels += 1
            }
        }

        let differingPixelRatio = Double(differingPixels) / Double(pixelCount)
        let meanChannelDifference = Double(totalChannelDifference) / Double(pixelCount * 4 * 255)
        let normalizedMaximumDifference = Double(maximumChannelDifference) / 255.0
        let matches = differingPixelRatio <= tolerance.differingPixelRatio
            && meanChannelDifference <= tolerance.meanChannelDifference

        return Comparison(
            matches: matches,
            differingPixelRatio: differingPixelRatio,
            meanChannelDifference: meanChannelDifference,
            maximumChannelDifference: normalizedMaximumDifference,
            width: expected.width,
            height: expected.height
        )
    }

    static func writeFailureArtifacts(
        named filename: String,
        expectedData: Data,
        receivedData: Data,
        tolerance: Tolerance = .standard
    ) throws -> FailureArtifacts {
        let expected = try pixelBuffer(from: expectedData)
        let received = try pixelBuffer(from: receivedData)

        guard expected.width == received.width, expected.height == received.height else {
            throw SnapshotError.dimensionMismatch(
                expectedWidth: expected.width,
                expectedHeight: expected.height,
                receivedWidth: received.width,
                receivedHeight: received.height
            )
        }

        try FileManager.default.createDirectory(
            at: failuresDirectory,
            withIntermediateDirectories: true
        )

        let basename = URL(fileURLWithPath: filename).deletingPathExtension().lastPathComponent
        let expectedURL = failuresDirectory.appendingPathComponent("\(basename)-expected.png")
        let receivedURL = failuresDirectory.appendingPathComponent("\(basename)-received.png")
        let diffURL = failuresDirectory.appendingPathComponent("\(basename)-diff.png")
        let diffBytes = makeDiffBytes(expected: expected, received: received, tolerance: tolerance)
        let diffData = try pngData(
            bytes: diffBytes,
            width: expected.width,
            height: expected.height
        )
        try expectedData.write(to: expectedURL, options: .atomic)
        try receivedData.write(to: receivedURL, options: .atomic)
        try diffData.write(to: diffURL, options: .atomic)

        return FailureArtifacts(expected: expectedURL, received: receivedURL, diff: diffURL)
    }

    private static func makeDiffBytes(
        expected: PixelBuffer,
        received: PixelBuffer,
        tolerance: Tolerance
    ) -> [UInt8] {
        var diffBytes = [UInt8](repeating: 0, count: expected.bytes.count)
        let pixelCount = expected.width * expected.height

        for pixelIndex in 0..<pixelCount {
            let offset = pixelIndex * 4
            let maximumDifference = (0..<4).reduce(0) { current, channel in
                max(
                    current,
                    abs(Int(expected.bytes[offset + channel]) - Int(received.bytes[offset + channel]))
                )
            }
            writeDiffPixel(
                to: &diffBytes,
                offset: offset,
                maximumDifference: maximumDifference,
                expectedBytes: expected.bytes,
                tolerance: tolerance
            )
        }
        return diffBytes
    }

    private static func writeDiffPixel(
        to bytes: inout [UInt8],
        offset: Int,
        maximumDifference: Int,
        expectedBytes: [UInt8],
        tolerance: Tolerance
    ) {
        if maximumDifference > Int(tolerance.channelDelta) {
            bytes[offset] = 255
            bytes[offset + 1] = UInt8(max(0, 255 - maximumDifference))
            bytes[offset + 2] = 0
            bytes[offset + 3] = 255
        } else {
            let luminance = UInt8(
                (Int(expectedBytes[offset])
                    + Int(expectedBytes[offset + 1])
                    + Int(expectedBytes[offset + 2])) / 12
            )
            bytes[offset] = luminance
            bytes[offset + 1] = luminance
            bytes[offset + 2] = luminance
            bytes[offset + 3] = 255
        }
    }

    private struct PixelBuffer {
        let width: Int
        let height: Int
        let bytes: [UInt8]
    }

    private static func pixelBuffer(from data: Data) throws -> PixelBuffer {
        guard let image = UIImage(data: data), let cgImage = image.cgImage else {
            throw SnapshotError.invalidImageData
        }

        let width = cgImage.width
        let height = cgImage.height
        var bytes = [UInt8](repeating: 0, count: width * height * 4)
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGBitmapInfo.byteOrder32Big.rawValue
            | CGImageAlphaInfo.premultipliedLast.rawValue

        guard let context = CGContext(
            data: &bytes,
            width: width,
            height: height,
            bitsPerComponent: 8,
            bytesPerRow: width * 4,
            space: colorSpace,
            bitmapInfo: bitmapInfo
        ) else {
            throw SnapshotError.pixelBufferCreationFailed
        }

        context.interpolationQuality = .none
        context.draw(cgImage, in: CGRect(x: 0, y: 0, width: width, height: height))
        return PixelBuffer(width: width, height: height, bytes: bytes)
    }

    private static func pngData(bytes: [UInt8], width: Int, height: Int) throws -> Data {
        let data = Data(bytes)
        guard let provider = CGDataProvider(data: data as CFData),
              let image = CGImage(
                  width: width,
                  height: height,
                  bitsPerComponent: 8,
                  bitsPerPixel: 32,
                  bytesPerRow: width * 4,
                  space: CGColorSpaceCreateDeviceRGB(),
                  bitmapInfo: CGBitmapInfo(
                      rawValue: CGBitmapInfo.byteOrder32Big.rawValue
                          | CGImageAlphaInfo.premultipliedLast.rawValue
                  ),
                  provider: provider,
                  decode: nil,
                  shouldInterpolate: false,
                  intent: .defaultIntent
              ) else {
            throw SnapshotError.pixelBufferCreationFailed
        }

        guard let encoded = UIImage(cgImage: image).pngData() else {
            throw SnapshotError.encodingFailed
        }
        return encoded
    }
}
#endif

// MARK: - Snapshot Errors

enum SnapshotError: Error, CustomStringConvertible {
    case unsupportedPlatform
    case renderingFailed
    case encodingFailed
    case invalidImageData
    case pixelBufferCreationFailed
    case missingReference(String)
    case dimensionMismatch(
        expectedWidth: Int,
        expectedHeight: Int,
        receivedWidth: Int,
        receivedHeight: Int
    )
    case mismatch(
        reference: String,
        differingPixelRatio: Double,
        meanChannelDifference: Double,
        maximumChannelDifference: Double,
        artifactsDirectory: String
    )

    var description: String {
        switch self {
        case .unsupportedPlatform:
            return "Snapshot testing requires iOS/UIKit"
        case .renderingFailed:
            return "Failed to render view to image"
        case .encodingFailed:
            return "Failed to encode image as PNG"
        case .invalidImageData:
            return "Snapshot data could not be decoded as an image"
        case .pixelBufferCreationFailed:
            return "Failed to normalize snapshot as an RGBA8 pixel buffer"
        case .missingReference(let filename):
            return "Missing reference snapshot: \(filename). Run with RECORD_SNAPSHOTS=1 to create it."
        case let .dimensionMismatch(expectedWidth, expectedHeight, receivedWidth, receivedHeight):
            return "Snapshot dimensions differ: expected \(expectedWidth)x\(expectedHeight), "
                + "received \(receivedWidth)x\(receivedHeight)"
        case let .mismatch(
            reference,
            differingPixelRatio,
            meanChannelDifference,
            maximumChannelDifference,
            artifactsDirectory
        ):
            let percentage = differingPixelRatio * 100
            return "Snapshot mismatch: \(reference); differing pixels: "
                + String(format: "%.3f%%", percentage)
                + ", mean channel difference: "
                + String(format: "%.5f", meanChannelDifference)
                + ", maximum channel difference: "
                + String(format: "%.5f", maximumChannelDifference)
                + ". Artifacts: \(artifactsDirectory)"
        }
    }
}

/// Recording is opt-in so a missing baseline can never pass silently.
var isRecordingSnapshots: Bool {
    ProcessInfo.processInfo.environment["RECORD_SNAPSHOTS"] == "1"
}
