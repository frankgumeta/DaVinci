import Foundation
import Testing
import UIKit
@testable import DaVinciComponents

// MARK: - Mock Image Loader

struct MockImageLoader: DSImageLoading {
    let shouldSucceed: Bool
    let mockData: Data

    init(shouldSucceed: Bool = true, mockData: Data = Data([1, 2, 3, 4])) {
        self.shouldSucceed = shouldSucceed
        self.mockData = mockData
    }

    func loadImageData(from url: URL) async throws -> Data {
        if shouldSucceed {
            return mockData
        }
        throw URLError(.badServerResponse)
    }
}

// MARK: - URL Protocol Stub

private final class ImageURLProtocolStub: URLProtocol, @unchecked Sendable {
    nonisolated(unsafe) static var response: URLResponse?
    nonisolated(unsafe) static var data = Data()

    override static func canInit(with request: URLRequest) -> Bool { true }
    override static func canonicalRequest(for request: URLRequest) -> URLRequest { request }

    override func startLoading() {
        guard let response = Self.response else {
            client?.urlProtocol(self, didFailWithError: URLError(.badServerResponse))
            return
        }
        client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
        client?.urlProtocol(self, didLoad: Self.data)
        client?.urlProtocolDidFinishLoading(self)
    }

    override func stopLoading() {}
}

@Suite("DSImageLoading", .serialized)
struct DSImageLoadingTests {
    @Test func defaultLoaderAcceptsSuccessfulSupportedImageResponse() async throws {
        configure(statusCode: 200, mimeType: "image/png", data: Data([1, 2, 3]))

        let data = try await makeLoader().loadImageData(from: testURL)

        #expect(data == Data([1, 2, 3]))
    }

    @Test func defaultLoaderRejectsNonSuccessHTTPStatus() async {
        configure(statusCode: 404, mimeType: "image/png", data: Data([1]))

        await expectError(.unacceptableStatusCode(404)) {
            try await makeLoader().loadImageData(from: testURL)
        }
    }

    @Test func defaultLoaderRejectsUnsupportedMIMEType() async {
        configure(statusCode: 200, mimeType: "text/plain", data: Data([1]))

        do {
            _ = try await makeLoader().loadImageData(from: testURL)
            Issue.record("Expected an unsupported MIME type error")
        } catch DSImageLoadingError.unsupportedMIMEType(let mimeType) {
            #expect(mimeType != nil)
        } catch {
            Issue.record("Unexpected error: \(error)")
        }
    }

    @Test func defaultLoaderRejectsEmptyPayload() async {
        configure(statusCode: 200, mimeType: "image/jpeg", data: Data())

        await expectError(.emptyData) {
            try await makeLoader().loadImageData(from: testURL)
        }
    }

    @Test func defaultLoaderRejectsNonHTTPResponse() async {
        ImageURLProtocolStub.response = URLResponse(
            url: testURL,
            mimeType: "image/png",
            expectedContentLength: 1,
            textEncodingName: nil
        )
        ImageURLProtocolStub.data = Data([1])

        await expectError(.invalidResponse) {
            try await makeLoader().loadImageData(from: testURL)
        }
    }

    @Test @MainActor func productionFlowAcceptsValidImageFromHTTP200() async {
        configure(statusCode: 200, mimeType: "image/png", data: makePNGData())
        let pipeline = DSImagePipeline(cache: DSImageCache(costLimit: 1_024))

        let result = await DSRemoteImage.loadImage(
            from: testURL,
            using: makeLoader(),
            pipeline: pipeline
        )

        guard case .success = result else {
            Issue.record("A valid HTTP image should reach success")
            return
        }
    }

    @Test func productionFlowRejectsCorruptImageFromHTTP200() async {
        configure(statusCode: 200, mimeType: "image/png", data: Data([1, 2, 3]))
        let pipeline = DSImagePipeline(cache: DSImageCache(costLimit: 1_024))

        let result = await DSRemoteImage.loadImage(
            from: testURL,
            using: makeLoader(),
            pipeline: pipeline
        )

        guard case .failure = result else {
            Issue.record("Corrupt HTTP image data must fail")
            return
        }
    }

    @Test func injectedMockLoaderStillSupportsPreviewsAndTests() async throws {
        let data = try await MockImageLoader(mockData: Data([5, 6])).loadImageData(from: testURL)
        #expect(data == Data([5, 6]))
    }

    private var testURL: URL {
        URL(string: "https://example.com/image.png")!
    }

    private func configure(statusCode: Int, mimeType: String, data: Data) {
        ImageURLProtocolStub.response = HTTPURLResponse(
            url: testURL,
            statusCode: statusCode,
            httpVersion: nil,
            headerFields: ["Content-Type": mimeType]
        )
        ImageURLProtocolStub.data = data
    }

    private func makeLoader() -> DSDefaultImageLoader {
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [ImageURLProtocolStub.self]
        return DSDefaultImageLoader(session: URLSession(configuration: configuration))
    }

    @MainActor
    private func makePNGData() -> Data {
        let format = UIGraphicsImageRendererFormat()
        format.scale = 1
        let renderer = UIGraphicsImageRenderer(
            size: CGSize(width: 2, height: 2),
            format: format
        )
        return renderer.pngData { context in
            UIColor.systemBlue.setFill()
            context.fill(CGRect(x: 0, y: 0, width: 2, height: 2))
        }
    }

    private func expectError(
        _ expected: DSImageLoadingError,
        operation: () async throws -> Data
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
