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
                
                NavigationLink(
                    destination: MoleculeView(),
                    tag: 2,
                    selection: $selectedView,
                    label: {
                        Label(localizationManager.localizedString(for: "molecules"), systemImage: "drop.degreesign")
                    }
                )
                
                Section(header: Text(localizationManager.localizedString(for: "readings"))) {
                    NavigationLink(
                        destination: ArticleDetailView(article: instruction2),
                        tag: 3,
                        selection: $selectedView,
                        label: {
                            Label("Swift Student Challenge!", systemImage: "graduationcap.circle")
                        }
                    )
                    
                    NavigationLink(
                        destination: ArticleDetailView(article: instruction3),
                        tag: 4,
                        selection: $selectedView,
                        label: {
                            Label(localizationManager.localizedString(for: "bohr-article-title"), systemImage: "globe")
                        }
                    )
                    
                    NavigationLink(
                        destination: ArticleDetailView(article: instruction1),
                        tag: 5,
                        selection: $selectedView,
                        label: {
                            Label(localizationManager.localizedString(for: "homo-and-lumo-title"), systemImage: "bolt.horizontal.circle")
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
                } else if selectedView == 2 {
                    MoleculeView()
                }
            }
        }
    }
}
