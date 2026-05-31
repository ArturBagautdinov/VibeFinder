import Foundation
import Observation

@MainActor
@Observable
final class AuthViewModel {
    var email = ""
    var password = ""
    var confirmPassword = ""
    var user: AuthUser?
    var state: ViewState = .empty
    var isRegisterMode = true

    private let service: any AuthService

    init(service: any AuthService) {
        self.service = service
    }

    func restoreSession() async {
        user = await service.restoreUser()
    }

    func submit() async {
        state = .loading
        do {
            if isRegisterMode {
                try validatePasswordConfirmation()
                user = try await service.register(email: email, password: password)
            } else {
                user = try await service.signIn(email: email, password: password)
            }
            password = ""
            confirmPassword = ""
            state = .content
        } catch {
            state = .error(error.localizedDescription)
        }
    }

    func toggleMode() {
        isRegisterMode.toggle()
        password = ""
        confirmPassword = ""
        state = .empty
    }

    func signOut() {
        do {
            try service.signOut()
            user = nil
            state = .empty
            password = ""
            confirmPassword = ""
        } catch {
            state = .error(error.localizedDescription)
        }
    }

    private func validatePasswordConfirmation() throws {
        guard password == confirmPassword else {
            throw AuthValidationError.passwordMismatch
        }
    }
}
