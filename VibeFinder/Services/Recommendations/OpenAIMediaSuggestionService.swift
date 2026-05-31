import Foundation
import OpenAI

final class OpenAIMediaSuggestionService: MediaSuggestionService {
    private let openAI: OpenAI
    private let artworkService: any MediaArtworkProviding
    private let decoder = JSONDecoder()

    init(apiToken: String, artworkService: any MediaArtworkProviding) {
        self.openAI = OpenAI(apiToken: apiToken)
        self.artworkService = artworkService
    }

    func suggestions(for prompt: String) async throws -> [MediaItem] {
        let trimmedPrompt = prompt.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedPrompt.isEmpty else {
            throw MediaSuggestionError.emptyPrompt
        }

        let query = ChatQuery(
            messages: [
                .developer(.init(content: .textContent(MediaSuggestionPrompt.systemPrompt))),
                .user(.init(content: .string("User request: \(trimmedPrompt)")))
            ],
            model: .gpt4_o_mini,
            maxCompletionTokens: 1800,
            responseFormat: .jsonObject,
            temperature: 0.7
        )

        let result = try await openAI.chats(query: query)
        guard let content = result.choices.first?.message.content, !content.isEmpty else {
            throw MediaSuggestionError.emptyModelResponse
        }

        let payload = try decodeResponse(from: content)
        guard !payload.items.isEmpty else {
            return []
        }

        let requestedCategories = MediaSuggestionPrompt.requestedCategories(from: trimmedPrompt)
        let filteredItems = filteredItems(payload.items, requestedCategories: requestedCategories)
        return try await enrichWithArtwork(filteredItems)
    }

    private func decodeResponse(from content: String) throws -> AIRecommendationsResponse {
        let cleaned = content
            .replacingOccurrences(of: "```json", with: "")
            .replacingOccurrences(of: "```", with: "")
            .trimmingCharacters(in: .whitespacesAndNewlines)

        guard let data = cleaned.data(using: .utf8) else {
            throw MediaSuggestionError.invalidModelResponse
        }

        do {
            return try decoder.decode(AIRecommendationsResponse.self, from: data)
        } catch {
            throw MediaSuggestionError.invalidModelResponse
        }
    }

    private func filteredItems(
        _ items: [AIRecommendationItem],
        requestedCategories: Set<MediaCategory>
    ) -> [AIRecommendationItem] {
        guard !requestedCategories.isEmpty else {
            return items
        }

        return items.filter { item in
            guard let category = MediaCategory(rawValue: item.category) else {
                return false
            }
            return requestedCategories.contains(category)
        }
    }

    private func enrichWithArtwork(_ items: [AIRecommendationItem]) async throws -> [MediaItem] {
        try await withThrowingTaskGroup(of: MediaItem.self) { group in
            for item in items.prefix(18) {
                group.addTask {
                    let category = MediaCategory(rawValue: item.category) ?? .movie
                    let artworkURL = try? await self.artworkService.artworkURL(for: item.title, category: category)

                    return MediaItem(
                        title: item.title,
                        category: category,
                        genre: item.genre,
                        year: item.year,
                        shortDescription: item.shortDescription,
                        reason: item.reason,
                        matchLevel: MatchLevel(rawValue: item.matchLevel) ?? .atmosphere,
                        matchScore: item.matchScore,
                        imageURL: artworkURL,
                        platforms: item.platforms,
                        duration: item.duration,
                        moodTags: item.moodTags
                    )
                }
            }

            var enrichedItems: [MediaItem] = []
            for try await item in group {
                enrichedItems.append(item)
            }

            return enrichedItems.sorted { lhs, rhs in
                if lhs.category == rhs.category {
                    return lhs.matchScore > rhs.matchScore
                }
                return categoryRank(lhs.category) < categoryRank(rhs.category)
            }
        }
    }

    private func categoryRank(_ category: MediaCategory) -> Int {
        MediaCategory.allCases.firstIndex(of: category) ?? 0
    }
}

