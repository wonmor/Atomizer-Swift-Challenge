import SwiftUI

struct ExploreView: View {
    @Environment(\.adaptiveSize) var adaptiveSize
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        ScrollView {
            ZStack {
                Color(colorScheme == .dark ? .darkGray : UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 0.9))
                    .frame(height: adaptiveSize.width * 0.4)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                
                VStack(alignment: .leading) {
                    Text("New and noteworthy")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(.primary)
                    
                    Text("Discover the latest apps and games")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(.secondary)
                }
                .padding(.top, adaptiveSize.width * 0.1)
            }
            .padding()
            
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 150), spacing: 16)], spacing: 16) {
                ForEach(0..<articles.count) { index in
                    NavigationLink(destination: ArticleDetailView(article: articles[index])) {
                        ArticleCardView(article: articles[index])
                    }
                }
            }
            .padding()
        }
        .padding(.horizontal)
        .navigationTitle("Explore")
    }
}


struct ArticleCardView: View {
    let article: Article
    
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Image(article.imageName)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(height: 150)
                .cornerRadius(8)
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


struct ExploreView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ExploreView()
        }
        .preferredColorScheme(.light)
    }
}


let articles = [
    Article(
        title: "Article 1",
        subtitle: "Subtitle 1",
        imageName: "article1",
        content: "This is the content for article 1."
    ),
    Article(
        title: "Article 2",
        subtitle: "Subtitle 2",
        imageName: "article2",
        content: "This is the content for article 2."
    ),
    Article(
        title: "Article 3",
        subtitle: "Subtitle 3",
        imageName: "article3",
        content: "This is the content for article 3."
    ),
    Article(
        title: "Article 4",
        subtitle: "Subtitle 4",
        imageName: "article4",
        content: "This is the content for article 4."
    ),
    Article(
        title: "Article 5",
        subtitle: "Subtitle 5",
        imageName: "article5",
        content: "This is the content for article 5."
    ),
    Article(
        title: "Article 6",
        subtitle: "Subtitle 6",
        imageName: "article6",
        content: "This is the content for article 6."
    )
]

extension EnvironmentValues {
    var adaptiveSize: CGSize {
        get { self[AdaptiveSizeKey.self] }
        set { self[AdaptiveSizeKey.self] = newValue }
    }
}

private struct AdaptiveSizeKey: EnvironmentKey {
    static let defaultValue: CGSize = UIScreen.main.bounds.size
}
