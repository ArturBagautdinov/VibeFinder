import Foundation
import Testing
@testable import VibeFinder

@MainActor
struct LibraryViewModelTests {
    
    @Test func toggleFavoriteAddsAndRemovesItem() {
        let viewModel = LibraryViewModel(storage: InMemoryLibraryStorage())
        let item = MediaItem.testItem()

        viewModel.toggleFavorite(item)
        #expect(viewModel.favorites == [item])
        #expect(viewModel.isFavorite(item))

        viewModel.toggleFavorite(item)
        #expect(viewModel.favorites.isEmpty)
        #expect(!viewModel.isFavorite(item))
    }

    @Test func favoriteSearchFiltersByTitleGenreAndCategory() {
        let movie = MediaItem.testItem(title: "Arrival", category: .movie, genre: "Sci-Fi")
        let game = MediaItem.testItem(title: "Outer Wilds", category: .game, genre: "Adventure")
        let viewModel = LibraryViewModel(storage: InMemoryLibraryStorage(favorites: [movie, game]))
        viewModel.favorites = [movie, game]

        viewModel.favoritesSearchText = "outer"
        #expect(viewModel.visibleFavorites == [game])

        viewModel.favoritesSearchText = "movie"
        #expect(viewModel.visibleFavorites == [movie])
    }

    @Test func favoriteCategoryFilterShowsOnlySelectedCategory() {
        let movie = MediaItem.testItem(title: "Arrival", category: .movie)
        let series = MediaItem.testItem(title: "Severance", category: .series)
        let viewModel = LibraryViewModel(storage: InMemoryLibraryStorage())
        viewModel.favorites = [movie, series]

        viewModel.favoriteCategoryFilter = .series

        #expect(viewModel.visibleFavorites == [series])
    }

    @Test func favoritesSortAZZAAndYear() {
        let oldMovie = MediaItem.testItem(title: "Blade Runner", year: "1982")
        let newGame = MediaItem.testItem(title: "Outer Wilds", category: .game, year: "2019")
        let middleSeries = MediaItem.testItem(title: "Severance", category: .series, year: "2022")
        let viewModel = LibraryViewModel(storage: InMemoryLibraryStorage())
        viewModel.favorites = [middleSeries, newGame, oldMovie]

        viewModel.favoriteSortOption = .titleAscending
        #expect(viewModel.visibleFavorites.map(\.title) == ["Blade Runner", "Outer Wilds", "Severance"])

        viewModel.favoriteSortOption = .titleDescending
        #expect(viewModel.visibleFavorites.map(\.title) == ["Severance", "Outer Wilds", "Blade Runner"])

        viewModel.favoriteSortOption = .newestYear
        #expect(viewModel.visibleFavorites.map(\.year) == ["2022", "2019", "1982"])

        viewModel.favoriteSortOption = .oldestYear
        #expect(viewModel.visibleFavorites.map(\.year) == ["1982", "2019", "2022"])
    }

    @Test func historySearchSortAndDeleteWork() async throws {
        let first = SearchRecord(
            prompt: "cozy game",
            createdAt: Date(timeIntervalSince1970: 10),
            results: [.testItem(title: "Stardew Valley", category: .game)]
        )
        let second = SearchRecord(
            prompt: "dark series",
            createdAt: Date(timeIntervalSince1970: 20),
            results: [.testItem(title: "Severance", category: .series), .testItem(title: "Dark", category: .series)]
        )
        let viewModel = LibraryViewModel(storage: InMemoryLibraryStorage())

        try await viewModel.addHistoryRecord(first)
        try await viewModel.addHistoryRecord(second)

        viewModel.historySearchText = "game"
        #expect(viewModel.visibleHistory == [first])

        viewModel.historySearchText = ""
        viewModel.historySortOption = .oldestFirst
        #expect(viewModel.visibleHistory == [first, second])

        viewModel.historySortOption = .mostResults
        #expect(viewModel.visibleHistory == [second, first])

        viewModel.historySortOption = .promptAscending
        #expect(viewModel.visibleHistory.map(\.prompt) == ["cozy game", "dark series"])

        viewModel.historySortOption = .promptDescending
        #expect(viewModel.visibleHistory.map(\.prompt) == ["dark series", "cozy game"])

        viewModel.deleteHistoryRecord(second)
        #expect(viewModel.history == [first])
    }

    @Test func duplicateHistoryPromptReplacesPreviousRecord() async throws {
        let viewModel = LibraryViewModel(storage: InMemoryLibraryStorage())
        let oldRecord = SearchRecord(prompt: "space", results: [.testItem(title: "Arrival")])
        let newRecord = SearchRecord(prompt: "SPACE", results: [.testItem(title: "Outer Wilds", category: .game)])

        try await viewModel.addHistoryRecord(oldRecord)
        try await viewModel.addHistoryRecord(newRecord)

        #expect(viewModel.history.count == 1)
        #expect(viewModel.history.first?.results.first?.title == "Outer Wilds")
    }
}
