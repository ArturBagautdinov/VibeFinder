import Foundation
import Testing
@testable import VibeFinder

@Suite(.serialized)
struct ImageDataLoadingServiceTests {
    
    @Test func imageDataServiceLoadsDataSuccessfully() async throws {
        let expectedData = Data([9, 8, 7])
        URLProtocolMock.reset(data: expectedData, statusCode: 200)
        let service = URLSessionImageDataLoadingService(session: makeURLProtocolSession(), cache: ImageDataCache())

        let data = try await service.imageData(from: URL(string: "https://example.com/poster.jpg")!)

        #expect(data == expectedData)
        #expect(URLProtocolMock.requestCount == 1)
    }

    @Test func imageDataServiceThrowsOnBadStatusCode() async {
        URLProtocolMock.reset(data: Data([1]), statusCode: 500)
        let service = URLSessionImageDataLoadingService(session: makeURLProtocolSession(), cache: ImageDataCache())

        do {
            _ = try await service.imageData(from: URL(string: "https://example.com/error.jpg")!)
            Issue.record("Expected bad status code error")
        } catch NetworkError.badStatusCode(let code) {
            #expect(code == 500)
        } catch {
            Issue.record("Unexpected error: \(error)")
        }
    }

    @Test func imageDataServiceReturnsCachedDataWithoutSecondNetworkRequest() async throws {
        let expectedData = Data([4, 5, 6])
        URLProtocolMock.reset(data: expectedData, statusCode: 200)
        let service = URLSessionImageDataLoadingService(session: makeURLProtocolSession(), cache: ImageDataCache())
        let url = URL(string: "https://example.com/cached.jpg")!

        let first = try await service.imageData(from: url)
        let second = try await service.imageData(from: url)

        #expect(first == expectedData)
        #expect(second == expectedData)
        #expect(URLProtocolMock.requestCount == 1)
    }
}
