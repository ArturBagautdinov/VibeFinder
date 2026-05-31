import Foundation
import SwiftUI

struct HistoryDetailScreen: View {
    let record: SearchRecord
    let searchViewModel: SearchViewModel
    let libraryViewModel: LibraryViewModel
    @Binding var path: NavigationPath

    var body: some View {
        ScrollView {
            LazyVStack(alignment: .leading, spacing: 12) {
                Text(record.prompt)
                    .font(.title2.bold())
                    .foregroundStyle(AppTheme.ink)
                    .padding(.bottom, 4)

                ForEach(libraryViewModel.sections(for: record)) { section in
                    VStack(alignment: .leading, spacing: 10) {
                        Label(section.category.title, systemImage: section.category.iconName)
                            .font(.headline.weight(.semibold))
                            .foregroundStyle(AppTheme.ink)
                            .padding(.top, 2)

                        ForEach(section.items) { item in
                            Button {
                                path.append(item)
                            } label: {
                                MediaCardView(
                                    item: item,
                                    isFavorite: libraryViewModel.isFavorite(item),
                                    onFavoriteTap: { libraryViewModel.toggleFavorite(item) }
                                )
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
            }
            .padding(16)
        }
        .appScreenBackground()
        .navigationTitle("Prompt")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            Button {
                searchViewModel.openHistoryRecord(record)
            } label: {
                Label("Restore to search", systemImage: "arrow.uturn.backward")
            }
        }
    }
}
