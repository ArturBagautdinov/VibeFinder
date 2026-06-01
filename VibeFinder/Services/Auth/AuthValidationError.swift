import Foundation

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
