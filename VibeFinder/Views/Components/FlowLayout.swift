import SwiftUI

struct FlowLayout<Content: View>: View {
    let items: [String]
    let content: (String) -> Content

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(items, id: \.self) { item in
                    content(item)
                }
            }
        }
    }
}
