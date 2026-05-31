import SwiftUI

struct MediaCardView: View {
    let item: MediaItem
    let isFavorite: Bool
    var showsMatchBadge = true
    var showsCategoryBadge = false
    let onFavoriteTap: () -> Void

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            categoryRail

            ArtworkView(url: item.imageURL, category: item.category, style: .thumbnail)

            VStack(alignment: .leading, spacing: 8) {
                HStack(alignment: .top, spacing: 8) {
                    VStack(alignment: .leading, spacing: 3) {
                        Text(item.title)
                            .font(.headline)
                            .foregroundStyle(AppTheme.ink)
                            .lineLimit(2)

                        Text("\(item.genre) • \(item.year)")
                            .font(.subheadline)
                            .foregroundStyle(AppTheme.secondaryText)
                            .lineLimit(1)
                    }

                    Spacer(minLength: 4)

                    Button(action: onFavoriteTap) {
                        Image(systemName: isFavorite ? "heart.fill" : "heart")
                            .foregroundStyle(isFavorite ? AppTheme.favorite : AppTheme.secondaryText)
                    }
                    .buttonStyle(.plain)
                    .accessibilityLabel(isFavorite ? "Remove from favorites" : "Add to favorites")
                }

                Text(item.shortDescription)
                    .font(.subheadline)
                    .foregroundStyle(AppTheme.ink)
                    .lineLimit(3)

                if showsMatchBadge {
                    HStack(spacing: 8) {
                        MatchBadge(level: item.matchLevel, score: item.matchScore)
                        Spacer(minLength: 0)
                    }
                } else if showsCategoryBadge {
                    HStack(spacing: 8) {
                        categoryBadge
                        Spacer(minLength: 0)
                    }
                }
            }
        }
        .padding(12)
        .background(AppTheme.surface, in: RoundedRectangle(cornerRadius: AppTheme.cornerRadius))
        .shadow(color: AppTheme.shadow, radius: 12, x: 0, y: 7)
        .overlay(
            RoundedRectangle(cornerRadius: AppTheme.cornerRadius)
                .stroke(AppTheme.border.opacity(0.28))
        )
    }

    private var categoryRail: some View {
        RoundedRectangle(cornerRadius: 6)
            .fill(categoryColor)
            .frame(width: 4)
            .frame(maxHeight: .infinity)
    }

    private var categoryColor: Color {
        switch item.category {
        case .movie:
            return AppTheme.accent
        case .series:
            return AppTheme.warmHighlight
        case .game:
            return AppTheme.coolHighlight
        }
    }

    private var categoryBadgeColor: Color {
        switch item.category {
        case .movie:
            return AppTheme.accent
        case .series:
            return AppTheme.warmInk
        case .game:
            return AppTheme.coolInk
        }
    }

    private var categoryBadge: some View {
        Label(item.category.singularTitle, systemImage: item.category.iconName)
            .font(.caption.weight(.semibold))
            .foregroundStyle(categoryBadgeColor)
            .padding(.horizontal, 9)
            .padding(.vertical, 5)
            .background(categoryBadgeColor.opacity(0.16), in: Capsule())
            .overlay(
                Capsule()
                    .stroke(categoryBadgeColor.opacity(0.34))
            )
    }
}

#Preview {
    MediaCardView(item: MockMediaSuggestionService.sampleItems[0], isFavorite: true) {}
        .padding()
}
