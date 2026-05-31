import Foundation

enum MediaCategory: String, Codable, CaseIterable, Identifiable, Hashable {
    case movie
    case series
    case game

    var id: String { rawValue }

    var title: String {
        switch self {
        case .movie:
            return "Movies"
        case .series:
            return "Series"
        case .game:
            return "Games"
        }
    }

    var singularTitle: String {
        switch self {
        case .movie:
            return "Movie"
        case .series:
            return "Series"
        case .game:
            return "Game"
        }
    }

    var iconName: String {
        switch self {
        case .movie:
            return "movieclapper"
        case .series:
            return "tv"
        case .game:
            return "gamecontroller"
        }
    }
}

enum MatchLevel: String, Codable, CaseIterable, Hashable {
    case exact
    case atmosphere
    case adjacent

    var title: String {
        switch self {
        case .exact:
            return "Direct match"
        case .atmosphere:
            return "Atmosphere match"
        case .adjacent:
            return "Adjacent pick"
        }
    }
}

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

struct MediaSection: Identifiable, Hashable {
    let category: MediaCategory
    let items: [MediaItem]

    var id: MediaCategory { category }
}

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

struct AuthUser: Codable, Hashable, Sendable {
    let id: String
    let email: String
}
