import SwiftUI

struct FavoritesScreen: View {
    let viewModel: LibraryViewModel
    @State private var path = NavigationPath()

    var body: some View {
        @Bindable var viewModel = viewModel

        NavigationStack(path: $path) {
            ZStack {
                AppTheme.backgroundGradient
                    .ignoresSafeArea()

                if viewModel.sortedFavorites.isEmpty {
                    VStack {
                        EmptyStateView(
                            title: "No favorites yet",
                            message: "Save recommendations with the heart button so you can return to them later.",
                            systemImage: "heart"
                        )
                        .padding(16)
                        Spacer()
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else if viewModel.visibleFavorites.isEmpty {
                    VStack {
                        EmptyStateView(
                            title: "No matching favorites",
                            message: "Try a different search or category filter.",
                            systemImage: "line.3.horizontal.decrease.circle"
                        )
                        .padding(16)
                        Spacer()
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    ScrollView {
                        LazyVStack(spacing: 12) {
                            ForEach(viewModel.visibleFavorites) { item in
                                Button {
                                    path.append(item)
                                } label: {
                                    MediaCardView(
                                        item: item,
                                        isFavorite: true,
                                        showsMatchBadge: false,
                                        showsCategoryBadge: true,
                                        onFavoriteTap: { viewModel.toggleFavorite(item) }
                                    )
                                }
                                .buttonStyle(.plain)
                            }
                        }
                        .padding(16)
                    }
                    .background(Color.clear)
                }
            }
            .navigationTitle("Favorites")
            .searchable(text: $viewModel.favoritesSearchText, prompt: "Search favorites")
            .tint(AppTheme.accent)
            .toolbar {
                ToolbarItemGroup(placement: .topBarTrailing) {
                    filterMenu
                    sortMenu
                }
            }
            .navigationDestination(for: MediaItem.self) { item in
                DetailScreen(
                    item: item,
                    isFavorite: viewModel.isFavorite(item),
                    showsMatchBadge: false,
                    onFavoriteTap: { viewModel.toggleFavorite(item) }
                )
            }
        }
    }

    private var filterMenu: some View {
        Menu {
            Button {
                viewModel.favoriteCategoryFilter = nil
            } label: {
                Label("All", systemImage: viewModel.favoriteCategoryFilter == nil ? "checkmark" : "line.3.horizontal.decrease")
            }

            ForEach(MediaCategory.allCases) { category in
                Button {
                    viewModel.favoriteCategoryFilter = category
                } label: {
                    Label(category.title, systemImage: viewModel.favoriteCategoryFilter == category ? "checkmark" : category.iconName)
                }
            }
        } label: {
            Label("Filter", systemImage: "line.3.horizontal.decrease.circle")
        }
    }

    private var sortMenu: some View {
        Menu {
            ForEach(FavoriteSortOption.allCases) { option in
                Button {
                    viewModel.favoriteSortOption = option
                } label: {
                    Label(option.title, systemImage: viewModel.favoriteSortOption == option ? "checkmark" : option.iconName)
                }
            }
        } label: {
            Label("Sort", systemImage: "arrow.up.arrow.down")
        }
    }
}

#Preview {
    FavoritesScreen(viewModel: LibraryViewModel(storage: InMemoryLibraryStorage(favorites: MockMediaSuggestionService.sampleItems)))
}
