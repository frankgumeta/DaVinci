import Foundation
import Testing
import UIKit
@testable import DaVinciComponents

private actor CountingImageLoader: DSImageLoading {
    private(set) var requestCount = 0
    private let data: Data
    private let delay: Duration

    init(data: Data, delay: Duration = .zero) {
        self.data = data
        self.delay = delay
    }

    func loadImageData(from url: URL) async throws -> Data {
        requestCount += 1
        if delay > .zero {
            try await Task.sleep(for: delay)
        }
        return data
    }
}

@MainActor
@Suite("DSImagePipeline")
struct DSImagePipelineTests {
    @Test func concurrentRequestsForSameURLShareOneLoad() async throws {
        let loader = CountingImageLoader(data: makePNGData())
        let pipeline = makePipeline()
        let url = testURL("shared")

        async let first = pipeline.image(for: url, using: loader)
        async let second = pipeline.image(for: url, using: loader)
        let images = try await [first, second]

        #expect(images.count == 2)
        #expect(await loader.requestCount == 1)
        #expect(await pipeline.inFlightCount == 0)
    }

    @Test func decodedCachePreventsASecondLoad() async throws {
        let loader = CountingImageLoader(data: makePNGData())
        let pipeline = makePipeline()
        let url = testURL("cached")

        _ = try await pipeline.image(for: url, using: loader)
        _ = try await pipeline.image(for: url, using: loader)

        #expect(await loader.requestCount == 1)
    }

    @Test func pipelineRejectsPayloadAboveConfiguredLimit() async {
        let loader = CountingImageLoader(data: Data([1, 2, 3]))
        let pipeline = DSImagePipeline(
            cache: DSImageCache(costLimit: 100),
            maximumPayloadBytes: 2,
            maximumPixelCount: 100
        )

        await expectError(.payloadTooLarge(limit: 2, actual: 3)) {
            try await pipeline.image(for: testURL("large"), using: loader)
        }
    }

    @Test func pipelineRejectsDecodedImageAbovePixelLimit() async {
        let loader = CountingImageLoader(data: makePNGData(size: 2))
        let pipeline = DSImagePipeline(
            cache: DSImageCache(costLimit: 100),
            maximumPayloadBytes: 10_000,
            maximumPixelCount: 3
        )

        await expectError(.pixelLimitExceeded(limit: 3, actual: 4)) {
            try await pipeline.image(for: testURL("pixels"), using: loader)
        }
    }

    @Test func cancelledConsumerDoesNotReceiveCompletedSharedRequest() async {
        let loader = CountingImageLoader(data: makePNGData(), delay: .milliseconds(50))
        let pipeline = makePipeline()
        let request = Task {
            await DSRemoteImage.loadImage(
                from: testURL("cancelled"),
                using: loader,
                pipeline: pipeline
            )
        }

        await Task.yield()
        request.cancel()
        let result = await request.value

        guard case .cancelled = result else {
            Issue.record("A cancelled consumer must not update the view")
            return
        }
        #expect(await loader.requestCount == 1)
    }

    @Test func rapidURLChangeCancelsOldConsumerAndLoadsNewURL() async {
        let oldLoader = CountingImageLoader(data: makePNGData(), delay: .milliseconds(50))
        let newLoader = CountingImageLoader(data: makePNGData())
        let pipeline = makePipeline()
        let oldRequest = Task {
            await DSRemoteImage.loadImage(
                from: testURL("old"),
                using: oldLoader,
                pipeline: pipeline
            )
        }

        await Task.yield()
        oldRequest.cancel()
        let newResult = await DSRemoteImage.loadImage(
            from: testURL("new"),
            using: newLoader,
            pipeline: pipeline
        )
        let oldResult = await oldRequest.value

        guard case .cancelled = oldResult else {
            Issue.record("The old URL consumer must remain cancelled")
            return
        }
        guard case .success = newResult else {
            Issue.record("The new URL must load independently")
            return
        }
        #expect(await oldLoader.requestCount == 1)
        #expect(await newLoader.requestCount == 1)
    }

    @Test func failedRequestIsRemovedSoItCanRetry() async {
        let loader = CountingImageLoader(data: Data([1, 2, 3]))
        let pipeline = makePipeline()
        let url = testURL("retry")

        for _ in 0..<2 {
            do {
                _ = try await pipeline.image(for: url, using: loader)
                Issue.record("Expected invalid image data")
            } catch {
                #expect(error as? DSImageLoadingError == .invalidImageData)
            }
        }

        #expect(await loader.requestCount == 2)
        #expect(await pipeline.inFlightCount == 0)
    }

    private func makePipeline() -> DSImagePipeline {
        DSImagePipeline(cache: DSImageCache(costLimit: 1_024 * 1_024))
    }

    private func testURL(_ path: String) -> URL {
        URL(string: "https://example.com/\(path).png")!
    }

    private func makePNGData(size: CGFloat = 2) -> Data {
        let format = UIGraphicsImageRendererFormat()
        format.scale = 1
        let renderer = UIGraphicsImageRenderer(
            size: CGSize(width: size, height: size),
            format: format
        )
        return renderer.pngData { context in
            UIColor.systemTeal.setFill()
            context.fill(CGRect(x: 0, y: 0, width: size, height: size))
        }
    }

    private func expectError(
        _ expected: DSImageLoadingError,
        operation: () async throws -> DSDecodedImage
    ) async {
        do {
            _ = try await operation()
            Issue.record("Expected \(expected)")
        } catch let error as DSImageLoadingError {
            #expect(error == expected)
        } catch {
            Issue.record("Unexpected error: \(error)")
        }
    }
}
