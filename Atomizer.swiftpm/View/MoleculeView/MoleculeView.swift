import SwiftUI
import Kingfisher

/**
    A view that displays a molecule.
*/

struct MoleculeView: View {
    @Environment(\.horizontalSizeClass) var sizeClass
    
    @State var molecules: [Molecule] = []
    
    let localizationManager = LocalizationManager.shared
    
    var body: some View {
        if sizeClass == .regular {
            let columns = [
                GridItem(.flexible(minimum: 180), spacing: 24),
                GridItem(.flexible(minimum: 180), spacing: 24)
            ]
            
            ScrollView {
                VStack {
                    Text(localizationManager.localizedString(for: "molecules-promo-text"))
                        .font(.caption)
                        .padding(.horizontal)
                        .foregroundColor(Color.gray)
                        .multilineTextAlignment(.leading)
                    
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
                .navigationTitle(localizationManager.localizedString(for: "molecules"))
                .onAppear {
                    loadMolecules()
                }
            }
        } else {
            ScrollView {
                VStack {
                    Text(localizationManager.localizedString(for: "molecules-promo-text"))
                        .font(.caption)
                        .padding(.horizontal)
                        .foregroundColor(Color.gray)
                        .multilineTextAlignment(.leading)
                    
                    LazyVStack(spacing: 24) {
                        ForEach(molecules) { molecule in
                            MoleculeButton(molecule: molecule)
                                .padding(.horizontal, 8)
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle(localizationManager.localizedString(for: "molecules"))
            .onAppear {
                loadMolecules()
            }
        }
    }
    
    func loadMolecules() {
        guard let url = Bundle.main.url(forResource: localizationManager.getCurrentLocale().starts(with: "ko") ? "ko_molecules" : "molecules", withExtension: "json") else { return }

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
