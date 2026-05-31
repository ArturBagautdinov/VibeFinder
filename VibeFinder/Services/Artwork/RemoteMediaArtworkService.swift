import Foundation

final class RemoteMediaArtworkService: MediaArtworkProviding {
    private let session: URLSession
    private let decoder = JSONDecoder()
    private let cache: ArtworkMemoryCache
    private let tmdbAPIKey: String
    private let rawgAPIKey: String

    init(
        tmdbAPIKey: String,
        rawgAPIKey: String,
        session: URLSession = .shared,
        cache: ArtworkMemoryCache = ArtworkMemoryCache()
    ) {
        self.tmdbAPIKey = tmdbAPIKey
        self.rawgAPIKey = rawgAPIKey
        self.session = session
        self.cache = cache
    }

    func artworkURL(for title: String, category: MediaCategory) async throws -> URL? {
        let cacheKey = "\(category.rawValue)-\(title.lowercased())"
        if let cachedURL = await cache.value(for: cacheKey) {
            return cachedURL
        }

        let artworkURL: URL?
        switch category {
        case .movie:
            artworkURL = try await tmdbArtworkURL(for: title, endpoint: "movie")
        case .series:
            artworkURL = try await tmdbArtworkURL(for: title, endpoint: "tv")
        case .game:
            artworkURL = try await rawgArtworkURL(for: title)
        }

        if let artworkURL {
            await cache.insert(artworkURL, for: cacheKey)
        }

        return artworkURL
    }

    private func tmdbArtworkURL(for title: String, endpoint: String) async throws -> URL? {
        guard !tmdbAPIKey.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            return nil
        }

        var components = URLComponents(string: "https://api.themoviedb.org/3/search/\(endpoint)")
        components?.queryItems = [
            URLQueryItem(name: "api_key", value: tmdbAPIKey),
            URLQueryItem(name: "query", value: title),
            URLQueryItem(name: "language", value: "en-US"),
            URLQueryItem(name: "include_adult", value: "false"),
            URLQueryItem(name: "page", value: "1")
        ]

        guard let url = components?.url else {
            throw NetworkError.badURL
        }

        let payload: TMDBSearchResponse = try await fetch(url)
        guard let posterPath = payload.results.compactMap(\.posterPath).first else {
            return nil
        }

        return URL(string: "https://image.tmdb.org/t/p/w500\(posterPath)")
    }

    private func rawgArtworkURL(for title: String) async throws -> URL? {
        guard !rawgAPIKey.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            return nil
        }

        var components = URLComponents(string: "https://api.rawg.io/api/games")
        components?.queryItems = [
            URLQueryItem(name: "key", value: rawgAPIKey),
            URLQueryItem(name: "search", value: title),
            URLQueryItem(name: "search_precise", value: "true"),
            URLQueryItem(name: "page_size", value: "1")
        ]

        guard let url = components?.url else {
            throw NetworkError.badURL
        }

        let payload: RAWGSearchResponse = try await fetch(url)
        return payload.results.compactMap(\.backgroundImage).first
    }

    private func fetch<Response: Decodable>(_ url: URL) async throws -> Response {
        let (data, response) = try await session.data(from: url)
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }

        guard (200...299).contains(httpResponse.statusCode) else {
            throw NetworkError.badStatusCode(httpResponse.statusCode)
        }

        guard !data.isEmpty else {
            throw NetworkError.emptyData
        }

        return try decoder.decode(Response.self, from: data)
    }
}

