import Foundation

final class MockAuthService: AuthService {
    private var user: AuthUser?

    init(user: AuthUser? = nil) {
        self.user = user
    }

    func restoreUser() async -> AuthUser? {
        user
    }

    func register(email: String, password: String) async throws -> AuthUser {
        try validate(email: email, password: password)
        let newUser = AuthUser(id: UUID().uuidString, email: email)
        user = newUser
        return newUser
    }

    func signIn(email: String, password: String) async throws -> AuthUser {
        try validate(email: email, password: password)
        let signedUser = AuthUser(id: UUID().uuidString, email: email)
        user = signedUser
        return signedUser
    }

    func signOut() throws {
        user = nil
    }

    private func validate(email: String, password: String) throws {
        guard !email.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            throw AuthValidationError.emptyEmail
        }
        guard password.count >= 6 else {
            throw AuthValidationError.shortPassword
        }
    }
}
