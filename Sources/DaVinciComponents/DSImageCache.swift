import Foundation

// MARK: - DSImageRequestKey

/// Identity of a cached or in-flight image request.
///
/// The loader identity is part of the key so that two loaders which may return
/// different bytes for the same URL — an authenticated client and an anonymous
/// one, or a preview mock and the production loader — never share a payload.
internal struct DSImageRequestKey: Hashable, Sendable {
    let url: URL
    let loaderIdentity: String
    let maximumPayloadBytes: Int

    init(
        url: URL,
        loader: any DSImageLoading,
        maximumPayloadBytes: Int? = nil
    ) {
        self.url = url
        self.loaderIdentity = loader.cacheIdentity
        self.maximumPayloadBytes = maximumPayloadBytes ?? max(0, loader.maximumPayloadBytes)
    }

    init(
        url: URL,
        loaderIdentity: String,
        maximumPayloadBytes: Int = DSDefaultImageLoader.defaultMaximumPayloadBytes
    ) {
        self.url = url
        self.loaderIdentity = loaderIdentity
        self.maximumPayloadBytes = max(0, maximumPayloadBytes)
    }
}

// MARK: - DSImageCache

/// An in-memory decoded-image cache with a deterministic LRU cost limit.
/// Internal to DaVinciComponents — not part of the public API.
actor DSImageCache {

    /// Shared singleton used by `DSRemoteImage`.
    static let shared = DSImageCache()

    static let defaultCostLimit = 50 * 1_024 * 1_024

    let costLimit: Int
    private var store: [DSImageRequestKey: DSDecodedImage] = [:]
    private var usageOrder: [DSImageRequestKey] = []
    private(set) var totalCost = 0

    init(costLimit: Int = DSImageCache.defaultCostLimit) {
        self.costLimit = max(0, costLimit)
    }

    func image(for key: DSImageRequestKey) -> DSDecodedImage? {
        guard let image = store[key] else { return nil }
        markAsRecentlyUsed(key)
        return image
    }

    @discardableResult
    func insert(_ image: DSDecodedImage, for key: DSImageRequestKey) -> Bool {
        remove(key)

        guard image.memoryCost <= costLimit else {
            return false
        }

        while totalCost + image.memoryCost > costLimit,
              let leastRecentlyUsed = usageOrder.first {
            remove(leastRecentlyUsed)
        }

        store[key] = image
        usageOrder.append(key)
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

    private func markAsRecentlyUsed(_ key: DSImageRequestKey) {
        usageOrder.removeAll { $0 == key }
        usageOrder.append(key)
    }

    private func remove(_ key: DSImageRequestKey) {
        if let removed = store.removeValue(forKey: key) {
            totalCost -= removed.memoryCost
        }
        usageOrder.removeAll { $0 == key }
    }
}
