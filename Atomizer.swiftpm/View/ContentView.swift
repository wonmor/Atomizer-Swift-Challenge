import SwiftUI

/**
    A view that displays an article.
 
    ATOMIZER
    Developed and Designed by John Seong.
*/

struct ContentView: View {
    @State private var selectedView: Int? = 0
    
    let localizationManager = LocalizationManager.shared
    
    var body: some View {
        NavigationView {
            List {
                NavigationLink(
                    destination: ExploreView(),
                    tag: 0,
                    selection: $selectedView,
                    label: {
                        Label(localizationManager.localizedString(for: "explore"), systemImage: "eyeglasses")
                    }
                )
                
                NavigationLink(
                    destination: AtomView(),
                    tag: 1,
                    selection: $selectedView,
                    label: {
                        Label(localizationManager.localizedString(for: "atoms"), systemImage: "atom")
                    }
                )
                
                Section(header: Text(localizationManager.localizedString(for: "readings"))) {
                    NavigationLink(
                        destination: ArticleDetailView(article: localizationManager.getCurrentLocale().starts(with: "ko") ? koInstruction2 : instruction2),
                        tag: 3,
                        selection: $selectedView,
                        label: {
                            Label(localizationManager.localizedString(for: "swift-challenge"), systemImage: "graduationcap")
                        }
                    )
                    
                    NavigationLink(
                        destination: ArticleDetailView(article: localizationManager.getCurrentLocale().starts(with: "ko") ? koInstruction3 : instruction3),
                        tag: 4,
                        selection: $selectedView,
                        label: {
                            Label(localizationManager.localizedString(for: "bohr-article-title"), systemImage: "function")
                        }
                    )
                }
            }
            .navigationTitle("Atomizer AR")
            
            ZStack {
                if selectedView == 0 {
                    ExploreView()
                } else if selectedView == 1 {
                    AtomView()
                }
            }
        }
    }
}
