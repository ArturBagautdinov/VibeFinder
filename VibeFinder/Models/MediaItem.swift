import Foundation

struct MediaItem: Identifiable, Codable, Hashable, Sendable {
    let id: UUID
    let title: String
    let category: MediaCategory
    let genre: String
    let year: String
    let shortDescription: String
    let reason: String
    let matchLevel: MatchLevel
    let matchScore: Int
    let imageURL: URL?
    let platforms: [String]
    let duration: String?
    let moodTags: [String]

    nonisolated init(
        id: UUID = UUID(),
        title: String,
        category: MediaCategory,
        genre: String,
        year: String,
        shortDescription: String,
        reason: String,
        matchLevel: MatchLevel,
        matchScore: Int,
        imageURL: URL? = nil,
        platforms: [String] = [],
        duration: String? = nil,
        moodTags: [String] = []
    ) {
        self.id = id
        self.title = title
        self.category = category
        self.genre = genre
        self.year = year
        self.shortDescription = shortDescription
        self.reason = reason
        self.matchLevel = matchLevel
        self.matchScore = min(max(matchScore, 0), 100)
        self.imageURL = imageURL
        self.platforms = platforms
        self.duration = duration
        self.moodTags = moodTags
    }
}
