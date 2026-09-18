import Foundation
import Testing
import UIKit
@testable import DaVinciComponents

@Suite("Performance Baselines", .serialized)
struct DSPerformanceBaselineTests {

    private static let warmupIterations = 5
    private static let measurementIterations = 20

    @Test(.timeLimit(.minutes(1)))
    func imageCacheHandlesSustainedLRUTraffic() async {
        let image = DSDecodedImage(
            data: Data([0]),
            image: UIImage(),
            pixelWidth: 1,
            pixelHeight: 1,
            memoryCost: 5
        )

        let measurements = await Self.measureAsync {
            let cache = DSImageCache(costLimit: 2_000_000)
            for index in 0..<5_000 {
                let key = DSImageRequestKey(
                    url: URL(string: "https://example.com/\(index % 200).png")!,
                    loaderIdentity: "performance"
                )
                await cache.insert(image, for: key)
                _ = await cache.image(for: key)
            }
            #expect(await cache.count == 200)
        }

        let p95 = Self.percentile(measurements, at: 0.95)
        print("Image cache: median=\(Self.percentile(measurements, at: 0.50)), p95=\(p95)")
        #expect(p95 < .seconds(5), "Cache P95 baseline regressed: \(p95)")
    }

    @Test(.timeLimit(.minutes(1)))
    func imageDecoderMaintainsThroughputBaseline() async throws {
        let format = UIGraphicsImageRendererFormat()
        format.scale = 1
        let renderer = UIGraphicsImageRenderer(
            size: CGSize(width: 512, height: 512),
            format: format
        )
        let data = renderer.pngData { context in
            UIColor.systemBlue.setFill()
            context.fill(CGRect(x: 0, y: 0, width: 512, height: 512))
        }
        let measurements = try await Self.measureAsync {
            for _ in 0..<10 {
                _ = try await DSImageDecoder.decode(
                    data,
                    maximumPayloadBytes: 5_000_000,
                    maximumPixelCount: 1_000_000
                )
            }
        }

        let p95 = Self.percentile(measurements, at: 0.95)
        print("Image decoder: median=\(Self.percentile(measurements, at: 0.50)), p95=\(p95)")
        #expect(p95 < .seconds(5), "Decoder P95 baseline regressed: \(p95)")
    }

    private static func measureAsync(
        _ operation: () async throws -> Void
    ) async rethrows -> [Duration] {
        for _ in 0..<warmupIterations {
            try await operation()
        }

        let clock = ContinuousClock()
        var measurements: [Duration] = []
        measurements.reserveCapacity(measurementIterations)

        for _ in 0..<measurementIterations {
            let elapsed = try await clock.measure {
                try await operation()
            }
            measurements.append(elapsed)
        }
        return measurements
    }

    private static func percentile(_ values: [Duration], at percentile: Double) -> Duration {
        precondition(!values.isEmpty)
        precondition((0...1).contains(percentile))
        let sorted = values.sorted()
        let index = min(
            sorted.count - 1,
            Int((Double(sorted.count - 1) * percentile).rounded(.up))
        )
        return sorted[index]
    }
}
