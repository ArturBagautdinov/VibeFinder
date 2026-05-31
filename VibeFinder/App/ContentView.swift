import SwiftUI

struct ContentView: View {
    @State private var authViewModel: AuthViewModel
    @State private var searchViewModel: SearchViewModel
    @State private var libraryViewModel: LibraryViewModel

    init(container: AppContainer = .live) {
        let libraryViewModel = LibraryViewModel(storage: container.storage)
        _authViewModel = State(initialValue: AuthViewModel(service: container.authService))
        _libraryViewModel = State(initialValue: libraryViewModel)
        _searchViewModel = State(initialValue: SearchViewModel(service: container.suggestionService, libraryViewModel: libraryViewModel))
    }

    var body: some View {
        Group {
            if authViewModel.user == nil {
                AuthScreen(viewModel: authViewModel)
            } else {
                MainTabView(
                    authViewModel: authViewModel,
                    searchViewModel: searchViewModel,
                    libraryViewModel: libraryViewModel
                )
            }
        }
        .task {
            await authViewModel.restoreSession()
            await libraryViewModel.loadSavedData()
        }
        .tint(AppTheme.accent)
    }
}

#Preview {
    ContentView(container: .preview)
}
