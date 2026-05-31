import FirebaseAuth
import Foundation

protocol AuthService {
    func restoreUser() async -> AuthUser?
    func register(email: String, password: String) async throws -> AuthUser
    func signIn(email: String, password: String) async throws -> AuthUser
    func signOut() throws
}

enum AuthValidationError: LocalizedError {
    case emptyEmail
    case shortPassword
    case passwordMismatch

    var errorDescription: String? {
        switch self {
        case .emptyEmail:
            return "Enter your email."
        case .shortPassword:
            return "Password must be at least 6 characters."
        case .passwordMismatch:
            return "Passwords do not match."
        }
    }
}

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
