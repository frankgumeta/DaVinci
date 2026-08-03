import Foundation

// MARK: - DSImageCache

/// An in-memory decoded-image cache with a deterministic LRU cost limit.
/// Internal to DaVinciComponents — not part of the public API.
actor DSImageCache {

    /// Shared singleton used by `DSRemoteImage`.
    static let shared = DSImageCache()

    static let defaultCostLimit = 50 * 1_024 * 1_024

    let costLimit: Int
    private var store: [URL: DSDecodedImage] = [:]
    private var usageOrder: [URL] = []
    private(set) var totalCost = 0

    init(costLimit: Int = DSImageCache.defaultCostLimit) {
        self.costLimit = max(0, costLimit)
    }

    func image(for url: URL) -> DSDecodedImage? {
        guard let image = store[url] else { return nil }
        markAsRecentlyUsed(url)
        return image
    }

    @discardableResult
    func insert(_ image: DSDecodedImage, for url: URL) -> Bool {
        remove(url)

        guard image.memoryCost <= costLimit else {
            return false
        }

        while totalCost + image.memoryCost > costLimit,
              let leastRecentlyUsed = usageOrder.first {
            remove(leastRecentlyUsed)
        }

        store[url] = image
        usageOrder.append(url)
        totalCost += image.memoryCost
        return true
    }

    /// Remove all cached entries. Useful for debug/testing.
    func removeAll() {
        store.removeAll()
        usageOrder.removeAll()
        totalCost = 0
    }

    var count: Int {
        store.count
    }

    var isEmpty: Bool {
        store.isEmpty
    }

    private func markAsRecentlyUsed(_ url: URL) {
        usageOrder.removeAll { $0 == url }
        usageOrder.append(url)
    }

    private func remove(_ url: URL) {
        if let removed = store.removeValue(forKey: url) {
            totalCost -= removed.memoryCost
        }
        usageOrder.removeAll { $0 == url }
    }
}
