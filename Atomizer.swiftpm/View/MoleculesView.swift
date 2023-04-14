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
    Molecule(name: "Hydrogen Chloride", formula: "HCl", imageURL: URL(string: "https://webbook.nist.gov/cgi/cbook.cgi?Struct=C7647010&Type=Color")),
    Molecule(name: "Chlorine", formula: "Cl2", imageURL: URL(string: "https://webbook.nist.gov/cgi/cbook.cgi?Struct=C7782505&Type=Color"))
]


struct MoleculeButton: View {
    let molecule: Molecule

    @State private var image: UIImage?

    var body: some View {
        VStack {
            if let image = image {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 100)
            } else {
                ProgressView()
                    .frame(height: 100)
            }

            Text(molecule.name)
                .font(.title2)
                .foregroundColor(.primary)
                .padding(.top, 8)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(8)
        .shadow(radius: 4)
        .onAppear {
            loadImage()
        }
    }
    private func loadImage() {
            guard let imageURL = molecule.imageURL else {
                return
            }

            let processor = DownsamplingImageProcessor(size: CGSize(width: 200, height: 200))
                |> RoundCornerImageProcessor(cornerRadius: 8)
            let options: KingfisherOptionsInfo = [
                .processor(processor),
                .scaleFactor(UIScreen.main.scale),
                .transition(.fade(1)),
                .cacheOriginalImage
            ]

            KingfisherManager.shared.retrieveImage(with: imageURL, options: options) { result in
                switch result {
                case .success(let value):
                    self.image = value.image
                case .failure(let error):
                    print("Job failed: \(error.localizedDescription)")
                }
            }
        }
    }

struct MoleculeDetailView: View {
    let molecule: Molecule

    @State private var image: UIImage?

    var body: some View {
        VStack {
            if let image = image {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 200)
            } else {
                ProgressView()
                    .frame(height: 200)
            }

            Text(molecule.formula)
                .font(.title2)
                .foregroundColor(.primary)
                .padding(.top, 16)

            Spacer()
        }
        .padding()
        .background(Color.white)
        .cornerRadius(8)
        .shadow(radius: 4)
        .navigationTitle(molecule.name)
        .onAppear {
            loadImage()
        }
    }

    private func loadImage() {
        guard let imageURL = molecule.imageURL else {
            return
        }

        let processor = DownsamplingImageProcessor(size: CGSize(width: 300, height: 300))
        let options: KingfisherOptionsInfo = [
            .processor(processor),
            .scaleFactor(UIScreen.main.scale),
            .transition(.fade(1)),
            .cacheOriginalImage
        ]

        KingfisherManager.shared.retrieveImage(with: imageURL, options: options) { result in
            switch result {
            case .success(let value):
                self.image = value.image
            case .failure(let error):
                print("Job failed: \(error.localizedDescription)")
            }
        }
    }
}

struct MoleculesView: View {
let columns = [
GridItem(.adaptive(minimum: 150), spacing: 16)
]
    var body: some View {
    NavigationView {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 16) {
                ForEach(molecules) { molecule in
                    NavigationLink(destination: MoleculeDetailView(molecule: molecule)) {
                        MoleculeButton(molecule: molecule)
                    }
                }
            }
            .padding()
        }
        .navigationTitle("Molecules")
    }
}
}

struct MoleculesView_Previews: PreviewProvider {
static var previews: some View {
MoleculesView()
}
}
