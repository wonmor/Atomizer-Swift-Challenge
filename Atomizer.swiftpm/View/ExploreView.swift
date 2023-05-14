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
    
    let localizationManager = LocalizationManager.shared
    
    var body: some View {
        ScrollView {
            ZStack {
                Image("background-image")
                    .resizable()
                    .scaledToFill()
                    .frame(height: UIScreen.main.bounds.width < 500 ? adaptiveSize.width * 0.4 : adaptiveSize.width * 0.2)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    .brightness(-0.2)
                    .overlay(Color.black.opacity(0.4))
                
                VStack(alignment: .center) {
                    Text(localizationManager.localizedString(for: "promo-text"))
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(.primary)
                    
                    Text(localizationManager.localizedString(for: "promo-text-2"))
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(.secondary)
                    
                    NavigationLink(destination: ArticleDetailView(article: localizationManager.getCurrentLocale().starts(with: "ko") ? koInstruction2 : instruction2)) {
                        VStack(spacing: 4) {
                            Image(systemName: "medal")
                                .foregroundColor(Color.white)
                            
                            Text(localizationManager.localizedString(for: "swift-winner"))
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(.white)
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(Color.indigo)
                        .cornerRadius(8)
                    }
                    .padding(16)
                }
                .padding(.top, adaptiveSize.width * 0.1)
                .multilineTextAlignment(.center)
            }
            .padding()
            
            Text(localizationManager.localizedString(for: "explore-explain"))
                .font(.caption)
                .padding(.horizontal)
                .foregroundColor(Color.gray)
                .multilineTextAlignment(.center)
            
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 150), spacing: 16)], spacing: 16) {
                ForEach(articleData.articles) { article in
                    if (article.title.contains("Atom") || article.title.contains("Atomic") || article.title.contains("원자")) {
                        NavigationLink(destination: AtomView()) {
                            ArticleCardView(article: article)
                        }
                        .id(article.id)
                    }
                }
            }
            .padding()
            
            Text(localizationManager.localizedString(for: "credit"))
                .font(.caption)
                .padding(.horizontal)
                .padding(.bottom)
                .foregroundColor(Color.gray)
                .multilineTextAlignment(.center)
        }
        .padding(.horizontal)
        .navigationTitle(localizationManager.localizedString(for: "explore"))
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
