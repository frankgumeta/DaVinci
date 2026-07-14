import SwiftUI
import Testing

#if canImport(UIKit)
import UIKit

@Suite("Snapshot Comparator")
@MainActor
struct SnapshotComparatorTests {

    @Test func identicalImagesMatch() throws {
        let image = solidImageData(color: .systemBlue, size: CGSize(width: 20, height: 20))

        let result = try SnapshotTester.compareImages(image, image)

        #expect(result.matches)
        #expect(result.differingPixelRatio == 0)
        #expect(result.meanChannelDifference == 0)
        #expect(result.maximumChannelDifference == 0)
    }

    @Test func smallChannelNoiseWithinToleranceMatches() throws {
        let expected = solidImageData(
            color: UIColor(red: 100 / 255, green: 100 / 255, blue: 100 / 255, alpha: 1),
            size: CGSize(width: 20, height: 20)
        )
        let received = solidImageData(
            color: UIColor(red: 102 / 255, green: 101 / 255, blue: 99 / 255, alpha: 1),
            size: CGSize(width: 20, height: 20)
        )

        let result = try SnapshotTester.compareImages(expected, received)

        #expect(result.matches)
        #expect(result.differingPixelRatio == 0)
        #expect(result.maximumChannelDifference <= 2.0 / 255.0)
    }

    @Test func aFewChangedPixelsWithinRatioToleranceMatch() throws {
        let expected = imageData(size: CGSize(width: 100, height: 100)) { context in
            UIColor.white.setFill()
            context.fill(CGRect(x: 0, y: 0, width: 100, height: 100))
        }
        let received = imageData(size: CGSize(width: 100, height: 100)) { context in
            UIColor.white.setFill()
            context.fill(CGRect(x: 0, y: 0, width: 100, height: 100))
            UIColor.black.setFill()
            context.fill(CGRect(x: 0, y: 0, width: 2, height: 2))
        }

        let result = try SnapshotTester.compareImages(expected, received)

        #expect(result.matches)
        #expect(result.differingPixelRatio > 0)
        #expect(result.differingPixelRatio <= 0.005)
    }

    @Test func visuallyDifferentImagesWithSimilarPNGSizeFail() throws {
        let expected = solidImageData(color: .systemRed, size: CGSize(width: 40, height: 40))
        let received = solidImageData(color: .systemBlue, size: CGSize(width: 40, height: 40))
        let encodedSizeDifference = Double(abs(expected.count - received.count))
            / Double(max(expected.count, received.count))

        let result = try SnapshotTester.compareImages(expected, received)

        #expect(encodedSizeDifference < 0.05)
        #expect(!result.matches)
        #expect(result.differingPixelRatio == 1)
        #expect(result.maximumChannelDifference > 0.5)
    }

    @Test func changedRegionAboveToleranceFails() throws {
        let expected = solidImageData(color: .white, size: CGSize(width: 100, height: 100))
        let received = imageData(size: CGSize(width: 100, height: 100)) { context in
            UIColor.white.setFill()
            context.fill(CGRect(x: 0, y: 0, width: 100, height: 100))
            UIColor.black.setFill()
            context.fill(CGRect(x: 0, y: 0, width: 20, height: 20))
        }

        let result = try SnapshotTester.compareImages(expected, received)

        #expect(!result.matches)
        #expect(result.differingPixelRatio > 0.005)
        #expect(result.meanChannelDifference > 0.001)
    }

    @Test func differentDimensionsThrow() {
        let expected = solidImageData(color: .white, size: CGSize(width: 20, height: 20))
        let received = solidImageData(color: .white, size: CGSize(width: 21, height: 20))

        #expect(throws: SnapshotError.self) {
            try SnapshotTester.compareImages(expected, received)
        }
    }

    @Test func missingReferenceFailsWithoutCreatingBaseline() throws {
        let name = "missing-reference-contract-\(UUID().uuidString)"
        let filename = SnapshotTester.snapshotFilename(name: name, colorScheme: .light)
        let reference = SnapshotTester.snapshotsDirectory.appendingPathComponent(filename)

        #expect(!FileManager.default.fileExists(atPath: reference.path))
        var missingFilename: String?
        do {
            try SnapshotTester.assertSnapshot(
                Color.red,
                named: name,
                size: CGSize(width: 10, height: 10)
            )
        } catch SnapshotError.missingReference(let filename) {
            missingFilename = filename
        } catch {
            Issue.record("Expected missingReference, received \(error)")
        }
        #expect(missingFilename == filename)
        #expect(!FileManager.default.fileExists(atPath: reference.path))
    }

    @Test func failureArtifactsIncludeExpectedReceivedAndDiff() throws {
        let expected = solidImageData(color: .systemRed, size: CGSize(width: 10, height: 10))
        let received = solidImageData(color: .systemBlue, size: CGSize(width: 10, height: 10))
        let filename = "comparator-artifact-test.png"

        let artifacts = try SnapshotTester.writeFailureArtifacts(
            named: filename,
            expectedData: expected,
            receivedData: received
        )
        defer {
            try? FileManager.default.removeItem(at: artifacts.expected)
            try? FileManager.default.removeItem(at: artifacts.received)
            try? FileManager.default.removeItem(at: artifacts.diff)
        }

        #expect(FileManager.default.fileExists(atPath: artifacts.expected.path))
        #expect(FileManager.default.fileExists(atPath: artifacts.received.path))
        #expect(FileManager.default.fileExists(atPath: artifacts.diff.path))
        #expect((try? Data(contentsOf: artifacts.diff).isEmpty) == false)
    }

    private func solidImageData(color: UIColor, size: CGSize) -> Data {
        imageData(size: size) { context in
            color.setFill()
            context.fill(CGRect(origin: .zero, size: size))
        }
    }

    private func imageData(
        size: CGSize,
        drawing: (UIGraphicsImageRendererContext) -> Void
    ) -> Data {
        let format = UIGraphicsImageRendererFormat()
        format.scale = 1
        format.opaque = false
        let renderer = UIGraphicsImageRenderer(size: size, format: format)
        return renderer.pngData(actions: drawing)
    }
}
#endif
