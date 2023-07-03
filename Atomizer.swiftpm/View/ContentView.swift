import SwiftUI

/**
    A view that displays an article.
 
    ATOMIZER
    Developed and Designed by John Seong.
*/

struct ContentView: View {
    @State private var selectedView: Int? = 0
    
    let localizationManager = LocalizationManager.shared
    
    init() {
        var titleFont = UIFont.preferredFont(forTextStyle: .largeTitle) /// the default large title font
        titleFont = UIFont(
            descriptor:
                titleFont.fontDescriptor
                .withDesign(.rounded)? /// make rounded
                .withSymbolicTraits(.traitBold) /// make bold
            ??
            titleFont.fontDescriptor, /// return the normal title if customization failed
            size: titleFont.pointSize
        )
        
        /// set the rounded font
        UINavigationBar.appearance().largeTitleTextAttributes = [.font: titleFont]
    }
    
    var body: some View {
        NavigationView {
            List {
                NavigationLink(
                    destination: ExploreView(selectedView: $selectedView),
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
                    
                    NavigationLink(
                        destination: ArticleDetailView(article: localizationManager.getCurrentLocale().starts(with: "ko") ? koInstruction1 : instruction1),
                        tag: 5,
                        selection: $selectedView,
                        label: {
                            Label(localizationManager.localizedString(for: "homo-and-lumo-title"), systemImage: "figure.2.and.child.holdinghands")
                        }
                    )
                }
            }
            .navigationTitle("Atomizer AR")
            
            ZStack {
                if selectedView == 0 {
                    ExploreView(selectedView: $selectedView)
                } else if selectedView == 1 {
                    AtomView()
                } else if selectedView == 2 {
                    MoleculeView()
                }
            }
        }.environment(\.font, Font.system(.body, design: .rounded))
    }
}
