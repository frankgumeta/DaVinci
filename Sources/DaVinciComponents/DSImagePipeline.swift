import Foundation
import ImageIO

#if canImport(UIKit)
import UIKit
internal typealias DSPlatformImage = UIImage
#elseif canImport(AppKit)
import AppKit
internal typealias DSPlatformImage = NSImage
#endif

/// A validated, eagerly decoded image and its estimated memory cost.
internal struct DSDecodedImage: @unchecked Sendable {
    let data: Data
    let image: DSPlatformImage
    let pixelWidth: Int
    let pixelHeight: Int
    let memoryCost: Int
}

internal enum DSImageDecoder {
    static func decode(
        _ data: Data,
        maximumPayloadBytes: Int,
        maximumPixelCount: Int
    ) async throws -> DSDecodedImage {
        guard !data.isEmpty else {
            throw DSImageLoadingError.emptyData
        }
        guard data.count <= maximumPayloadBytes else {
            throw DSImageLoadingError.payloadTooLarge(
                limit: maximumPayloadBytes,
                actual: data.count
            )
        }

        return try await Task.detached(priority: .utility) {
            try decodeSynchronously(data, maximumPixelCount: maximumPixelCount)
        }.value
    }

    private static func decodeSynchronously(
        _ data: Data,
        maximumPixelCount: Int
    ) throws -> DSDecodedImage {
        try Task.checkCancellation()
        guard let source = CGImageSourceCreateWithData(data as CFData, nil),
              let properties = CGImageSourceCopyPropertiesAtIndex(source, 0, nil)
                as? [CFString: Any],
              let width = (properties[kCGImagePropertyPixelWidth] as? NSNumber)?.intValue,
              let height = (properties[kCGImagePropertyPixelHeight] as? NSNumber)?.intValue,
              width > 0,
              height > 0 else {
            throw DSImageLoadingError.invalidImageData
        }

        let pixelCount = try validatedPixelCount(
            width: width,
            height: height,
            maximumPixelCount: maximumPixelCount
        )
        guard let cgImage = CGImageSourceCreateImageAtIndex(
            source,
            0,
            [kCGImageSourceShouldCacheImmediately: true] as CFDictionary
        ) else {
            throw DSImageLoadingError.invalidImageData
        }

        let (decodedBytes, byteOverflow) = pixelCount.multipliedReportingOverflow(by: 4)
        let (memoryCost, costOverflow) = decodedBytes.addingReportingOverflow(data.count)
        guard !byteOverflow, !costOverflow else {
            throw DSImageLoadingError.pixelLimitExceeded(
                limit: maximumPixelCount,
                actual: pixelCount
            )
        }

        #if canImport(UIKit)
        let platformImage = UIImage(cgImage: cgImage)
        #elseif canImport(AppKit)
        let platformImage = NSImage(
            cgImage: cgImage,
            size: NSSize(width: width, height: height)
        )
        #endif

        return DSDecodedImage(
            data: data,
            image: platformImage,
            pixelWidth: width,
            pixelHeight: height,
            memoryCost: memoryCost
        )
    }

    private static func validatedPixelCount(
        width: Int,
        height: Int,
        maximumPixelCount: Int
    ) throws -> Int {
        let (pixelCount, overflow) = width.multipliedReportingOverflow(by: height)
        guard !overflow, pixelCount <= maximumPixelCount else {
            throw DSImageLoadingError.pixelLimitExceeded(
                limit: maximumPixelCount,
                actual: overflow ? .max : pixelCount
            )
        }
        return pixelCount
    }
}

/// Coordinates validation, decoded-image caching, and request deduplication.
///
/// Caching and deduplication are scoped by `DSImageRequestKey`, so requests are
/// only shared between consumers that use the same URL *and* an equivalent
/// loader identity.
internal actor DSImagePipeline {
    static let shared = DSImagePipeline(cache: .shared)

    static let defaultMaximumPayloadBytes = DSDefaultImageLoader.defaultMaximumPayloadBytes
    static let defaultMaximumPixelCount = 40_000_000

    private let cache: DSImageCache
    private let maximumPayloadBytesOverride: Int?
    private let maximumPixelCount: Int
    private var inFlight: [DSImageRequestKey: Task<DSDecodedImage, Error>] = [:]

    init(
        cache: DSImageCache = DSImageCache(),
        maximumPayloadBytes: Int? = nil,
        maximumPixelCount: Int = DSImagePipeline.defaultMaximumPixelCount
    ) {
        self.cache = cache
        self.maximumPayloadBytesOverride = maximumPayloadBytes.map { max(0, $0) }
        self.maximumPixelCount = maximumPixelCount
    }

    func image(for url: URL, using loader: any DSImageLoading) async throws -> DSDecodedImage {
        let loaderMaximumPayloadBytes = max(0, loader.maximumPayloadBytes)
        let maximumPayloadBytes = maximumPayloadBytesOverride.map {
            min($0, loaderMaximumPayloadBytes)
        } ?? loaderMaximumPayloadBytes
        let key = DSImageRequestKey(
            url: url,
            loader: loader,
            maximumPayloadBytes: maximumPayloadBytes
        )

        if let cached = await cache.image(for: key) {
            return cached
        }

        if let existing = inFlight[key] {
            let image = try await existing.value
            try Task.checkCancellation()
            return image
        }

        let maximumPixelCount = maximumPixelCount
        let request = Task {
            let data = try await loader.loadImageData(from: url)
            try Task.checkCancellation()
            return try await DSImageDecoder.decode(
                data,
                maximumPayloadBytes: maximumPayloadBytes,
                maximumPixelCount: maximumPixelCount
            )
        }
        inFlight[key] = request

        do {
            let image = try await request.value
            inFlight[key] = nil
            await cache.insert(image, for: key)
            try Task.checkCancellation()
            return image
        } catch {
            inFlight[key] = nil
            throw error
        }
    }

    func removeAllCachedImages() async {
        await cache.removeAll()
    }

    var inFlightCount: Int {
        inFlight.count
    }
}
