import SwiftUI

struct ArtworkView: View {
    enum Style {
        case thumbnail
        case detail
    }

    let url: URL?
    let category: MediaCategory
    var style: Style = .thumbnail
    @State private var viewModel = ArtworkViewModel()

    var body: some View {
        Group {
            if style == .detail {
                detailArtwork
            } else {
                thumbnailArtwork
            }
        }
        .task(id: url) {
            await viewModel.load(from: url)
        }
    }

    private var thumbnailArtwork: some View {
        artworkContent(contentMode: .fill)
            .frame(width: 92, height: 124)
            .clipped()
            .clipShape(RoundedRectangle(cornerRadius: AppTheme.smallCornerRadius))
            .shadow(color: AppTheme.shadow.opacity(0.7), radius: 8, x: 0, y: 5)
            .overlay(
                RoundedRectangle(cornerRadius: AppTheme.smallCornerRadius)
                    .stroke(AppTheme.border.opacity(0.45))
            )
    }

    private var detailArtwork: some View {
        HStack {
            Spacer(minLength: 0)
            detailArtworkContent
            Spacer(minLength: 0)
        }
        .padding(.horizontal, 16)
    }

    @ViewBuilder
    private var detailArtworkContent: some View {
        if category == .game {
            framedArtwork(contentMode: .fit)
                .frame(maxWidth: .infinity)
                .aspectRatio(16.0 / 9.0, contentMode: .fit)
        } else {
            framedArtwork(contentMode: .fit)
                .frame(width: 260, height: 390)
        }
    }

    private func framedArtwork(contentMode: ContentMode) -> some View {
        artworkContent(contentMode: contentMode)
            .clipShape(RoundedRectangle(cornerRadius: AppTheme.cornerRadius))
            .shadow(color: AppTheme.deepShadow, radius: 18, x: 0, y: 10)
            .overlay(
                RoundedRectangle(cornerRadius: AppTheme.cornerRadius)
                    .stroke(AppTheme.border.opacity(0.45))
            )
    }

    private func artworkContent(contentMode: ContentMode) -> some View {
        ZStack {
            AppTheme.elevatedSurface

            if let image = viewModel.image {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: contentMode)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else if viewModel.isLoading {
                ProgressView()
            } else {
                fallback
            }
        }
    }

    private var fallback: some View {
        Image(systemName: category.iconName)
            .font(.system(size: 28, weight: .semibold))
            .foregroundStyle(AppTheme.secondaryText)
    }
}
