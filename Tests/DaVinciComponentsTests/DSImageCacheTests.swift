import Foundation
import Testing
import UIKit
@testable import DaVinciComponents

@MainActor
@Suite("DSImageCache")
struct DSImageCacheTests {
    @Test func cacheStoresAndReturnsDecodedImage() async {
        let cache = DSImageCache(costLimit: 10)
        let key = testKey("one")
        let image = decodedImage(cost: 4, marker: 1)

        #expect(await cache.insert(image, for: key))
        #expect(await cache.image(for: key)?.data == image.data)
        #expect(await cache.totalCost == 4)
        #expect(await cache.count == 1)
    }

    @Test func cacheOverwritesCostForSameURL() async {
        let cache = DSImageCache(costLimit: 10)
        let key = testKey("same")

        await cache.insert(decodedImage(cost: 3, marker: 1), for: key)
        await cache.insert(decodedImage(cost: 7, marker: 2), for: key)

        #expect(await cache.image(for: key)?.data == Data([2]))
        #expect(await cache.totalCost == 7)
        #expect(await cache.count == 1)
    }

    @Test func cacheEvictsLeastRecentlyUsedItemsByCost() async {
        let cache = DSImageCache(costLimit: 10)
        let first = testKey("first")
        let second = testKey("second")
        let third = testKey("third")

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
        let key = testKey("oversized")

        let inserted = await cache.insert(decodedImage(cost: 6, marker: 1), for: key)

        #expect(!inserted)
        #expect(await cache.image(for: key) == nil)
        #expect(await cache.totalCost == 0)
    }

    @Test func removeAllResetsEntriesAndCost() async {
        let cache = DSImageCache(costLimit: 10)
        await cache.insert(decodedImage(cost: 4, marker: 1), for: testKey("one"))
        await cache.insert(decodedImage(cost: 4, marker: 2), for: testKey("two"))

        await cache.removeAll()

        #expect(await cache.isEmpty)
        #expect(await cache.totalCost == 0)
    }

    @Test func defaultCacheLimitIsExplicit() async {
        let cache = DSImageCache()

        #expect(await cache.costLimit == 50 * 1_024 * 1_024)
        #expect(type(of: DSImageCache.shared) == DSImageCache.self)
    }

    // MARK: - Loader Scoping

    @Test func sameURLWithDifferentLoaderIdentitiesStaysIsolated() async {
        let cache = DSImageCache(costLimit: 100)
        let url = testURL("shared")
        let authenticated = DSImageRequestKey(url: url, loaderIdentity: "authenticated")
        let anonymous = DSImageRequestKey(url: url, loaderIdentity: "anonymous")

        await cache.insert(decodedImage(cost: 4, marker: 1), for: authenticated)
        await cache.insert(decodedImage(cost: 4, marker: 2), for: anonymous)

        #expect(await cache.image(for: authenticated)?.data == Data([1]))
        #expect(await cache.image(for: anonymous)?.data == Data([2]))
        #expect(await cache.count == 2)
    }

    @Test func loaderIdentityDefaultsToTheConformingType() {
        let mock = MockImageLoader()
        let production = DSDefaultImageLoader()

        #expect(mock.cacheIdentity != production.cacheIdentity)
        #expect(mock.cacheIdentity == MockImageLoader().cacheIdentity)
    }

    @Test func requestKeyCombinesURLAndLoaderIdentity() {
        let url = testURL("key")
        let fromLoader = DSImageRequestKey(url: url, loader: MockImageLoader())
        let fromIdentity = DSImageRequestKey(
            url: url,
            loaderIdentity: MockImageLoader().cacheIdentity
        )

        #expect(fromLoader == fromIdentity)
        #expect(fromLoader != DSImageRequestKey(url: url, loaderIdentity: "other"))
    }

    @Test func requestKeySeparatesDifferentPayloadLimits() {
        let url = testURL("limit")
        let smaller = DSImageRequestKey(
            url: url,
            loaderIdentity: "shared",
            maximumPayloadBytes: 64
        )
        let larger = DSImageRequestKey(
            url: url,
            loaderIdentity: "shared",
            maximumPayloadBytes: 128
        )

        #expect(smaller != larger)
    }

    private func testURL(_ path: String) -> URL {
        URL(string: "https://example.com/\(path).png")!
    }

    private func testKey(_ path: String) -> DSImageRequestKey {
        DSImageRequestKey(url: testURL(path), loaderIdentity: "test")
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
