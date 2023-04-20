import SwiftUI

/**
    A view that displays an article.
 
    ATOMIZER
    Developed and Designed by John Seong.
*/

struct ContentView: View {
    @State private var selectedView: Int? = 0
    
    var body: some View {
        NavigationView {
            List {
                NavigationLink(
                    destination: ExploreView(),
                    tag: 0,
                    selection: $selectedView,
                    label: {
                        Label("Explore", systemImage: "eyeglasses")
                    }
                )
                
                NavigationLink(
                    destination: AtomView(),
                    tag: 1,
                    selection: $selectedView,
                    label: {
                        Label("Atoms", systemImage: "atom")
                    }
                )
                
                NavigationLink(
                    destination: MoleculeView(),
                    tag: 2,
                    selection: $selectedView,
                    label: {
                        Label("Molecules", systemImage: "drop.degreesign")
                    }
                )
                
                Section(header: Text("Readings")) {
                    NavigationLink(
                        destination: ArticleDetailView(article: instruction1),
                        tag: 3,
                        selection: $selectedView,
                        label: {
                            Label("HOMO and LUMO?", systemImage: "bolt.horizontal.circle")
                        }
                    )
                }
            }
            .navigationTitle("Atomizer")
            
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
