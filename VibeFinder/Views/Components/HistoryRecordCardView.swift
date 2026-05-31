import Foundation
import SwiftUI

struct HistoryRecordCardView: View {
    let record: SearchRecord

    var body: some View {
        HStack(spacing: 13) {
            ZStack {
                RoundedRectangle(cornerRadius: AppTheme.smallCornerRadius)
                    .fill(AppTheme.accentSoft.opacity(0.75))
                    .frame(width: 50, height: 58)

                Image(systemName: "clock.arrow.circlepath")
                    .font(.system(size: 22, weight: .semibold))
                    .foregroundStyle(AppTheme.accent)
            }

            VStack(alignment: .leading, spacing: 7) {
                Text(record.prompt)
                    .font(.headline)
                    .foregroundStyle(AppTheme.ink)
                    .lineLimit(2)

                HStack(spacing: 8) {

                    HStack(spacing: 3) {
                        Image(systemName: "square.grid.2x2")
                        Text("\(record.results.count) results")
                    }
                    
                    Text("•")
                    
                    Text(record.createdAt.formatted(date: .abbreviated, time: .shortened))
                }
                .font(.caption.weight(.medium))
                .foregroundStyle(AppTheme.secondaryText)
            }

            Spacer(minLength: 6)

            Image(systemName: "chevron.right")
                .font(.footnote.weight(.semibold))
                .foregroundStyle(AppTheme.secondaryText.opacity(0.8))
        }
        .padding(14)
        .background(AppTheme.surface.opacity(0.92), in: RoundedRectangle(cornerRadius: AppTheme.cornerRadius))
        .overlay(
            RoundedRectangle(cornerRadius: AppTheme.cornerRadius)
                .stroke(AppTheme.border.opacity(0.22))
        )
        .shadow(color: AppTheme.shadow, radius: 14, x: 0, y: 8)
    }
}
