import SwiftUI

struct HistoryScreen: View {
    let searchViewModel: SearchViewModel
    let libraryViewModel: LibraryViewModel
    @State private var path = NavigationPath()

    var body: some View {
        @Bindable var libraryViewModel = libraryViewModel

        NavigationStack(path: $path) {
            ZStack {
                AppTheme.backgroundGradient
                    .ignoresSafeArea()

                if libraryViewModel.history.isEmpty {
                    VStack {
                        EmptyStateView(
                            title: "No history yet",
                            message: "Your past prompts and results will appear here after the first search.",
                            systemImage: "clock.arrow.circlepath"
                        )
                        .padding(16)
                        Spacer()
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else if libraryViewModel.visibleHistory.isEmpty {
                    VStack {
                        EmptyStateView(
                            title: "No matching history",
                            message: "Try searching by prompt, title, genre, or category.",
                            systemImage: "magnifyingglass"
                        )
                        .padding(16)
                        Spacer()
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    List {
                        ForEach(libraryViewModel.visibleHistory) { record in
                            Button {
                                path.append(record)
                            } label: {
                                HistoryRecordCardView(record: record)
                            }
                            .buttonStyle(.plain)
                            .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                                Button(role: .destructive) {
                                    libraryViewModel.deleteHistoryRecord(record)
                                } label: {
                                    Label("Delete", systemImage: "trash")
                                }
                            }
                            .listRowBackground(Color.clear)
                            .listRowSeparator(.hidden)
                            .listRowInsets(EdgeInsets(top: 6, leading: 16, bottom: 6, trailing: 16))
                        }
                    }
                    .listStyle(.plain)
                    .scrollContentBackground(.hidden)
                    .background(Color.clear)
                }
            }
            .navigationTitle("History")
            .searchable(text: $libraryViewModel.historySearchText, prompt: "Search history")
            .tint(AppTheme.accent)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    sortMenu
                }
            }
            .navigationDestination(for: SearchRecord.self) { record in
                HistoryDetailScreen(
                    record: record,
                    searchViewModel: searchViewModel,
                    libraryViewModel: libraryViewModel,
                    path: $path
                )
            }
            .navigationDestination(for: MediaItem.self) { item in
                DetailScreen(
                    item: item,
                    isFavorite: libraryViewModel.isFavorite(item),
                    onFavoriteTap: { libraryViewModel.toggleFavorite(item) }
                )
            }
        }
    }

    private var sortMenu: some View {
        Menu {
            ForEach(HistorySortOption.allCases) { option in
                Button {
                    libraryViewModel.historySortOption = option
                } label: {
                    Label(option.title, systemImage: libraryViewModel.historySortOption == option ? "checkmark" : option.iconName)
                }
            }
        } label: {
            Label("Sort", systemImage: "arrow.up.arrow.down")
        }
    }
}

#Preview {
    let libraryViewModel = LibraryViewModel(storage: InMemoryLibraryStorage(history: [SearchRecord(prompt: "quiet space mystery", results: MockMediaSuggestionService.sampleItems)]))
    HistoryScreen(
        searchViewModel: SearchViewModel(service: MockMediaSuggestionService(delayNanoseconds: 0), libraryViewModel: libraryViewModel),
        libraryViewModel: libraryViewModel
    )
}
