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

struct InvertColors: ViewModifier {
    func body(content: Content) -> some View {
        content
            .colorInvert()
    }
}

extension View {
    func invertColors() -> some View {
        self.modifier(InvertColors())
    }
}

struct MoleculeButton: View {
    let molecule: Molecule

    @State private var image: UIImage?

    var body: some View {
        VStack {
            if let image = image {
                ZStack {
                    Image(uiImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(height: 100)
                        .clipped()
                        .blur(radius: 24)
                        .overlay(Color.black.opacity(0.6))
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                    
                    Image(uiImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 100)
                        .clipped()
                        .invertColors()
                        .blur(radius: 3)
                    
                    Text(molecule.name)
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .shadow(color: .black, radius: 3)
                }
            } else {
                ProgressView()
                    .frame(height: 100)
            }
        }
        .padding()
        .background(
            LinearGradient(gradient: Gradient(colors: [Color.gray.opacity(0.5), Color.gray.opacity(0.3)]), startPoint: .leading, endPoint: .trailing)
        )
        .shadow(radius: 8)
        .clipShape(RoundedRectangle(cornerRadius: 12))
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
                    .invertColors()
            } else {
                ProgressView()
                    .frame(height: 200)
            }

            Text(molecule.formula)
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.primary)
                .padding(.top, 16)

            Spacer()
        }
        .padding()
        .background(Color.white)
        .cornerRadius(16)
        .shadow(radius: 8)
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
        GridItem(.adaptive(minimum: 180), spacing: 24)
    ]
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 24) {
                ForEach(molecules) { molecule in
                    MoleculeButton(molecule: molecule)
                        .padding(8)
                }
            }
            .padding()
        }
        .background(Color(.systemGroupedBackground))
        .edgesIgnoringSafeArea(.bottom)
        .padding(.horizontal, 8) // Add horizontal padding
        .navigationTitle("Molecules")
    }
}

struct MoleculesView_Previews: PreviewProvider {
    static var previews: some View {
        MoleculesView()
    }
}
