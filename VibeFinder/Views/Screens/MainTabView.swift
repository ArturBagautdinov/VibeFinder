import SwiftUI

struct MainTabView: View {
    let authViewModel: AuthViewModel
    let searchViewModel: SearchViewModel
    let libraryViewModel: LibraryViewModel

    var body: some View {
        TabView {
            SearchScreen(searchViewModel: searchViewModel, libraryViewModel: libraryViewModel)
                .tabItem {
                    Label("Search", systemImage: "magnifyingglass")
                }

            FavoritesScreen(viewModel: libraryViewModel)
                .tabItem {
                    Label("Favorites", systemImage: "heart")
                }

            HistoryScreen(searchViewModel: searchViewModel, libraryViewModel: libraryViewModel)
                .tabItem {
                    Label("History", systemImage: "clock")
                }

            ProfileScreen(authViewModel: authViewModel, libraryViewModel: libraryViewModel)
                .tabItem {
                    Label("Profile", systemImage: "person.crop.circle")
                }
        }
        .tint(AppTheme.accent)
        .toolbarBackground(AppTheme.surface, for: .tabBar)
        .toolbarBackground(.visible, for: .tabBar)
    }
}

#Preview {
    let libraryViewModel = LibraryViewModel(storage: InMemoryLibraryStorage())
    MainTabView(
        authViewModel: AuthViewModel(service: MockAuthService(user: AuthUser(id: "1", email: "demo@vibefinder.app"))),
        searchViewModel: SearchViewModel(
            service: MockMediaSuggestionService(delayNanoseconds: 0),
            libraryViewModel: libraryViewModel
        ),
        libraryViewModel: libraryViewModel
    )
}
