import SwiftUI

/**
    A view that displays an article.
*/

struct ArticleCardView: View {
    let article: Article
    
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            AsyncImage(url: URL(string: article.imageUrl)) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(height: 150)
                    .cornerRadius(8)
            } placeholder: {
                ProgressView()
                    .frame(height: 150)
            }
            Text(article.title)
                .font(.headline)
                .lineLimit(2)
                .foregroundColor(colorScheme == .dark ? .white : .primary)
            Text(article.subtitle)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .lineLimit(3)
                .foregroundColor(colorScheme == .dark ? .white : .secondary)
            Spacer()
        }
        .padding()
        .background(colorScheme == .dark ? Color(.darkGray) : Color.white)
        .cornerRadius(8)
        .shadow(radius: 4)
    }
}
