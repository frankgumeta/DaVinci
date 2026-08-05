import Testing
import SwiftUI
import Foundation
import UIKit
@testable import DaVinciTokens
@testable import DaVinciComponents

// MARK: - DSRemoteImage Behavior Tests

@Suite("DSRemoteImage Behavior")
@MainActor
struct DSRemoteImageBehaviorTests {

    // MARK: - Accessibility Label Resolution (Loading Phase)

    @Test func loadingPhaseWithCustomLabel() {
        let label = DSRemoteImage.resolveAccessibilityLabel(
            phase: .loading,
            customLabel: "Profile photo loading",
            url: URL(string: "https://example.com/photo.jpg")
        )
        #expect(label == "Profile photo loading")
    }

    @Test func loadingPhaseWithoutCustomLabel() {
        let label = DSRemoteImage.resolveAccessibilityLabel(
            phase: .loading,
            customLabel: nil,
            url: URL(string: "https://example.com/photo.jpg")
        )
        #expect(label == "Loading image")
    }

    @Test func loadingPhaseNilURLWithoutCustomLabel() {
        let label = DSRemoteImage.resolveAccessibilityLabel(
            phase: .loading,
            customLabel: nil,
            url: nil
        )
        #expect(label == "Loading image")
    }

    // MARK: - Accessibility Label Resolution (Success Phase)

    @Test func successPhaseWithCustomLabel() {
        let label = DSRemoteImage.resolveAccessibilityLabel(
            phase: .success,
            customLabel: "User avatar",
            url: URL(string: "https://example.com/avatar.jpg")
        )
        #expect(label == "User avatar")
    }

    @Test func successPhaseWithURLNoCustomLabel() {
        let label = DSRemoteImage.resolveAccessibilityLabel(
            phase: .success,
            customLabel: nil,
            url: URL(string: "https://example.com/photo.jpg")
        )
        #expect(label == "Remote image")
    }

    @Test func successPhaseNilURLNoCustomLabel() {
        let label = DSRemoteImage.resolveAccessibilityLabel(
            phase: .success,
            customLabel: nil,
            url: nil
        )
        #expect(label == "Placeholder image")
    }

    // MARK: - Accessibility Label Resolution (Failure Phase)

    @Test func failurePhaseWithCustomLabel() {
        let label = DSRemoteImage.resolveAccessibilityLabel(
            phase: .failure,
            customLabel: "Could not load photo",
            url: URL(string: "https://example.com/broken.jpg")
        )
        #expect(label == "Could not load photo")
    }

    @Test func failurePhaseWithoutCustomLabel() {
        let label = DSRemoteImage.resolveAccessibilityLabel(
            phase: .failure,
            customLabel: nil,
            url: URL(string: "https://example.com/broken.jpg")
        )
        #expect(label == "Image failed to load")
    }

    @Test func failurePhaseNilURLWithoutCustomLabel() {
        let label = DSRemoteImage.resolveAccessibilityLabel(
            phase: .failure,
            customLabel: nil,
            url: nil
        )
        #expect(label == "Placeholder image")
    }

    @Test func nilURLIsNotAnnouncedAsAFailure() {
        let descriptor = DSRemoteImage.accessibilityDescriptor(
            phase: .failure,
            customLabel: nil,
            url: nil,
            isDecorative: false
        )

        #expect(descriptor.label == "Placeholder image")
        #expect(descriptor.value == nil)
    }

    @Test func failedRemoteURLStillAnnouncesFailure() {
        let descriptor = DSRemoteImage.accessibilityDescriptor(
            phase: .failure,
            customLabel: nil,
            url: URL(string: "https://example.com/broken.jpg"),
            isDecorative: false
        )

        #expect(descriptor.label == "Image failed to load")
        #expect(descriptor.value == "Failed to load")
    }

    // MARK: - Deterministic Initial Phase

    @Test func nilURLStartsInThePlaceholderPhase() {
        #expect(DSRemoteImage.initialPhase(for: nil) == .failure)
    }

    @Test func validURLStartsInTheLoadingPhase() {
        let url = URL(string: "https://example.com/photo.jpg")
        #expect(DSRemoteImage.initialPhase(for: url) == .loading)
    }

    // MARK: - Custom Label Always Wins

    @Test func customLabelOverridesAllPhases() {
        let phases: [DSRemoteImage.AccessibilityPhase] = [.loading, .success, .failure]
        for phase in phases {
            let label = DSRemoteImage.resolveAccessibilityLabel(
                phase: phase,
                customLabel: "Custom",
                url: URL(string: "https://example.com/img.jpg")
            )
            #expect(label == "Custom")
        }
    }

    // MARK: - ContentMode Enum

    @Test func contentModeValues() {
        let fill = DSRemoteImage.ContentMode.fill
        let fit = DSRemoteImage.ContentMode.fit

        // Verify they are distinct enum cases
        #expect(String(describing: fill) != String(describing: fit))
    }

    // MARK: - Component Loading Flow

    @Test func componentFlowOnlyReportsSuccessAfterDecoding() async {
        let pipeline = DSImagePipeline(cache: DSImageCache(costLimit: 1_024 * 1_024))
        let result = await DSRemoteImage.loadImage(
            from: URL(string: "https://example.com/valid.png"),
            using: MockImageLoader(mockData: makePNGData()),
            pipeline: pipeline
        )

        guard case .success(let image) = result else {
            Issue.record("Expected a decoded success result")
            return
        }
        #expect(image.pixelWidth == 2)
        #expect(image.pixelHeight == 2)
    }

    @Test func componentFlowRejectsCorruptDataAndNilURL() async {
        let pipeline = DSImagePipeline(cache: DSImageCache(costLimit: 1_024))
        let corrupt = await DSRemoteImage.loadImage(
            from: URL(string: "https://example.com/corrupt.png"),
            using: MockImageLoader(mockData: Data([1, 2, 3])),
            pipeline: pipeline
        )
        let missing = await DSRemoteImage.loadImage(
            from: nil,
            using: MockImageLoader(),
            pipeline: pipeline
        )

        guard case .failure = corrupt else {
            Issue.record("Corrupt data must not become success")
            return
        }
        guard case .failure = missing else {
            Issue.record("A nil URL must fail")
            return
        }
    }

    private func makePNGData() -> Data {
        let format = UIGraphicsImageRendererFormat()
        format.scale = 1
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 2, height: 2), format: format)
        return renderer.pngData { context in
            UIColor.systemBlue.setFill()
            context.fill(CGRect(x: 0, y: 0, width: 2, height: 2))
        }
    }
}
