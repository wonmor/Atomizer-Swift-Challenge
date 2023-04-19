import SwiftUI

/**
    A view that displays an article.
 
    ATOMIZER
    Developed and Designed by John Seong.
*/

struct ArticleDetailView: View {
    let article: Article
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                if let image = UIImage(named: article.imageUrl) {
                   Image(uiImage: image)
                       .resizable()
                       .aspectRatio(contentMode: .fill)
                       .frame(height: 200)
                       .cornerRadius(8)
               } else {
                   RoundedRectangle(cornerRadius: 8)
                       .fill(Color.gray)
                       .frame(height: 200)
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
