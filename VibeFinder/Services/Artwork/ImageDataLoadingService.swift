import Foundation

protocol ImageDataLoadingService: Sendable {
    func imageData(from url: URL) async throws -> Data
}
