import Foundation
import Observation

@MainActor
@Observable
final class SearchViewModel {
    var prompt = ""
    var results: [MediaItem] = []
    var state: ViewState = .empty

    private let service: any MediaSuggestionService
    private let libraryViewModel: LibraryViewModel
    private var searchTask: Task<Void, Never>?

    init(service: any MediaSuggestionService, libraryViewModel: LibraryViewModel) {
        self.service = service
        self.libraryViewModel = libraryViewModel
    }

    var sections: [MediaSection] {
        sections(for: results)
    }

    func search() {
        searchTask?.cancel()
        searchTask = Task { [weak self] in
            await self?.runSearch()
        }
    }

    func runSearch() async {
        let query = prompt.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !query.isEmpty else {
            results = []
            state = .empty
            return
        }

        state = .loading
        do {
            let items = try await service.suggestions(for: query)
            try Task.checkCancellation()
            results = items

            if items.isEmpty {
                state = .empty
            } else {
                let record = SearchRecord(prompt: query, results: items)
                try await libraryViewModel.addHistoryRecord(record)
                state = .content
            }
        } catch is CancellationError {
            return
        } catch {
            results = []
            state = .error(error.localizedDescription)
        }
    }

    func openHistoryRecord(_ record: SearchRecord) {
        prompt = record.prompt
        results = record.results
        state = record.results.isEmpty ? .empty : .content
    }

    func clearSearchData() {
        searchTask?.cancel()
        searchTask = nil
        prompt = ""
        results = []
        state = .empty
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
}
