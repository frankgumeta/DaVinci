import Foundation
import SwiftUI
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
    /// When set, the body is delivered in chunks of this size to simulate streaming.
    nonisolated(unsafe) static var chunkSize: Int?

    static func reset() {
        response = nil
        data = Data()
        chunkSize = nil
    }

    override static func canInit(with request: URLRequest) -> Bool { true }
    override static func canonicalRequest(for request: URLRequest) -> URLRequest { request }

    override func startLoading() {
        guard let response = Self.response else {
            client?.urlProtocol(self, didFailWithError: URLError(.badServerResponse))
            return
        }
        client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)

        if let chunkSize = Self.chunkSize, chunkSize > 0 {
            var offset = Self.data.startIndex
            while offset < Self.data.endIndex {
                let end = min(Self.data.index(offset, offsetBy: chunkSize), Self.data.endIndex)
                client?.urlProtocol(self, didLoad: Data(Self.data[offset..<end]))
                offset = end
            }
        } else {
            client?.urlProtocol(self, didLoad: Self.data)
        }

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

    // MARK: - Transfer-time payload limit

    /// The reported `actual` size is the *declared* length rather than the number of
    /// bytes the stub emitted, which proves the rejection came from response
    /// metadata instead of from accumulating the body.
    @Test func declaredContentLengthAboveLimitIsRejectedFromResponseMetadata() async {
        configure(
            statusCode: 200,
            mimeType: "image/png",
            data: Data(repeating: 0xAB, count: 64),
            declaredContentLength: 4_096
        )

        await expectError(.payloadTooLarge(limit: 32, actual: 4_096)) {
            try await makeLoader(maximumPayloadBytes: 32).loadImageData(from: testURL)
        }
    }

    @Test func undeclaredPayloadAboveLimitIsRejectedDuringTransfer() async {
        configure(
            statusCode: 200,
            mimeType: "image/png",
            data: Data(repeating: 0xCD, count: 256),
            chunkSize: 32
        )

        do {
            _ = try await makeLoader(maximumPayloadBytes: 64).loadImageData(from: testURL)
            Issue.record("Expected the transfer to be aborted")
        } catch DSImageLoadingError.payloadTooLarge(let limit, let actual) {
            #expect(limit == 64)
            #expect(actual > 64)
        } catch {
            Issue.record("Unexpected error: \(error)")
        }
    }

    @Test func payloadAtTheLimitIsAccepted() async throws {
        let payload = Data(repeating: 0xEF, count: 64)
        configure(
            statusCode: 200,
            mimeType: "image/png",
            data: payload,
            declaredContentLength: payload.count,
            chunkSize: 16
        )

        let data = try await makeLoader(maximumPayloadBytes: 64)
            .loadImageData(from: testURL)

        #expect(data == payload)
    }

    @Test func unacceptableStatusDiscardsTheBodyEvenWhenItWouldFitTheLimit() async {
        configure(
            statusCode: 500,
            mimeType: "image/png",
            data: Data(repeating: 0x01, count: 128)
        )

        await expectError(.unacceptableStatusCode(500)) {
            try await makeLoader().loadImageData(from: testURL)
        }
    }

    @Test func defaultPayloadLimitIsExplicit() {
        #expect(DSDefaultImageLoader.defaultMaximumPayloadBytes == 20 * 1_024 * 1_024)
        #expect(
            DSImagePipeline.defaultMaximumPayloadBytes
                == DSDefaultImageLoader.defaultMaximumPayloadBytes
        )
    }

    @Test func defaultLoaderIdentitySeparatesDistinctSessions() {
        let firstSession = URLSession(configuration: .ephemeral)
        let secondSession = URLSession(configuration: .ephemeral)
        let first = DSDefaultImageLoader(session: firstSession)
        let second = DSDefaultImageLoader(session: secondSession)

        #expect(first.cacheIdentity != second.cacheIdentity)
    }

    @Test func explicitNamespaceCanShareIdentityAcrossSessions() {
        let first = DSDefaultImageLoader(
            session: URLSession(configuration: .ephemeral),
            cacheNamespace: "public-images"
        )
        let second = DSDefaultImageLoader(
            session: URLSession(configuration: .ephemeral),
            cacheNamespace: "public-images"
        )

        #expect(first.cacheIdentity == second.cacheIdentity)
    }

    @Test func configuredPayloadLimitIsExposedToThePipeline() {
        let loader = DSDefaultImageLoader(maximumPayloadBytes: 123)

        #expect(loader.maximumPayloadBytes == 123)
    }

    @Test func transportFailuresArePropagatedUnchanged() async {
        ImageURLProtocolStub.reset()

        do {
            _ = try await makeLoader().loadImageData(from: testURL)
            Issue.record("Expected the transport error to propagate")
        } catch let error as DSImageLoadingError {
            Issue.record("Transport errors must not be reported as \(error)")
        } catch {
            #expect(error is URLError)
        }
    }

    @Test @MainActor func imageLoaderEnvironmentValueCanBeOverridden() {
        var values = EnvironmentValues()
        #expect(values.dsImageLoader is DSDefaultImageLoader)

        values.dsImageLoader = MockImageLoader()

        #expect(values.dsImageLoader is MockImageLoader)
    }

    private var testURL: URL {
        URL(string: "https://example.com/image.png")!
    }

    private func configure(
        statusCode: Int,
        mimeType: String,
        data: Data,
        declaredContentLength: Int? = nil,
        chunkSize: Int? = nil
    ) {
        ImageURLProtocolStub.reset()
        var headerFields = ["Content-Type": mimeType]
        if let declaredContentLength {
            headerFields["Content-Length"] = String(declaredContentLength)
        }
        ImageURLProtocolStub.response = HTTPURLResponse(
            url: testURL,
            statusCode: statusCode,
            httpVersion: nil,
            headerFields: headerFields
        )
        ImageURLProtocolStub.data = data
        ImageURLProtocolStub.chunkSize = chunkSize
    }

    private func makeLoader(
        maximumPayloadBytes: Int = DSDefaultImageLoader.defaultMaximumPayloadBytes
    ) -> DSDefaultImageLoader {
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [ImageURLProtocolStub.self]
        return DSDefaultImageLoader(
            session: URLSession(configuration: configuration),
            maximumPayloadBytes: maximumPayloadBytes
        )
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
