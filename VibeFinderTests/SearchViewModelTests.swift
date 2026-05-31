import Testing
@testable import VibeFinder

@MainActor
struct SearchViewModelTests {
    
    @Test func searchSuccessLoadsResultsAndSavesHistory() async throws {
        let item = MediaItem.testItem()
        let libraryViewModel = LibraryViewModel(storage: InMemoryLibraryStorage())
        let service = ConfigurableMediaSuggestionService(result: .success([item]))
        let viewModel = SearchViewModel(service: service, libraryViewModel: libraryViewModel)

        viewModel.prompt = "quiet sci-fi"
        await viewModel.runSearch()

        #expect(viewModel.results == [item])
        #expect(viewModel.state == .content)
        #expect(libraryViewModel.history.count == 1)
        #expect(libraryViewModel.history.first?.prompt == "quiet sci-fi")
    }

    @Test func searchErrorShowsErrorStateAndClearsResults() async {
        let libraryViewModel = LibraryViewModel(storage: InMemoryLibraryStorage())
        let service = ConfigurableMediaSuggestionService(result: .failure(TestError.expected))
        let viewModel = SearchViewModel(service: service, libraryViewModel: libraryViewModel)

        viewModel.prompt = "something"
        await viewModel.runSearch()

        #expect(viewModel.results.isEmpty)
        if case .error(let message) = viewModel.state {
            #expect(message == "Expected test error")
        } else {
            Issue.record("Expected error state")
        }
    }

    @Test func emptyPromptShowsEmptyState() async {
        let libraryViewModel = LibraryViewModel(storage: InMemoryLibraryStorage())
        let service = ConfigurableMediaSuggestionService(result: .success([.testItem()]))
        let viewModel = SearchViewModel(service: service, libraryViewModel: libraryViewModel)

        viewModel.prompt = "   "
        await viewModel.runSearch()

        #expect(viewModel.results.isEmpty)
        #expect(viewModel.state == .empty)
    }

    @Test func emptyServiceResponseShowsEmptyState() async {
        let libraryViewModel = LibraryViewModel(storage: InMemoryLibraryStorage())
        let service = ConfigurableMediaSuggestionService(result: .success([]))
        let viewModel = SearchViewModel(service: service, libraryViewModel: libraryViewModel)

        viewModel.prompt = "minimal drama"
        await viewModel.runSearch()

        #expect(viewModel.results.isEmpty)
        #expect(viewModel.state == .empty)
        #expect(libraryViewModel.history.isEmpty)
    }

    @Test func restoredHistoryRecordBecomesSearchContent() {
        let libraryViewModel = LibraryViewModel(storage: InMemoryLibraryStorage())
        let viewModel = SearchViewModel(
            service: ConfigurableMediaSuggestionService(result: .success([])),
            libraryViewModel: libraryViewModel
        )
        let record = SearchRecord(prompt: "space mystery", results: [.testItem(title: "Outer Wilds", category: .game)])

        viewModel.openHistoryRecord(record)

        #expect(viewModel.prompt == "space mystery")
        #expect(viewModel.results == record.results)
        #expect(viewModel.state == .content)
    }
}

