import SwiftUI

/**
    A view that displays an article.
 
    ATOMIZER
    Developed and Designed by John Seong.
 */

struct ExploreView: View {
    @Environment(\.adaptiveSize) var adaptiveSize
    @Environment(\.colorScheme) var colorScheme
    
    @ObservedObject var articleData = ArticleViewModel()
    
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
                    
                    Text("Discover the latest atoms and molecules")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(.secondary)
                }
                .padding(.top, adaptiveSize.width * 0.1)
            }
            .padding()
            
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 150), spacing: 16)], spacing: 16) {
                ForEach(articleData.articles) { article in
                    NavigationLink(destination: ArticleDetailView(article: article)) {
                        ArticleCardView(article: article)
                    }
                    .id(article.id)
                }
            }
            .padding()
        }
        .padding(.horizontal)
        .navigationTitle("Explore")
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

extension EnvironmentValues {
    var adaptiveSize: CGSize {
        get { self[AdaptiveSizeKey.self] }
        set { self[AdaptiveSizeKey.self] = newValue }
    }
}

private struct AdaptiveSizeKey: EnvironmentKey {
    static let defaultValue: CGSize = UIScreen.main.bounds.size
}
