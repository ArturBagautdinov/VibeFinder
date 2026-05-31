import SwiftUI

enum AppTheme {
    static let background = Color(red: 0.95, green: 0.93, blue: 0.90)
    static let backgroundTop = Color(red: 0.99, green: 0.96, blue: 0.91)
    static let backgroundMiddle = Color(red: 0.96, green: 0.93, blue: 0.88)
    static let backgroundBottom = Color(red: 0.91, green: 0.90, blue: 0.86)
    static let surface = Color(red: 1.00, green: 0.99, blue: 0.97)
    static let elevatedSurface = Color(red: 0.91, green: 0.93, blue: 0.92)
    static let inputSurface = Color(red: 1.00, green: 1.00, blue: 0.98)
    static let ink = Color(red: 0.10, green: 0.13, blue: 0.14)
    static let secondaryText = Color(red: 0.42, green: 0.46, blue: 0.46)
    static let accent = Color(red: 0.24, green: 0.43, blue: 0.46)
    static let accentSoft = Color(red: 0.78, green: 0.86, blue: 0.85)
    static let border = Color(red: 0.78, green: 0.80, blue: 0.77)
    static let favorite = Color(red: 0.66, green: 0.27, blue: 0.34)
    static let warning = Color(red: 0.70, green: 0.47, blue: 0.25)
    static let error = Color(red: 0.63, green: 0.22, blue: 0.28)
    static let shadow = Color.black.opacity(0.08)
    static let deepShadow = Color.black.opacity(0.12)
    static let warmHighlight = Color(red: 0.86, green: 0.73, blue: 0.55)
    static let coolHighlight = Color(red: 0.70, green: 0.78, blue: 0.82)
    static let warmInk = Color(red: 0.58, green: 0.36, blue: 0.14)
    static let coolInk = Color(red: 0.22, green: 0.45, blue: 0.58)
    static let cornerRadius: CGFloat = 18
    static let smallCornerRadius: CGFloat = 14

    static var backgroundGradient: LinearGradient {
        LinearGradient(
            colors: [backgroundTop, backgroundMiddle, backgroundBottom],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
}

extension View {
    func appScreenBackground() -> some View {
        background {
            ZStack {
                AppTheme.backgroundGradient

                Circle()
                    .fill(AppTheme.warmHighlight.opacity(0.18))
                    .frame(width: 260, height: 260)
                    .blur(radius: 48)
                    .offset(x: -150, y: -260)

                Circle()
                    .fill(AppTheme.coolHighlight.opacity(0.16))
                    .frame(width: 300, height: 300)
                    .blur(radius: 56)
                    .offset(x: 170, y: 330)
            }
            .ignoresSafeArea()
        }
    }

    func modernSurfaceCard(padding: CGFloat = 16) -> some View {
        self
            .padding(padding)
            .background(AppTheme.surface, in: RoundedRectangle(cornerRadius: AppTheme.cornerRadius))
            .overlay(
                RoundedRectangle(cornerRadius: AppTheme.cornerRadius)
                    .stroke(AppTheme.border.opacity(0.24))
            )
            .shadow(color: AppTheme.shadow, radius: 16, x: 0, y: 8)
    }
}
