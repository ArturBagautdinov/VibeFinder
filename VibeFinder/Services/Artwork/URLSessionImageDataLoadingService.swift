import Foundation

final class URLSessionImageDataLoadingService: ImageDataLoadingService, Sendable {
    nonisolated static let shared = URLSessionImageDataLoadingService()

    private let session: URLSession
    private let cache: ImageDataCache

    nonisolated init(session: URLSession = .shared, cache: ImageDataCache = ImageDataCache()) {
        self.session = session
        self.cache = cache
    }

    func imageData(from url: URL) async throws -> Data {
        if let cachedData = await cache.value(for: url) {
            return cachedData
        }

        let request = URLRequest(url: url, cachePolicy: .returnCacheDataElseLoad)
        let (data, response) = try await session.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }

        guard (200...299).contains(httpResponse.statusCode) else {
            throw NetworkError.badStatusCode(httpResponse.statusCode)
        }

        guard !data.isEmpty else {
            throw NetworkError.emptyData
        }

        await cache.insert(data, for: url)
        return data
    }
}
