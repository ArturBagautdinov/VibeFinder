import Foundation
import SwiftUI

struct ProfileScreen: View {
    let authViewModel: AuthViewModel
    let searchViewModel: SearchViewModel
    let libraryViewModel: LibraryViewModel
    @State private var isSignOutConfirmationPresented = false

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    VStack(alignment: .leading, spacing: 14) {
                        Text("Account")
                            .font(.headline.weight(.semibold))
                            .foregroundStyle(AppTheme.ink)

                        HStack(spacing: 12) {
                            ZStack {
                                Circle()
                                    .fill(AppTheme.accentSoft)
                                    .frame(width: 48, height: 48)
                                Image(systemName: "person.crop.circle.fill")
                                    .font(.system(size: 28, weight: .semibold))
                                    .foregroundStyle(AppTheme.accent)
                            }

                            VStack(alignment: .leading, spacing: 3) {
                                Text(authViewModel.user?.email ?? "Guest")
                                    .font(.headline)
                                    .foregroundStyle(AppTheme.ink)
                                    .lineLimit(1)
                                Text("Firebase Authentication")
                                    .font(.subheadline)
                                    .foregroundStyle(AppTheme.secondaryText)
                            }

                            Spacer(minLength: 0)
                        }
                    }
                    .modernSurfaceCard()

                    Button(role: .destructive) {
                        isSignOutConfirmationPresented = true
                    } label: {
                        HStack {
                            Label("Sign out", systemImage: "rectangle.portrait.and.arrow.right")
                            Spacer()
                        }
                        .font(.headline)
                        .padding(.vertical, 2)
                    }
                    .modernSurfaceCard()
                }
                .padding(16)
            }
            .appScreenBackground()
            .navigationTitle("Profile")
            .tint(AppTheme.accent)
            .alert("Sign out?", isPresented: $isSignOutConfirmationPresented) {
                Button("Cancel", role: .cancel) {}

                Button("Sign out", role: .destructive) {
                    Task {
                        searchViewModel.clearSearchData()
                        await libraryViewModel.clearSavedData()
                        authViewModel.signOut()
                    }
                }
            } message: {
                Text("Favorites and search history stored on this device will be removed.")
            }
        }
    }
}
