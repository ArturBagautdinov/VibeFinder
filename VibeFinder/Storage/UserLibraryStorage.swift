import Foundation

protocol UserLibraryStorage {
    func loadFavorites() async throws -> [MediaItem]
    func saveFavorites(_ items: [MediaItem]) async throws
    func loadHistory() async throws -> [SearchRecord]
    func saveHistory(_ records: [SearchRecord]) async throws
    func clearLibraryData() async throws
}
