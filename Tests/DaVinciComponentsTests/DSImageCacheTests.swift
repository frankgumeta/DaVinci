import Testing
import Foundation
@testable import DaVinciComponents

// MARK: - DSImageCache Tests

@Suite("DSImageCache")
struct DSImageCacheTests {

    @Test func cacheSingleItem() async {
        let cache = DSImageCache(capacity: 10)
        let url = URL(string: "https://example.com/image1.jpg")!
        let data = Data([1, 2, 3, 4, 5])

        await cache.setData(data, for: url)
        let retrieved = await cache.data(for: url)

        #expect(retrieved == data)
    }

    @Test func cacheReturnsNilForMissingURL() async {
        let cache = DSImageCache(capacity: 10)
        let url = URL(string: "https://example.com/missing.jpg")!

        let retrieved = await cache.data(for: url)

        #expect(retrieved == nil)
    }

    @Test func cacheOverwritesSameURL() async {
        let cache = DSImageCache(capacity: 10)
        let url = URL(string: "https://example.com/image.jpg")!
        let data1 = Data([1, 2, 3])
        let data2 = Data([4, 5, 6, 7])

        await cache.setData(data1, for: url)
        await cache.setData(data2, for: url)
        let retrieved = await cache.data(for: url)

        #expect(retrieved == data2)
        #expect(retrieved != data1)
    }

    @Test func cacheEvictsOldestWhenAtCapacity() async {
        let cache = DSImageCache(capacity: 3)
        let url1 = URL(string: "https://example.com/1.jpg")!
        let url2 = URL(string: "https://example.com/2.jpg")!
        let url3 = URL(string: "https://example.com/3.jpg")!
        let url4 = URL(string: "https://example.com/4.jpg")!

        let data1 = Data([1])
        let data2 = Data([2])
        let data3 = Data([3])
        let data4 = Data([4])

        await cache.setData(data1, for: url1)
        await cache.setData(data2, for: url2)
        await cache.setData(data3, for: url3)
        await cache.setData(data4, for: url4)

        let retrieved1 = await cache.data(for: url1)
        let retrieved2 = await cache.data(for: url2)
        let retrieved3 = await cache.data(for: url3)
        let retrieved4 = await cache.data(for: url4)

        #expect(retrieved1 == nil)
        #expect(retrieved2 == data2)
        #expect(retrieved3 == data3)
        #expect(retrieved4 == data4)
    }

    @Test func cacheRemoveAllClearsEntries() async {
        let cache = DSImageCache(capacity: 10)
        let url1 = URL(string: "https://example.com/1.jpg")!
        let url2 = URL(string: "https://example.com/2.jpg")!

        await cache.setData(Data([1]), for: url1)
        await cache.setData(Data([2]), for: url2)

        await cache.removeAll()

        let retrieved1 = await cache.data(for: url1)
        let retrieved2 = await cache.data(for: url2)

        #expect(retrieved1 == nil)
        #expect(retrieved2 == nil)
    }

    @Test func cacheHandlesMultipleDifferentURLs() async {
        let cache = DSImageCache(capacity: 100)
        var urls: [URL] = []
        var dataMap: [URL: Data] = [:]

        for i in 1...10 {
            let url = URL(string: "https://example.com/image\(i).jpg")!
            let data = Data([UInt8(i)])
            urls.append(url)
            dataMap[url] = data
            await cache.setData(data, for: url)
        }

        for url in urls {
            let retrieved = await cache.data(for: url)
            #expect(retrieved == dataMap[url])
        }
    }

    @Test func sharedCacheExists() async {
        let shared = DSImageCache.shared
        #expect(type(of: shared) == DSImageCache.self)
    }

    @Test func cachePreservesInsertionOrder() async {
        let cache = DSImageCache(capacity: 5)
        let urls = (1...5).map { URL(string: "https://example.com/\($0).jpg")! }

        for (index, url) in urls.enumerated() {
            await cache.setData(Data([UInt8(index)]), for: url)
        }

        let newURL = URL(string: "https://example.com/new.jpg")!
        await cache.setData(Data([99]), for: newURL)

        let firstURLData = await cache.data(for: urls[0])
        #expect(firstURLData == nil)

        for index in 1..<urls.count {
            let data = await cache.data(for: urls[index])
            #expect(data != nil)
        }
    }
}
