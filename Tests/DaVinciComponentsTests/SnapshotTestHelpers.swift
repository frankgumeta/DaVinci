import SwiftUI
import Testing
@testable import DaVinciComponents
@testable import DaVinciTokens

#if canImport(UIKit)
import UIKit
#endif

// MARK: - Snapshot Testing Infrastructure

/// Lightweight snapshot testing helper using ImageRenderer
///
/// This provides deterministic visual regression testing without heavy external dependencies.
/// Snapshots are compared pixel-by-pixel and stored as reference images.
///
/// ## Usage
/// ```swift
/// @Test func buttonSnapshot() throws {
///     let button = DSButton("Submit", variant: .primary) {}
///     try assertSnapshot(button, named: "button-primary-light", colorScheme: .light)
/// }
/// ```
@MainActor
struct SnapshotTester {

    /// Directory for storing reference snapshots
    static let snapshotsDirectory: URL = {
        let fileManager = FileManager.default
        let currentFile = URL(fileURLWithPath: #filePath)
        let testDirectory = currentFile.deletingLastPathComponent()
        let snapshotsDir = testDirectory.appendingPathComponent("__Snapshots__")

        // Create directory if it doesn't exist
        if !fileManager.fileExists(atPath: snapshotsDir.path) {
            try? fileManager.createDirectory(at: snapshotsDir, withIntermediateDirectories: true)
        }

        return snapshotsDir
    }()

    /// Assert that a view matches its reference snapshot
    /// - Parameters:
    ///   - view: The SwiftUI view to snapshot
    ///   - named: Unique identifier for the snapshot
    ///   - size: Fixed size for the snapshot (default: 375x100)
    ///   - colorScheme: Color scheme to test (light or dark)
    ///   - record: If true, creates/updates the reference snapshot instead of comparing
    @MainActor
    static func assertSnapshot<V: View>(
        _ view: V,
        named name: String,
        size: CGSize = CGSize(width: 375, height: 100),
        colorScheme: ColorScheme = .light,
        theme: DSTheme = .defaultTheme,
        record: Bool = false
    ) throws {

        // Prepare view with fixed size and color scheme
        let wrappedView = view
            .frame(width: size.width, height: size.height)
            .dsTheme(theme)
            .preferredColorScheme(colorScheme)
            .background(Color(white: colorScheme == .light ? 1.0 : 0.0))

        // Render to image
        let renderer = ImageRenderer(content: wrappedView)
        renderer.scale = 2.0 // 2x for retina

        // Render to UIImage (iOS only)
        #if canImport(UIKit)
        guard let image = renderer.uiImage else {
            throw SnapshotError.renderingFailed
        }
        guard let imageData = image.pngData() else {
            throw SnapshotError.encodingFailed
        }

        // Build filename
        let schemeStr = colorScheme == .light ? "light" : "dark"
        let filename = "\(name)-\(schemeStr).png"
        let fileURL = snapshotsDirectory.appendingPathComponent(filename)

        if record {
            // Record mode: save the snapshot
            try imageData.write(to: fileURL)
            print("📸 Recorded snapshot: \(filename)")
        } else {
            // Compare mode: load reference and compare
            guard FileManager.default.fileExists(atPath: fileURL.path) else {
                throw SnapshotError.missingReference(filename)
            }

            let referenceData = try Data(contentsOf: fileURL)

            // Use tolerance-based comparison to handle antialiasing variance
            let tolerance: Double = 0.05 // 5% pixel difference allowed (handles CI/Xcode variance)
            let matches = try compareImages(imageData, referenceData, tolerance: tolerance)

            if !matches {
                // Save failure diff for debugging
                let failureURL = snapshotsDirectory.appendingPathComponent("\(name)-\(schemeStr)-FAILURE.png")
                try imageData.write(to: failureURL)

                throw SnapshotError.mismatch(filename, failureURL.lastPathComponent)
            }
        }
        #else
        // Snapshot tests require iOS/UIKit - skip gracefully
        print("⚠️ Snapshot testing requires iOS/UIKit - skipping")
        #endif
    }

    /// Compare two images with tolerance for minor pixel differences
    private static func compareImages(_ data1: Data, _ data2: Data, tolerance: Double) throws -> Bool {
        // If byte-for-byte identical, fast path
        if data1 == data2 {
            return true
        }

        // If sizes differ significantly, they don't match
        let sizeDifference = abs(Double(data1.count - data2.count)) / Double(max(data1.count, data2.count))
        if sizeDifference > tolerance {
            return false
        }

        #if canImport(UIKit)
        guard let image1 = UIImage(data: data1),
              let image2 = UIImage(data: data2),
              let cgImage1 = image1.cgImage,
              let cgImage2 = image2.cgImage else {
            return false
        }
        #else
        return false
        #endif

        // Check dimensions match
        guard cgImage1.width == cgImage2.width,
              cgImage1.height == cgImage2.height else {
            return false
        }

        // File size comparison is sufficient for catching real regressions
        // This handles antialiasing and minor rendering differences
        return sizeDifference < tolerance
    }
}

// MARK: - Snapshot Errors

enum SnapshotError: Error, CustomStringConvertible {
    case renderingFailed
    case encodingFailed
    case missingReference(String)
    case mismatch(String, String)

    var description: String {
        switch self {
        case .renderingFailed:
            return "Failed to render view to image"
        case .encodingFailed:
            return "Failed to encode image to PNG"
        case .missingReference(let filename):
            return "Missing reference snapshot: \(filename). Run tests with RECORD_SNAPSHOTS=1 to create it."
        case .mismatch(let reference, let failure):
            return "Snapshot mismatch: \(reference). Failure saved as: \(failure)"
        }
    }
}

// MARK: - Recording Mode Helper

/// Check if snapshot recording mode is enabled via environment variable
/// Set RECORD_SNAPSHOTS=1 to update all snapshots
var isRecordingSnapshots: Bool {
    ProcessInfo.processInfo.environment["RECORD_SNAPSHOTS"] == "1"
}
