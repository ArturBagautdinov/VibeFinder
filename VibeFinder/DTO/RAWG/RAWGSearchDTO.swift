import Foundation

struct RAWGSearchResponse: Decodable {
    let results: [RAWGGameResult]
}

struct RAWGGameResult: Decodable {
    let backgroundImage: URL?

    enum CodingKeys: String, CodingKey {
        case backgroundImage = "background_image"
    }
}

