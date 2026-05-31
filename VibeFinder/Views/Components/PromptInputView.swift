import SwiftUI

struct PromptInputView: View {
    @Binding var text: String
    let isLoading: Bool
    let onSubmit: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 8) {
                Image(systemName: "sparkle.magnifyingglass")
                    .font(.headline)
                    .foregroundStyle(AppTheme.accent)
                Text("Tell me the vibe")
                    .font(.headline.weight(.semibold))
                    .foregroundStyle(AppTheme.ink)
            }

            ZStack(alignment: .topLeading) {
                RoundedRectangle(cornerRadius: AppTheme.cornerRadius)
                    .fill(AppTheme.inputSurface)
                    .overlay(
                        RoundedRectangle(cornerRadius: AppTheme.cornerRadius)
                            .stroke(AppTheme.border.opacity(0.4))
                    )
                    .shadow(color: AppTheme.shadow, radius: 14, x: 0, y: 8)

                PromptTextView(text: $text)
                    .frame(minHeight: 96, maxHeight: 120)

                if text.isEmpty {
                    Text("For example: I want moody cyberpunk with a strong story")
                        .foregroundStyle(AppTheme.secondaryText)
                        .padding(.horizontal, 14)
                        .padding(.vertical, 12)
                        .allowsHitTesting(false)
                }
            }
            .frame(height: 120)

            Button(action: onSubmit) {
                Label(isLoading ? "Searching" : "Find matches", systemImage: isLoading ? "hourglass" : "sparkle")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .tint(AppTheme.accent)
            .controlSize(.large)
            .disabled(isLoading || text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
        }
    }
}

#Preview {
    PromptInputView(text: .constant(""), isLoading: false) {}
        .padding()
}
