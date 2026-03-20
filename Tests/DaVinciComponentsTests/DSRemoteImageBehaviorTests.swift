import Testing
import SwiftUI
import Foundation
@testable import DaVinciTokens
@testable import DaVinciComponents

// MARK: - DSRemoteImage Behavior Tests

@Suite("DSRemoteImage Behavior")
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
        #expect(label == "Image failed to load")
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

    // MARK: - Image Loader Mock Integration

    @Test func mockLoaderSucceedsWithData() async throws {
        let mockData = Data([10, 20, 30, 40, 50])
        let loader = MockImageLoader(shouldSucceed: true, mockData: mockData)
        let url = URL(string: "https://example.com/test.jpg")!

        let data = try await loader.loadImageData(from: url)
        #expect(data == mockData)
    }

    @Test func mockLoaderFailsWithError() async {
        let loader = MockImageLoader(shouldSucceed: false)
        let url = URL(string: "https://example.com/test.jpg")!

        do {
            _ = try await loader.loadImageData(from: url)
            #expect(Bool(false), "Expected loader to throw")
        } catch {
            #expect(error is URLError)
        }
    }

    // MARK: - Cache Integration

    @Test func cacheStoresAndRetrievesData() async {
        let cache = DSImageCache(capacity: 10)
        let url = URL(string: "https://example.com/cached.jpg")!
        let data = Data([1, 2, 3])

        await cache.setData(data, for: url)
        let retrieved = await cache.data(for: url)
        #expect(retrieved == data)
    }

    @Test func cacheMissReturnsNil() async {
        let cache = DSImageCache(capacity: 10)
        let url = URL(string: "https://example.com/miss.jpg")!

        let retrieved = await cache.data(for: url)
        #expect(retrieved == nil)
    }
}
