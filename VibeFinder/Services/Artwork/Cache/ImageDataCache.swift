import Foundation

actor ImageDataCache {
    private var values: [URL: Data] = [:]

    func value(for url: URL) -> Data? {
        values[url]
    }

    func insert(_ data: Data, for url: URL) {
        values[url] = data
    }
}

