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
                Image("background-image")
                    .resizable()
                    .scaledToFill()
                    .frame(height: UIScreen.main.bounds.width < 500 ? adaptiveSize.width * 0.4 : adaptiveSize.width * 0.2)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    .brightness(-0.2)
                    .overlay(Color.black.opacity(0.4))
                
                VStack(alignment: .center) {
                    Text("Visualizing")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(.primary)
                    
                    Text("Quantum Mechanics")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(.secondary)
                    
                    NavigationLink(destination: ArticleDetailView(article: instruction2)) {
                        VStack(spacing: 4) {
                            Image(systemName: "medal")
                                .foregroundColor(Color.white)
                            
                            Text("Swift Student Challenge 2023 Winner")
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
            
            Text("All visuals were generated from scratch using SciPy, PySCF, and GPAW.")
                .font(.caption)
                .padding(.horizontal)
                .foregroundColor(Color.gray)
                .multilineTextAlignment(.center)
            
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 150), spacing: 16)], spacing: 16) {
                ForEach(articleData.articles) { article in
                    if (article.title.contains("Atom") || article.title.contains("Atomic")) {
                        NavigationLink(destination: AtomView()) {
                            ArticleCardView(article: article)
                        }
                        .id(article.id)
                    } else {
                        NavigationLink(destination: MoleculeView()) {
                            ArticleCardView(article: article)
                        }
                        .id(article.id)
                    }
                }
            }
            .padding()
            
            Text("Developed and Designed by John Seong.")
                .font(.caption)
                .padding(.horizontal)
                .padding(.bottom)
                .foregroundColor(Color.gray)
                .multilineTextAlignment(.center)
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
