import Foundation

actor ArtworkMemoryCache {
    private var values: [String: URL] = [:]

    func value(for key: String) -> URL? {
        values[key]
    }

    func insert(_ url: URL, for key: String) {
        values[key] = url
    }
}

