import Foundation

struct SearchRecord: Identifiable, Codable, Hashable, Sendable {
    let id: UUID
    let prompt: String
    let createdAt: Date
    let results: [MediaItem]

    nonisolated init(id: UUID = UUID(), prompt: String, createdAt: Date = Date(), results: [MediaItem]) {
        self.id = id
        self.prompt = prompt
        self.createdAt = createdAt
        self.results = results
    }
}
