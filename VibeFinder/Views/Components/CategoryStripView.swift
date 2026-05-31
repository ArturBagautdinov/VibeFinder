import SwiftUI

struct CategoryStripView: View {
    var body: some View {
        HStack(spacing: 10) {
            ForEach(MediaCategory.allCases) { category in
                HStack(spacing: 7) {
                    Image(systemName: category.iconName)
                    Text(category.title)
                }
                .font(.caption.weight(.semibold))
                .foregroundStyle(AppTheme.ink)
                .padding(.horizontal, 11)
                .padding(.vertical, 8)
                .background(AppTheme.surface.opacity(0.86), in: Capsule())
                .overlay(
                    Capsule()
                        .stroke(AppTheme.border.opacity(0.24))
                )
                .shadow(color: AppTheme.shadow.opacity(0.6), radius: 10, x: 0, y: 5)
            }
        }
    }
}

