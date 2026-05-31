import Foundation
import Observation
import UIKit

@MainActor
@Observable
final class ArtworkViewModel {
    private(set) var image: UIImage?
    private(set) var isLoading = false

    private let imageDataService: any ImageDataLoadingService
    private var currentURL: URL?

    init(imageDataService: any ImageDataLoadingService = URLSessionImageDataLoadingService.shared) {
        self.imageDataService = imageDataService
    }

    func load(from url: URL?) async {
        if currentURL == url, image != nil {
            return
        }

        currentURL = url
        image = nil

        guard let url else {
            isLoading = false
            return
        }

        isLoading = true
        defer {
            if currentURL == url {
                isLoading = false
            }
        }

        do {
            let data = try await imageDataService.imageData(from: url)
            guard currentURL == url, !Task.isCancelled else {
                return
            }
            image = UIImage(data: data)
        } catch {
            guard currentURL == url else {
                return
            }
            image = nil
        }
    }
}
