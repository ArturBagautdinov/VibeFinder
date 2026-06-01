import Foundation

protocol AuthService {
    func restoreUser() async -> AuthUser?
    func register(email: String, password: String) async throws -> AuthUser
    func signIn(email: String, password: String) async throws -> AuthUser
    func signOut() throws
}
