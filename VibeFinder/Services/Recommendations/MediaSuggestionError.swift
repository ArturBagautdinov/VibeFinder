import Foundation

enum MediaSuggestionError: LocalizedError {
    case emptyPrompt
    case missingAPIKey
    case emptyModelResponse
    case invalidModelResponse

    var errorDescription: String? {
        switch self {
        case .emptyPrompt:
            return "Describe the mood, setting, or story you want to find."
        case .missingAPIKey:
            return "Add OPENAI_API_KEY to Info.plist or the scheme environment variables."
        case .emptyModelResponse:
            return "The model returned an empty response."
        case .invalidModelResponse:
            return "The model recommendations could not be parsed."
        }
    }
}
