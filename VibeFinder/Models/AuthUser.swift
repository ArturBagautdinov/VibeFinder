import Foundation

struct AuthUser: Codable, Hashable, Sendable {
    let id: String
    let email: String
}
