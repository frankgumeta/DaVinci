import Foundation
import SwiftUI

// MARK: - DSImageLoading

/// A protocol for loading image data from a URL.
/// Inject a custom implementation via the `dsImageLoader` environment value
/// for testing or preview use.
public protocol DSImageLoading: Sendable {
    func loadImageData(from url: URL) async throws -> Data
}

// MARK: - DSDefaultImageLoader

/// Default production loader backed by `URLSession.shared`.
/// Validates HTTP 200–299 status codes.
public struct DSDefaultImageLoader: DSImageLoading {

    public init() {}

    public func loadImageData(from url: URL) async throws -> Data {
        let (data, response) = try await URLSession.shared.data(from: url)
        if let http = response as? HTTPURLResponse,
           !(200...299).contains(http.statusCode) {
            throw URLError(.badServerResponse)
        }
        return data
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
