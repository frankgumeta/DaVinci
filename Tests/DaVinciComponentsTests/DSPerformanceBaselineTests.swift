import Foundation
import Testing
import UIKit
@testable import DaVinciComponents

@Suite("Performance Baselines", .serialized)
struct DSPerformanceBaselineTests {
    @Test(.timeLimit(.minutes(1)))
    func imageCacheHandlesSustainedLRUTraffic() async {
        let cache = DSImageCache(costLimit: 2_000_000)
        let image = DSDecodedImage(
            data: Data([0]),
            image: UIImage(),
            pixelWidth: 1,
            pixelHeight: 1,
            memoryCost: 5
        )
        let clock = ContinuousClock()

        let elapsed = await clock.measure {
            for index in 0..<5_000 {
                let key = DSImageRequestKey(
                    url: URL(string: "https://example.com/\(index % 200).png")!,
                    loaderIdentity: "performance"
                )
                await cache.insert(image, for: key)
                _ = await cache.image(for: key)
            }
        }

        #expect(elapsed < .seconds(5), "Cache baseline regressed: \(elapsed)")
        #expect(await cache.count == 200)
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
        let clock = ContinuousClock()

        let elapsed = try await clock.measure {
            for _ in 0..<10 {
                _ = try await DSImageDecoder.decode(
                    data,
                    maximumPayloadBytes: 5_000_000,
                    maximumPixelCount: 1_000_000
                )
            }
        }

        #expect(elapsed < .seconds(5), "Decoder baseline regressed: \(elapsed)")
    }
}
