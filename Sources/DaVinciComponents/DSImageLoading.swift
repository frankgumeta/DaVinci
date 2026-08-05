import Foundation
import SwiftUI

// MARK: - DSImageLoading

/// A protocol for loading image data from a URL.
/// Inject a custom implementation via the `dsImageLoader` environment value
/// for testing or preview use.
public protocol DSImageLoading: Sendable {
    func loadImageData(from url: URL) async throws -> Data

    /// Maximum payload size accepted by the pipeline for this loader.
    ///
    /// Loaders that stream network responses should enforce the same limit during
    /// transfer. The pipeline validates it again before decoding and caching.
    var maximumPayloadBytes: Int { get }

    /// Scopes cached and in-flight results so unrelated loaders never share a payload.
    ///
    /// The default implementation is derived from the conforming type, which means
    /// two different loader types requesting the same URL stay isolated. Override it
    /// when a single type can produce *different* bytes for the same URL — for
    /// example a loader configured with per-user credentials, a specific
    /// `URLSession`, or a tenant-specific host.
    var cacheIdentity: String { get }
}

extension DSImageLoading {
    /// Uses the production loader's 20 MB ceiling unless a conformer declares
    /// a different policy.
    public var maximumPayloadBytes: Int {
        DSDefaultImageLoader.defaultMaximumPayloadBytes
    }

    /// Derives the cache identity from the conforming type's fully qualified name.
    public var cacheIdentity: String {
        String(reflecting: Self.self)
    }
}

/// Errors produced while validating a remote image response or payload.
public enum DSImageLoadingError: Error, Equatable, Sendable {
    case invalidResponse
    case unacceptableStatusCode(Int)
    case unsupportedMIMEType(String?)
    case emptyData
    case payloadTooLarge(limit: Int, actual: Int)
    case invalidImageData
    case pixelLimitExceeded(limit: Int, actual: Int)
}

// MARK: - DSDefaultImageLoader

/// Default production loader backed by `URLSession`.
///
/// The loader validates HTTP 200–299 responses and supported image MIME types
/// before accepting any body bytes, and it enforces `maximumPayloadBytes`
/// *during* the transfer:
///
/// - A declared `Content-Length` above the limit is rejected before the body is
///   transferred at all.
/// - A response without a declared length is accumulated incrementally and the
///   transfer is cancelled as soon as the limit is exceeded.
///
/// This keeps a hostile or misconfigured server from buffering an unbounded
/// payload in memory.
public struct DSDefaultImageLoader: DSImageLoading {

    /// Maximum number of bytes accepted for a single image response.
    public static let defaultMaximumPayloadBytes = 20 * 1_024 * 1_024

    private let session: URLSession
    private let cacheNamespace: String

    public let maximumPayloadBytes: Int

    /// Includes the session scope in cache identity so independently configured
    /// sessions never share authenticated or tenant-specific responses by default.
    public var cacheIdentity: String {
        "\(String(reflecting: Self.self))|\(cacheNamespace)"
    }

    /// Creates a bounded loader.
    ///
    /// Distinct sessions are isolated automatically. Supply the same
    /// `cacheNamespace` to intentionally share cached results across equivalent
    /// sessions, or a user/tenant-specific namespace when session credentials can
    /// change without replacing the session.
    public init(
        session: URLSession = .shared,
        maximumPayloadBytes: Int = DSDefaultImageLoader.defaultMaximumPayloadBytes,
        cacheNamespace: String? = nil
    ) {
        self.session = session
        self.maximumPayloadBytes = max(0, maximumPayloadBytes)
        self.cacheNamespace = cacheNamespace ?? "session:\(ObjectIdentifier(session))"
    }

    public func loadImageData(from url: URL) async throws -> Data {
        let download = DSBoundedImageDownload(maximumPayloadBytes: maximumPayloadBytes)
        let task = session.dataTask(with: url)
        task.delegate = download

        let data = try await download.resume(task)
        guard !data.isEmpty else {
            throw DSImageLoadingError.emptyData
        }
        return data
    }

    internal static let supportedMIMETypes: Set<String> = [
        "image/bmp",
        "image/gif",
        "image/heic",
        "image/heif",
        "image/jpeg",
        "image/png",
        "image/tiff",
        "image/webp"
    ]
}

// MARK: - DSBoundedImageDownload

/// Streams a single image response while enforcing a hard byte ceiling.
///
/// `URLSession` delivers delegate callbacks on its own queue, so every mutable
/// property is guarded by `lock`. That manual synchronization is why the type is
/// `@unchecked Sendable`.
private final class DSBoundedImageDownload: NSObject, URLSessionDataDelegate, @unchecked Sendable {

    private let maximumPayloadBytes: Int
    private let lock = NSLock()
    private var buffer = Data()
    private var receivedBytes = 0
    private var failure: DSImageLoadingError?
    private var continuation: CheckedContinuation<Data, Error>?

    init(maximumPayloadBytes: Int) {
        self.maximumPayloadBytes = maximumPayloadBytes
    }

    /// Starts `task` and waits for the bounded payload.
    func resume(_ task: URLSessionDataTask) async throws -> Data {
        try await withTaskCancellationHandler {
            try await withCheckedThrowingContinuation { continuation in
                lock.lock()
                self.continuation = continuation
                lock.unlock()
                task.resume()
            }
        } onCancel: {
            task.cancel()
        }
    }

    // MARK: - Response validation

    func urlSession(
        _ session: URLSession,
        dataTask: URLSessionDataTask,
        didReceive response: URLResponse
    ) async -> URLSession.ResponseDisposition {
        if let failure = Self.validate(response, maximumPayloadBytes: maximumPayloadBytes) {
            record(failure)
            return .cancel
        }
        return .allow
    }

    /// Validates response metadata before any body byte is accepted.
    private static func validate(
        _ response: URLResponse,
        maximumPayloadBytes: Int
    ) -> DSImageLoadingError? {
        guard let http = response as? HTTPURLResponse else {
            return .invalidResponse
        }
        guard (200...299).contains(http.statusCode) else {
            return .unacceptableStatusCode(http.statusCode)
        }
        guard DSDefaultImageLoader.supportedMIMETypes.contains(
            http.mimeType?.lowercased() ?? ""
        ) else {
            return .unsupportedMIMEType(http.mimeType)
        }

        let declaredLength = response.expectedContentLength
        if declaredLength != NSURLSessionTransferSizeUnknown,
           declaredLength > Int64(maximumPayloadBytes) {
            return .payloadTooLarge(
                limit: maximumPayloadBytes,
                actual: Int(clamping: declaredLength)
            )
        }
        return nil
    }

    // MARK: - Bounded accumulation

    func urlSession(
        _ session: URLSession,
        dataTask: URLSessionDataTask,
        didReceive data: Data
    ) {
        lock.lock()
        guard failure == nil else {
            lock.unlock()
            return
        }

        receivedBytes += data.count
        guard receivedBytes <= maximumPayloadBytes else {
            failure = .payloadTooLarge(limit: maximumPayloadBytes, actual: receivedBytes)
            buffer = Data()
            lock.unlock()
            dataTask.cancel()
            return
        }

        buffer.append(data)
        lock.unlock()
    }

    // MARK: - Completion

    func urlSession(
        _ session: URLSession,
        task: URLSessionTask,
        didCompleteWithError error: Error?
    ) {
        lock.lock()
        let continuation = self.continuation
        self.continuation = nil
        let failure = self.failure
        let data = buffer
        buffer = Data()
        lock.unlock()

        guard let continuation else { return }
        if let failure {
            continuation.resume(throwing: failure)
        } else if let error {
            continuation.resume(throwing: error)
        } else {
            continuation.resume(returning: data)
        }
    }

    private func record(_ error: DSImageLoadingError) {
        lock.lock()
        if failure == nil {
            failure = error
        }
        lock.unlock()
    }
}

// MARK: - Environment Integration

private struct DSImageLoaderKey: EnvironmentKey {
    static let defaultValue: any DSImageLoading = DSDefaultImageLoader()
}

extension EnvironmentValues {
    /// The image loader used by `DSRemoteImage`.
    /// Override in previews or tests with a custom `DSImageLoading` conformer.
    public var dsImageLoader: any DSImageLoading {
        get { self[DSImageLoaderKey.self] }
        set { self[DSImageLoaderKey.self] = newValue }
    }
}
