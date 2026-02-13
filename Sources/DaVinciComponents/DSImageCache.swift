import Foundation

// MARK: - DSImageCache

/// A simple in-memory image data cache with FIFO eviction.
/// Internal to DaVinciComponents — not part of the public API.
actor DSImageCache {

    /// Shared singleton used by `DSRemoteImage`.
    static let shared = DSImageCache()

    private let capacity: Int
    private var store: [URL: Data] = [:]
    private var insertionOrder: [URL] = []

    init(capacity: Int = 150) {
        self.capacity = capacity
    }

    func data(for url: URL) -> Data? {
        store[url]
    }

    func setData(_ data: Data, for url: URL) {
        if store[url] == nil {
            // Evict oldest entry if at capacity
            if insertionOrder.count >= capacity {
                let oldest = insertionOrder.removeFirst()
                store.removeValue(forKey: oldest)
            }
            insertionOrder.append(url)
        }
        store[url] = data
    }

    /// Remove all cached entries. Useful for debug/testing.
    func removeAll() {
        store.removeAll()
        insertionOrder.removeAll()
    }
}
