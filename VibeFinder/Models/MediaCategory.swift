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
