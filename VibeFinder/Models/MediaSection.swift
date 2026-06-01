import Foundation

struct MediaSection: Identifiable, Hashable {
    let category: MediaCategory
    let items: [MediaItem]

    var id: MediaCategory { category }
}
