import Foundation
import Observation

@MainActor
@Observable
final class LibraryViewModel {
    var favorites: [MediaItem] = []
    var history: [SearchRecord] = []
    var favoritesSearchText = ""
    var historySearchText = ""
    var favoriteCategoryFilter: MediaCategory?
    var favoriteSortOption: FavoriteSortOption = .recentlyAdded
    var historySortOption: HistorySortOption = .newestFirst

    private let storage: any UserLibraryStorage

    init(storage: any UserLibraryStorage) {
        self.storage = storage
    }

    var sortedFavorites: [MediaItem] {
        sortFavorites(favorites)
    }

    var visibleFavorites: [MediaItem] {
        let filteredItems = favorites.filter { item in
            let matchesCategory = favoriteCategoryFilter == nil || item.category == favoriteCategoryFilter
            let matchesSearch = favoritesSearchText.trimmed.isEmpty || item.matches(favoritesSearchText)
            return matchesCategory && matchesSearch
        }
        return sortFavorites(filteredItems)
    }

    var visibleHistory: [SearchRecord] {
        let query = historySearchText.trimmed
        let filteredRecords: [SearchRecord]
        if query.isEmpty {
            filteredRecords = history
        } else {
            filteredRecords = history.filter { $0.matches(query) }
        }
        return sortHistory(filteredRecords)
    }

    func sections(for record: SearchRecord) -> [MediaSection] {
        sections(for: record.results)
    }

    func loadSavedData() async {
        do {
            async let storedFavorites = storage.loadFavorites()
            async let storedHistory = storage.loadHistory()
            favorites = try await storedFavorites
            history = try await storedHistory
        } catch {
            favorites = []
            history = []
        }
    }

    func addHistoryRecord(_ record: SearchRecord) async throws {
        history.removeAll { $0.prompt.caseInsensitiveCompare(record.prompt) == .orderedSame }
        history.insert(record, at: 0)
        history = Array(history.prefix(20))
        try await storage.saveHistory(history)
    }

    func toggleFavorite(_ item: MediaItem) {
        if let index = favorites.firstIndex(where: { $0.title == item.title && $0.category == item.category }) {
            favorites.remove(at: index)
        } else {
            favorites.insert(item, at: 0)
        }

        let updatedFavorites = favorites
        Task {
            try? await storage.saveFavorites(updatedFavorites)
        }
    }

    func isFavorite(_ item: MediaItem) -> Bool {
        favorites.contains { $0.title == item.title && $0.category == item.category }
    }

    func deleteHistory(at offsets: IndexSet) {
        for index in offsets.sorted(by: >) {
            history.remove(at: index)
        }
        saveHistory()
    }

    func deleteHistoryRecord(_ record: SearchRecord) {
        history.removeAll { $0.id == record.id }
        saveHistory()
    }

    private func saveHistory() {
        let updatedHistory = history
        Task {
            try? await storage.saveHistory(updatedHistory)
        }
    }

    private func sections(for items: [MediaItem]) -> [MediaSection] {
        MediaCategory.allCases.compactMap { category in
            let categoryItems = items.filter { $0.category == category }
            guard !categoryItems.isEmpty else {
                return nil
            }
            return MediaSection(category: category, items: categoryItems)
        }
    }

    private func sortFavorites(_ items: [MediaItem]) -> [MediaItem] {
        switch favoriteSortOption {
        case .recentlyAdded:
            return items
        case .titleAscending:
            return items.sorted {
                $0.title.localizedCaseInsensitiveCompare($1.title) == .orderedAscending
            }
        case .titleDescending:
            return items.sorted {
                $0.title.localizedCaseInsensitiveCompare($1.title) == .orderedDescending
            }
        case .newestYear:
            return items.sorted {
                $0.year.sortableYear > $1.year.sortableYear
            }
        case .oldestYear:
            return items.sorted {
                $0.year.sortableYear < $1.year.sortableYear
            }
        }
    }

    private func sortHistory(_ records: [SearchRecord]) -> [SearchRecord] {
        switch historySortOption {
        case .newestFirst:
            return records.sorted { $0.createdAt > $1.createdAt }
        case .oldestFirst:
            return records.sorted { $0.createdAt < $1.createdAt }
        case .mostResults:
            return records.sorted { $0.results.count > $1.results.count }
        case .promptAscending:
            return records.sorted {
                $0.prompt.localizedCaseInsensitiveCompare($1.prompt) == .orderedAscending
            }
        case .promptDescending:
            return records.sorted {
                $0.prompt.localizedCaseInsensitiveCompare($1.prompt) == .orderedDescending
            }
        }
    }
}

enum FavoriteSortOption: String, CaseIterable, Identifiable {
    case recentlyAdded
    case titleAscending
    case titleDescending
    case newestYear
    case oldestYear

    var id: String { rawValue }

    var title: String {
        switch self {
        case .recentlyAdded:
            return "Recently Added"
        case .titleAscending:
            return "A-Z"
        case .titleDescending:
            return "Z-A"
        case .newestYear:
            return "Newest Year"
        case .oldestYear:
            return "Oldest Year"
        }
    }

    var iconName: String {
        switch self {
        case .recentlyAdded:
            return "clock"
        case .titleAscending:
            return "textformat"
        case .titleDescending:
            return "textformat"
        case .newestYear:
            return "calendar"
        case .oldestYear:
            return "calendar"
        }
    }
}

enum HistorySortOption: String, CaseIterable, Identifiable {
    case newestFirst
    case oldestFirst
    case mostResults
    case promptAscending
    case promptDescending

    var id: String { rawValue }

    var title: String {
        switch self {
        case .newestFirst:
            return "Newest First"
        case .oldestFirst:
            return "Oldest First"
        case .mostResults:
            return "Most Results"
        case .promptAscending:
            return "A-Z"
        case .promptDescending:
            return "Z-A"
        }
    }

    var iconName: String {
        switch self {
        case .newestFirst:
            return "arrow.down"
        case .oldestFirst:
            return "arrow.up"
        case .mostResults:
            return "square.grid.2x2"
        case .promptAscending:
            return "text.quote"
        case .promptDescending:
            return "text.quote"
        }
    }
}

private extension String {
    var trimmed: String {
        trimmingCharacters(in: .whitespacesAndNewlines)
    }

    var sortableYear: Int {
        let digits = filter(\.isNumber)
        guard let year = Int(String(digits.prefix(4))) else {
            return 0
        }
        return year
    }
}

private extension MediaItem {
    func matches(_ query: String) -> Bool {
        let searchableText = [
            title,
            category.title,
            genre,
            year,
            shortDescription,
            reason,
            platforms.joined(separator: " "),
            moodTags.joined(separator: " ")
        ].joined(separator: " ")

        return searchableText.localizedCaseInsensitiveContains(query)
    }
}

private extension SearchRecord {
    func matches(_ query: String) -> Bool {
        prompt.localizedCaseInsensitiveContains(query)
            || results.contains { $0.matches(query) }
    }
}

