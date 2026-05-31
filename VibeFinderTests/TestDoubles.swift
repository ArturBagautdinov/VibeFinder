import Foundation
import Testing
import UIKit
@testable import VibeFinder

enum TestError: LocalizedError {
    case expected

    var errorDescription: String? {
        "Expected test error"
    }
}

struct ConfigurableMediaSuggestionService: MediaSuggestionService {
    let result: Result<[MediaItem], Error>

    func suggestions(for prompt: String) async throws -> [MediaItem] {
        try result.get()
    }
}

final class URLProtocolMock: URLProtocol {
    nonisolated(unsafe) static var requestCount = 0
    nonisolated(unsafe) static var responseData = Data()
    nonisolated(unsafe) static var statusCode = 200

    override class func canInit(with request: URLRequest) -> Bool {
        true
    }

    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        request
    }

    override func startLoading() {
        Self.requestCount += 1

        let response = HTTPURLResponse(
            url: request.url!,
            statusCode: Self.statusCode,
            httpVersion: nil,
            headerFields: nil
        )!

        client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
        client?.urlProtocol(self, didLoad: Self.responseData)
        client?.urlProtocolDidFinishLoading(self)
    }

    override func stopLoading() {}

    static func reset(data: Data = Data([1, 2, 3]), statusCode: Int = 200) {
        requestCount = 0
        responseData = data
        Self.statusCode = statusCode
    }
}

func makeURLProtocolSession() -> URLSession {
    let configuration = URLSessionConfiguration.ephemeral
    configuration.protocolClasses = [URLProtocolMock.self]
    return URLSession(configuration: configuration)
}

func makeTestPNGData() -> Data {
    let renderer = UIGraphicsImageRenderer(size: CGSize(width: 1, height: 1))
    return renderer.pngData { context in
        UIColor.systemTeal.setFill()
        context.fill(CGRect(x: 0, y: 0, width: 1, height: 1))
    }
}

extension MediaItem {
    static func testItem(
        title: String = "Arrival",
        category: MediaCategory = .movie,
        genre: String = "Sci-Fi",
        year: String = "2016",
        matchScore: Int = 90,
        imageURL: URL? = URL(string: "https://example.com/poster.jpg")
    ) -> MediaItem {
        MediaItem(
            title: title,
            category: category,
            genre: genre,
            year: year,
            shortDescription: "A quiet, emotional recommendation.",
            reason: "It matches the requested mood.",
            matchLevel: .atmosphere,
            matchScore: matchScore,
            imageURL: imageURL,
            platforms: ["Apple TV"],
            duration: "1h 56m",
            moodTags: ["quiet", "smart"]
        )
    }
}

