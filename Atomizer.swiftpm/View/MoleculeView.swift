import SwiftUI
import Kingfisher

struct Molecule: Identifiable {
    let id = UUID()
    let name: String
    let formula: String
    let imageURL: URL?
}

let molecules = [
    Molecule(name: "Ethene", formula: "C2H4", imageURL: URL(string: "https://webbook.nist.gov/cgi/cbook.cgi?Struct=C74851&Type=Color")),
    Molecule(name: "Water", formula: "H2O", imageURL: URL(string: "https://webbook.nist.gov/cgi/cbook.cgi?Struct=C7732185&Type=Color")),
    Molecule(name: "Hydrogen", formula: "H2", imageURL: URL(string: "https://webbook.nist.gov/cgi/cbook.cgi?Struct=C1333740&Type=Color")),
    Molecule(name: "Hydrochloric Acid", formula: "HCl", imageURL: URL(string: "https://webbook.nist.gov/cgi/cbook.cgi?Struct=C7647010&Type=Color")),
    Molecule(name: "Chlorine", formula: "Cl2", imageURL: URL(string: "https://webbook.nist.gov/cgi/cbook.cgi?Struct=C7782505&Type=Color"))
]

struct MoleculeView: View {
    @Environment(\.horizontalSizeClass) var sizeClass
    
    var body: some View {
        if sizeClass == .regular {
            let columns = [
                    GridItem(.flexible(minimum: 180), spacing: 24), // Use flexible GridItem with minimum width
                    GridItem(.flexible(minimum: 180), spacing: 24)  // Add a second GridItem
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
                    .padding(.horizontal, 8) // Add horizontal padding
                    .navigationTitle("Molecules")
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
        }
    }
}

struct MoleculeView_Previews: PreviewProvider {
    static var previews: some View {
        MoleculeView()
    }
}
