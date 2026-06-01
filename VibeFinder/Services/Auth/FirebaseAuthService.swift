import FirebaseAuth
import Foundation

final class FirebaseAuthService: AuthService {
    private let auth: Auth

    init(auth: Auth = Auth.auth()) {
        self.auth = auth
    }

    func restoreUser() async -> AuthUser? {
        auth.currentUser.map { AuthUser(id: $0.uid, email: $0.email ?? "No email") }
    }

    func register(email: String, password: String) async throws -> AuthUser {
        try validate(email: email, password: password)
        let result = try await auth.createUser(withEmail: email, password: password)
        return AuthUser(id: result.user.uid, email: result.user.email ?? email)
    }

    func signIn(email: String, password: String) async throws -> AuthUser {
        try validate(email: email, password: password)
        let result = try await auth.signIn(withEmail: email, password: password)
        return AuthUser(id: result.user.uid, email: result.user.email ?? email)
    }

    func signOut() throws {
        try auth.signOut()
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
