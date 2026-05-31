import Foundation

struct MockMediaSuggestionService: MediaSuggestionService {
    var delayNanoseconds: UInt64 = 450_000_000

    func suggestions(for prompt: String) async throws -> [MediaItem] {
        let trimmedPrompt = prompt.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedPrompt.isEmpty else {
            throw MediaSuggestionError.emptyPrompt
        }

        try await Task.sleep(nanoseconds: delayNanoseconds)
        return Self.sampleItems
    }

    static let sampleItems: [MediaItem] = [
        MediaItem(
            title: "Blade Runner 2049",
            category: .movie,
            genre: "Sci-Fi / Noir",
            year: "2017",
            shortDescription: "A slow neon detective story about memory, loneliness, and artificial life.",
            reason: "A strong fit for requests about moody cyberpunk, noir, and contemplative sci-fi.",
            matchLevel: .exact,
            matchScore: 96,
            platforms: ["Apple TV", "Prime Video"],
            duration: "2h 44m",
            moodTags: ["neon", "lonely", "noir"]
        ),
        MediaItem(
            title: "Severance",
            category: .series,
            genre: "Mystery / Drama",
            year: "2022",
            shortDescription: "A workplace dystopia where office life and personal life are literally separated.",
            reason: "Great when you want something strange, stylish, uneasy, and mystery-driven.",
            matchLevel: .atmosphere,
            matchScore: 91,
            platforms: ["Apple TV+"],
            duration: "2 seasons",
            moodTags: ["mystery", "office", "paranoia"]
        ),
        MediaItem(
            title: "Disco Elysium",
            category: .game,
            genre: "RPG / Detective",
            year: "2019",
            shortDescription: "A detective RPG with sharp writing, inner voices, and a beautifully broken city.",
            reason: "An excellent pick for deep storytelling, noir mood, and unusual presentation.",
            matchLevel: .exact,
            matchScore: 98,
            platforms: ["PC", "PlayStation", "Xbox", "Switch"],
            duration: "25-40h",
            moodTags: ["detective", "writing", "melancholy"]
        ),
        MediaItem(
            title: "Arrival",
            category: .movie,
            genre: "Sci-Fi / Drama",
            year: "2016",
            shortDescription: "First contact becomes a story about language, time, and the weight of choice.",
            reason: "A close atmospheric match for smart, emotional sci-fi without too much noise.",
            matchLevel: .atmosphere,
            matchScore: 88,
            platforms: ["Apple TV", "Prime Video"],
            duration: "1h 56m",
            moodTags: ["language", "time", "quiet"]
        ),
        MediaItem(
            title: "The Last of Us",
            category: .series,
            genre: "Drama / Post-apocalypse",
            year: "2023",
            shortDescription: "A post-apocalyptic journey about trust, loss, and found family.",
            reason: "Works well for requests about emotional survival and strong character bonds.",
            matchLevel: .adjacent,
            matchScore: 84,
            platforms: ["HBO Max"],
            duration: "1 season",
            moodTags: ["journey", "drama", "survival"]
        ),
        MediaItem(
            title: "Outer Wilds",
            category: .game,
            genre: "Adventure / Puzzle",
            year: "2019",
            shortDescription: "A small solar system mystery where knowledge matters more than upgrades.",
            reason: "Ideal when you want wonder, mystery, and the feeling of real discovery.",
            matchLevel: .atmosphere,
            matchScore: 93,
            platforms: ["PC", "PlayStation", "Xbox", "Switch"],
            duration: "20-25h",
            moodTags: ["space", "mystery", "discovery"]
        )
    ]
}

