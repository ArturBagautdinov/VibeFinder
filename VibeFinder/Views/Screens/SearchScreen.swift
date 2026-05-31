import SwiftUI

struct SearchScreen: View {
    let searchViewModel: SearchViewModel
    let libraryViewModel: LibraryViewModel
    @State private var path = NavigationPath()

    var body: some View {
        @Bindable var searchViewModel = searchViewModel

        NavigationStack(path: $path) {
            ScrollView {
                LazyVStack(alignment: .leading, spacing: 18) {
                    CategoryStripView()

                    PromptInputView(
                        text: $searchViewModel.prompt,
                        isLoading: searchViewModel.state == .loading,
                        onSubmit: searchViewModel.search
                    )

                    content
                }
                .padding(16)
            }
            .appScreenBackground()
            .navigationTitle("Vibe Finder")
            .tint(AppTheme.accent)
            .navigationDestination(for: MediaItem.self) { item in
                DetailScreen(
                    item: item,
                    isFavorite: libraryViewModel.isFavorite(item),
                    onFavoriteTap: { libraryViewModel.toggleFavorite(item) }
                )
            }
        }
    }

    @ViewBuilder
    private var content: some View {
        switch searchViewModel.state {
        case .loading:
            LoadingStateView()
        case .empty:
            EmptyStateView(
                title: "No prompt yet",
                message: "Describe a mood, setting, or story type, and VibeFinder will build a curated list.",
                systemImage: "text.magnifyingglass"
            )
        case .error(let message):
            ErrorStateView(message: message, retry: searchViewModel.search)
        case .content:
            ForEach(searchViewModel.sections) { section in
                VStack(alignment: .leading, spacing: 10) {
                    Label(section.category.title, systemImage: section.category.iconName)
                        .font(.headline.weight(.semibold))
                        .foregroundStyle(AppTheme.ink)
                        .padding(.top, 2)

                    ForEach(section.items) { item in
                        Button {
                            path.append(item)
                        } label: {
                            MediaCardView(
                                item: item,
                                isFavorite: libraryViewModel.isFavorite(item),
                                onFavoriteTap: { libraryViewModel.toggleFavorite(item) }
                            )
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
        }
    }
}

#Preview {
    let libraryViewModel = LibraryViewModel(storage: InMemoryLibraryStorage())
    SearchScreen(
        searchViewModel: SearchViewModel(service: MockMediaSuggestionService(delayNanoseconds: 0), libraryViewModel: libraryViewModel),
        libraryViewModel: libraryViewModel
    )
}
