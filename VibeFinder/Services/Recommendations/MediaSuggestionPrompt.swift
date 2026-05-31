import Foundation

enum MediaSuggestionPrompt {
    static func requestedCategories(from prompt: String) -> Set<MediaCategory> {
        let lowercasedPrompt = prompt.lowercased()
        var categories = Set<MediaCategory>()

        let gameKeywords = ["game", "games", "videogame", "video game", "play", "gameplay", "rpg", "shooter", "strategy", "co-op", "console", "pc", "playstation", "xbox", "switch"]
        let movieKeywords = ["movie", "movies", "film", "films", "cinema"]
        let seriesKeywords = ["series", "show", "tv show", "anime series", "sitcom", "season", "binge"]

        if gameKeywords.contains(where: lowercasedPrompt.contains) {
            categories.insert(.game)
        }
        if movieKeywords.contains(where: lowercasedPrompt.contains) {
            categories.insert(.movie)
        }
        if seriesKeywords.contains(where: lowercasedPrompt.contains) {
            categories.insert(.series)
        }

        return categories
    }

    static let systemPrompt = """
    You are the recommendation engine for VibeFinder. Given a short user request, recommend media content: movies, series, and games.
    First detect whether the user explicitly asks for a specific media category.
    Category intent rules:
    - If the request asks for a game, videogame, something to play, gameplay, co-op, RPG, shooter, strategy, console, PC, PlayStation, Xbox, Switch, or similar wording, return only items with category "game".
    - If the request asks for a movie, film, cinema, something to watch tonight as a single sitting, or similar wording, return only items with category "movie".
    - If the request asks for a series, show, TV show, anime series, sitcom, season, binge-watch, or similar wording, return only items with category "series".
    - If the request explicitly asks for multiple categories, include only those categories.
    - Only balance movies, series, and games when the request does not specify a category.
    Return only valid JSON without markdown.
    Schema:
    {
      "items": [
        {
          "title": "string",
          "category": "movie | series | game",
          "genre": "string",
          "year": "string",
          "shortDescription": "up to 160 characters",
          "reason": "why this fits the request",
          "matchLevel": "exact | atmosphere | adjacent",
          "matchScore": 0-100,
          "platforms": ["string"],
          "duration": "string or empty string",
          "moodTags": ["2-4 short tags"]
        }
      ]
    }
    Give 9-12 recommendations when multiple categories are allowed. If only one category is requested, give 6-10 recommendations from that category only. Avoid invented titles.
    """
}

