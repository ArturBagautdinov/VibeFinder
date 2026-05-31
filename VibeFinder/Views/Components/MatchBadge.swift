import SwiftUI

struct MatchBadge: View {
    let level: MatchLevel
    let score: Int

    var body: some View {
        HStack(spacing: 6) {
            Image(systemName: "target")
            Text("\(score)%")
                .fontWeight(.semibold)
            Text(level.title)
                .lineLimit(1)
        }
        .font(.caption)
        .padding(.horizontal, 8)
        .padding(.vertical, 5)
        .background(AppTheme.accentSoft.opacity(0.8), in: Capsule())
        .overlay(
            Capsule()
                .stroke(AppTheme.accent.opacity(0.16))
        )
        .foregroundStyle(AppTheme.ink)
    }
}

