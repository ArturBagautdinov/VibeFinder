import Foundation

protocol MediaSuggestionService {
    func suggestions(for prompt: String) async throws -> [MediaItem]
}
