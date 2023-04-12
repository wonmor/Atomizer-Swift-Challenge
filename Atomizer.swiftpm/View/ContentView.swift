import SwiftUI

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
                    destination: AtomsView(),
                    tag: 1,
                    selection: $selectedView,
                    label: {
                        Label("Atoms", systemImage: "atom")
                    }
                )
                NavigationLink(
                    destination: MoleculesView(),
                    tag: 2,
                    selection: $selectedView,
                    label: {
                        Label("Molecules", systemImage: "drop.degreesign")
                    }
                )
            }
            .navigationTitle("Atomizer")
            
            ZStack {
                if selectedView == 0 {
                    ExploreView()
                } else if selectedView == 1 {
                    AtomsView()
                } else if selectedView == 2 {
                    MoleculesView()
                }
            }
        }
    }
}
