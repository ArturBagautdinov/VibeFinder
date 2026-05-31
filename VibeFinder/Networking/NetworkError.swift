import Foundation

enum NetworkError: LocalizedError, Equatable {
    case badURL
    case badStatusCode(Int)
    case invalidResponse
    case emptyData

    var errorDescription: String? {
        switch self {
        case .badURL:
            return "The request URL could not be created."
        case .badStatusCode(let code):
            return "The server returned status code \(code)."
        case .invalidResponse:
            return "The server response has an invalid format."
        case .emptyData:
            return "The server returned an empty response."
        }
    }
}
