import SwiftUI
import Kingfisher

/**
    A view that displays a molecule.
*/

struct MoleculeView: View {
    @Environment(\.horizontalSizeClass) var sizeClass
    
    @State var molecules: [Molecule] = []
    
    var body: some View {
        if sizeClass == .regular {
            let columns = [
                GridItem(.flexible(minimum: 180), spacing: 24),
                GridItem(.flexible(minimum: 180), spacing: 24)
            ]
            
            ScrollView {
                LazyVGrid(columns: columns, spacing: 24) {
                    ForEach(molecules) { molecule in
                        MoleculeButton(molecule: molecule)
                            .padding(8)
                    }
                }
                .padding()
            }
            .edgesIgnoringSafeArea(.bottom)
            .padding(.horizontal, 8)
            .navigationTitle("Molecules")
            .onAppear {
                loadMolecules()
            }
        } else {
            ScrollView {
                LazyVStack(spacing: 24) {
                    ForEach(molecules) { molecule in
                        MoleculeButton(molecule: molecule)
                            .padding(.horizontal, 8)
                    }
                }
                .padding()
            }
            .edgesIgnoringSafeArea(.bottom)
            .navigationTitle("Molecules")
            .onAppear {
                loadMolecules()
            }
        }
    }
    
    func loadMolecules() {
        guard let url = Bundle.main.url(forResource: "molecules", withExtension: "json") else { return }

        do {
            let data = try Data(contentsOf: url)
            molecules = try JSONDecoder().decode([Molecule].self, from: data)
        } catch {
            print("Error loading JSON: \(error.localizedDescription)")
        }
    }
}

struct MoleculeView_Previews: PreviewProvider {
    static var previews: some View {
        MoleculeView()
    }
}
