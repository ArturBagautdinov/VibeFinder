import Foundation

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

    func clearLibraryData() async throws {
        favorites = []
        history = []
    }
}
