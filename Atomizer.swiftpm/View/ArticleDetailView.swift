import SwiftUI

/**
    A view that displays an article.
*/

struct ArticleDetailView: View {
    let article: Article
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                AsyncImage(url: URL(string: article.imageUrl)) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(height: 200)
                        .cornerRadius(8)
                } placeholder: {
                    ProgressView()
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Text(article.title)
                        .font(.title)
                        .fontWeight(.bold)
                    
                    Text(article.subtitle)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    Divider()
                    
                    FormattedTextView(text: article.content)
                }
                .padding(.top, 16)
                .padding(.bottom, 32)
                
                Spacer()
            }
            .padding(.horizontal)
        }
        .navigationTitle("Article")
    }
}
