import Foundation

protocol UserLibraryStorage {
    func loadFavorites() async throws -> [MediaItem]
    func saveFavorites(_ items: [MediaItem]) async throws
    func loadHistory() async throws -> [SearchRecord]
    func saveHistory(_ records: [SearchRecord]) async throws
}

actor UserDefaultsLibraryStorage: UserLibraryStorage {
    nonisolated(unsafe) private let defaults: UserDefaults
    private let encoder: JSONEncoder = {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        return encoder
    }()
    private let decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return decoder
    }()
    private let favoritesKey: String
    private let historyKey: String

    init(defaults: UserDefaults = .standard, keyPrefix: String = "vibefinder") {
        self.defaults = defaults
        self.favoritesKey = "\(keyPrefix).favorites"
        self.historyKey = "\(keyPrefix).history"
    }

    func loadFavorites() async throws -> [MediaItem] {
        try load([MediaItem].self, forKey: favoritesKey) ?? []
    }

    func saveFavorites(_ items: [MediaItem]) async throws {
        try save(items, forKey: favoritesKey)
    }

    func loadHistory() async throws -> [SearchRecord] {
        try load([SearchRecord].self, forKey: historyKey) ?? []
    }

    func saveHistory(_ records: [SearchRecord]) async throws {
        try save(records, forKey: historyKey)
    }

    private func load<T: Decodable>(_ type: T.Type, forKey key: String) throws -> T? {
        guard let data = defaults.data(forKey: key) else {
            return nil
        }
        return try decoder.decode(T.self, from: data)
    }

    private func save<T: Encodable>(_ value: T, forKey key: String) throws {
        let data = try encoder.encode(value)
        defaults.set(data, forKey: key)
    }
}

actor InMemoryLibraryStorage: UserLibraryStorage {
    private var favorites: [MediaItem]
    private var history: [SearchRecord]

    init(favorites: [MediaItem] = [], history: [SearchRecord] = []) {
        self.favorites = favorites
        self.history = history
    }

    func loadFavorites() async throws -> [MediaItem] {
        favorites
    }

    func saveFavorites(_ items: [MediaItem]) async throws {
        favorites = items
    }

    func loadHistory() async throws -> [SearchRecord] {
        history
    }

    func saveHistory(_ records: [SearchRecord]) async throws {
        history = records
    }
}
