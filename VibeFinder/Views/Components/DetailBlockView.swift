import SwiftUI

struct DetailBlock: View {
    let title: String
    let text: String

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .font(.headline)
                .foregroundStyle(AppTheme.ink)
            Text(text)
                .font(.body)
                .foregroundStyle(AppTheme.secondaryText)
        }
    }
}

