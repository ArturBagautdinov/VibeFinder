import Foundation

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

    func clearLibraryData() async throws {
        defaults.removeObject(forKey: favoritesKey)
        defaults.removeObject(forKey: historyKey)
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
