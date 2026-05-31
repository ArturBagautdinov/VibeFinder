import Foundation
import Testing
@testable import VibeFinder

@MainActor
struct ArtworkViewModelTests {
    
    @Test func artworkViewModelLoadsImageSuccessfully() async {
        let service = MockImageDataLoadingService(data: makeTestPNGData())
        let viewModel = ArtworkViewModel(imageDataService: service)

        await viewModel.load(from: URL(string: "https://example.com/image.png"))

        #expect(viewModel.image != nil)
        #expect(!viewModel.isLoading)
    }

    @Test func artworkViewModelClearsLoadingOnError() async {
        let service = MockImageDataLoadingService(data: nil)
        let viewModel = ArtworkViewModel(imageDataService: service)

        await viewModel.load(from: URL(string: "https://example.com/missing.png"))

        #expect(viewModel.image == nil)
        #expect(!viewModel.isLoading)
    }
}
