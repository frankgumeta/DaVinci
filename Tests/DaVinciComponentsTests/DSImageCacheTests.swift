import Foundation
import Testing
import UIKit
@testable import DaVinciComponents

@MainActor
@Suite("DSImageCache")
struct DSImageCacheTests {
    @Test func cacheStoresAndReturnsDecodedImage() async {
        let cache = DSImageCache(costLimit: 10)
        let url = testURL("one")
        let image = decodedImage(cost: 4, marker: 1)

        #expect(await cache.insert(image, for: url))
        #expect(await cache.image(for: url)?.data == image.data)
        #expect(await cache.totalCost == 4)
        #expect(await cache.count == 1)
    }

    @Test func cacheOverwritesCostForSameURL() async {
        let cache = DSImageCache(costLimit: 10)
        let url = testURL("same")

        await cache.insert(decodedImage(cost: 3, marker: 1), for: url)
        await cache.insert(decodedImage(cost: 7, marker: 2), for: url)

        #expect(await cache.image(for: url)?.data == Data([2]))
        #expect(await cache.totalCost == 7)
        #expect(await cache.count == 1)
    }

    @Test func cacheEvictsLeastRecentlyUsedItemsByCost() async {
        let cache = DSImageCache(costLimit: 10)
        let first = testURL("first")
        let second = testURL("second")
        let third = testURL("third")

        await cache.insert(decodedImage(cost: 4, marker: 1), for: first)
        await cache.insert(decodedImage(cost: 4, marker: 2), for: second)
        _ = await cache.image(for: first)
        await cache.insert(decodedImage(cost: 4, marker: 3), for: third)

        #expect(await cache.image(for: first) != nil)
        #expect(await cache.image(for: second) == nil)
        #expect(await cache.image(for: third) != nil)
        #expect(await cache.totalCost == 8)
    }

    @Test func cacheRejectsAnItemLargerThanItsBudget() async {
        let cache = DSImageCache(costLimit: 5)
        let url = testURL("oversized")

        let inserted = await cache.insert(decodedImage(cost: 6, marker: 1), for: url)

        #expect(!inserted)
        #expect(await cache.image(for: url) == nil)
        #expect(await cache.totalCost == 0)
    }

    @Test func removeAllResetsEntriesAndCost() async {
        let cache = DSImageCache(costLimit: 10)
        await cache.insert(decodedImage(cost: 4, marker: 1), for: testURL("one"))
        await cache.insert(decodedImage(cost: 4, marker: 2), for: testURL("two"))

        await cache.removeAll()

        #expect(await cache.isEmpty)
        #expect(await cache.totalCost == 0)
    }

    @Test func defaultCacheLimitIsExplicit() async {
        let cache = DSImageCache()

        #expect(await cache.costLimit == 50 * 1_024 * 1_024)
        #expect(type(of: DSImageCache.shared) == DSImageCache.self)
    }

    private func testURL(_ path: String) -> URL {
        URL(string: "https://example.com/\(path).png")!
    }

    private func decodedImage(cost: Int, marker: UInt8) -> DSDecodedImage {
        DSDecodedImage(
            data: Data([marker]),
            image: UIImage(),
            pixelWidth: 1,
            pixelHeight: 1,
            memoryCost: cost
        )
    }
}
