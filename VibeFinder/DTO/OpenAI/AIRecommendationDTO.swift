import Foundation

struct AIRecommendationsResponse: Decodable {
    let items: [AIRecommendationItem]
}

struct AIRecommendationItem: Decodable {
    let title: String
    let category: String
    let genre: String
    let year: String
    let shortDescription: String
    let reason: String
    let matchLevel: String
    let matchScore: Int
    let platforms: [String]
    let duration: String?
    let moodTags: [String]
}

