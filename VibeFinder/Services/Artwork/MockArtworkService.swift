import Foundation

struct MockArtworkService: MediaArtworkProviding {
    func artworkURL(for title: String, category: MediaCategory) async throws -> URL? {
        nil
    }
}

