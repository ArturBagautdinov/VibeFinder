import Foundation

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
