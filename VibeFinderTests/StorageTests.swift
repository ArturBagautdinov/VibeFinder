import Foundation
import Testing
@testable import VibeFinder

@MainActor
struct StorageTests {
    
    @Test func userDefaultsStorageSavesAndRestoresFavoritesAndHistory() async throws {
        let keyPrefix = "VibeFinderTests.\(UUID().uuidString)"
        let defaults = UserDefaults.standard
        defer {
            defaults.removeObject(forKey: "\(keyPrefix).favorites")
            defaults.removeObject(forKey: "\(keyPrefix).history")
        }

        let storage = UserDefaultsLibraryStorage(defaults: defaults, keyPrefix: keyPrefix)
        let favorite = MediaItem.testItem(title: "Arrival")
        let record = SearchRecord(
            prompt: "quiet sci-fi",
            createdAt: Date(timeIntervalSince1970: 1_000),
            results: [favorite]
        )

        try await storage.saveFavorites([favorite])
        try await storage.saveHistory([record])
        defaults.synchronize()

        let restoredStorage = UserDefaultsLibraryStorage(defaults: defaults, keyPrefix: keyPrefix)
        let restoredFavorites = try await restoredStorage.loadFavorites()
        let restoredHistory = try await restoredStorage.loadHistory()

        #expect(restoredFavorites == [favorite])
        #expect(restoredHistory == [record])
    }

    @Test func inMemoryStorageSavesAndLoadsData() async throws {
        let storage = InMemoryLibraryStorage()
        let item = MediaItem.testItem(title: "Severance", category: .series)
        let record = SearchRecord(prompt: "weird office mystery", results: [item])

        try await storage.saveFavorites([item])
        try await storage.saveHistory([record])

        #expect(try await storage.loadFavorites() == [item])
        #expect(try await storage.loadHistory() == [record])
    }

    @Test func storageClearsSavedLibraryData() async throws {
        let keyPrefix = "VibeFinderTests.\(UUID().uuidString)"
        let defaults = UserDefaults.standard
        defer {
            defaults.removeObject(forKey: "\(keyPrefix).favorites")
            defaults.removeObject(forKey: "\(keyPrefix).history")
        }

        let storage = UserDefaultsLibraryStorage(defaults: defaults, keyPrefix: keyPrefix)
        let item = MediaItem.testItem()
        let record = SearchRecord(prompt: "dark mystery", results: [item])

        try await storage.saveFavorites([item])
        try await storage.saveHistory([record])
        try await storage.clearLibraryData()

        #expect(try await storage.loadFavorites().isEmpty)
        #expect(try await storage.loadHistory().isEmpty)
    }
}
