import Foundation

struct AppContainer {
    let authService: any AuthService
    let suggestionService: any MediaSuggestionService
    let storage: any UserLibraryStorage

    static var live: AppContainer {
        let storage = UserDefaultsLibraryStorage()
        let tmdbAPIKey = Bundle.main.object(forInfoDictionaryKey: "TMDB_API_KEY") as? String
            ?? ProcessInfo.processInfo.environment["TMDB_API_KEY"]
            ?? ""
        let rawgAPIKey = Bundle.main.object(forInfoDictionaryKey: "RAWG_API_KEY") as? String
            ?? ProcessInfo.processInfo.environment["RAWG_API_KEY"]
            ?? ""
        let artworkService = RemoteMediaArtworkService(
            tmdbAPIKey: tmdbAPIKey,
            rawgAPIKey: rawgAPIKey
        )
        let apiKey = Bundle.main.object(forInfoDictionaryKey: "OPENAI_API_KEY") as? String
            ?? ProcessInfo.processInfo.environment["OPENAI_API_KEY"]
            ?? ""

        let suggestionService: any MediaSuggestionService
        if apiKey.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            suggestionService = MockMediaSuggestionService()
        } else {
            suggestionService = OpenAIMediaSuggestionService(apiToken: apiKey, artworkService: artworkService)
        }

        return AppContainer(
            authService: FirebaseAuthService(),
            suggestionService: suggestionService,
            storage: storage
        )
    }

    static var preview: AppContainer {
        AppContainer(
            authService: MockAuthService(user: AuthUser(id: "preview", email: "demo@vibefinder.app")),
            suggestionService: MockMediaSuggestionService(delayNanoseconds: 0),
            storage: InMemoryLibraryStorage(
                favorites: Array(MockMediaSuggestionService.sampleItems.prefix(2)),
                history: [
                    SearchRecord(prompt: "melancholic cyberpunk", results: MockMediaSuggestionService.sampleItems)
                ]
            )
        )
    }
}
