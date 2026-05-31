import Foundation

protocol MediaArtworkProviding: Sendable {
    func artworkURL(for title: String, category: MediaCategory) async throws -> URL?
}

