import SwiftUI

struct DetailScreen: View {
    let item: MediaItem
    let isFavorite: Bool
    var showsMatchBadge = true
    let onFavoriteTap: () -> Void
    @State private var isShareScreenPresented = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 18) {
                ArtworkView(url: item.imageURL, category: item.category, style: .detail)
                    .padding(.top, 16)

                VStack(alignment: .leading, spacing: 12) {
                    HStack(alignment: .top) {
                        VStack(alignment: .leading, spacing: 6) {
                            Text(item.title)
                                .font(.largeTitle.bold())
                                .foregroundStyle(AppTheme.ink)
                                .fixedSize(horizontal: false, vertical: true)
                            Text("\(item.category.title) • \(item.genre) • \(item.year)")
                                .font(.subheadline)
                                .foregroundStyle(AppTheme.secondaryText)
                        }

                        Spacer(minLength: 12)

                        Button(action: onFavoriteTap) {
                            Image(systemName: isFavorite ? "heart.fill" : "heart")
                                .font(.title2)
                                .foregroundStyle(isFavorite ? AppTheme.favorite : AppTheme.ink)
                        }
                        .buttonStyle(.bordered)
                        .tint(AppTheme.accent)
                    }

                    if showsMatchBadge {
                        MatchBadge(level: item.matchLevel, score: item.matchScore)
                    }

                    Text(item.shortDescription)
                        .font(.body)

                    DetailBlock(title: "Why it fits", text: item.reason)

                    if !item.platforms.isEmpty {
                        DetailChips(title: "Where to watch or play", values: item.platforms)
                    }

                    if !item.moodTags.isEmpty {
                        DetailChips(title: "Mood", values: item.moodTags)
                    }

                    if let duration = item.duration, !duration.isEmpty {
                        DetailBlock(title: "Length", text: duration)
                    }
                }
                .modernSurfaceCard()
                .padding(.horizontal, 16)
                .padding(.bottom, 24)
            }
        }
        .appScreenBackground()
        .navigationBarTitleDisplayMode(.inline)
        .tint(AppTheme.accent)
        .toolbar {
            Button {
                isShareScreenPresented = true
            } label: {
                Label("Share", systemImage: "square.and.arrow.up")
            }
        }
        .sheet(isPresented: $isShareScreenPresented) {
            MediaShareView(item: item)
                .presentationDetents([.medium])
        }
    }
}

#Preview {
    NavigationStack {
        DetailScreen(item: MockMediaSuggestionService.sampleItems[0], isFavorite: false) {}
    }
}
