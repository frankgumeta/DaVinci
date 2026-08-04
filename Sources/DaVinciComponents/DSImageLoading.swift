import Foundation
import SwiftUI

// MARK: - DSImageLoading

/// A protocol for loading image data from a URL.
/// Inject a custom implementation via the `dsImageLoader` environment value
/// for testing or preview use.
public protocol DSImageLoading: Sendable {
    func loadImageData(from url: URL) async throws -> Data
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
/// Validates HTTP 200–299 responses and supported image MIME types.
public struct DSDefaultImageLoader: DSImageLoading {
    private let session: URLSession

    public init(session: URLSession = .shared) {
        self.session = session
    }

    public func loadImageData(from url: URL) async throws -> Data {
        let (data, response) = try await session.data(from: url)
        guard let http = response as? HTTPURLResponse else {
            throw DSImageLoadingError.invalidResponse
        }
        guard (200...299).contains(http.statusCode) else {
            throw DSImageLoadingError.unacceptableStatusCode(http.statusCode)
        }
        guard Self.supportedMIMETypes.contains(http.mimeType?.lowercased() ?? "") else {
            throw DSImageLoadingError.unsupportedMIMEType(http.mimeType)
        }
        guard !data.isEmpty else {
            throw DSImageLoadingError.emptyData
        }
        return data
    }

    private static let supportedMIMETypes: Set<String> = [
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
