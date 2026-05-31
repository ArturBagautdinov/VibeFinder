import SwiftUI

struct DetailChips: View {
    let title: String
    let values: [String]

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.headline)
                .foregroundStyle(AppTheme.ink)

            FlowLayout(items: values) { value in
                Text(value)
                    .font(.caption)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 6)
                    .background(AppTheme.elevatedSurface, in: Capsule())
                    .foregroundStyle(AppTheme.ink)
            }
        }
    }
}

