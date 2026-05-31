import Foundation

struct MockImageDataLoadingService: ImageDataLoadingService {
    let data: Data?

    init(data: Data? = nil) {
        self.data = data
    }

    func imageData(from url: URL) async throws -> Data {
        guard let data else {
            throw NetworkError.emptyData
        }
        return data
    }
}
