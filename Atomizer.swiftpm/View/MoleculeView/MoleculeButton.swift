import SwiftUI
import Kingfisher

/**
    Inverts the colors of a view.
*/

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

/**
    A view that displays a molecule.
*/

struct MoleculeButton: View {
    let molecule: Molecule
    
    @State private var image: UIImage?

    var body: some View {
        NavigationLink(destination: MoleculeDetailView(molecule: molecule)) {
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
                            .blur(radius: 4)
                        
                        Text(molecule.name)
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .shadow(color: .black, radius: 3)
                            .lineLimit(nil)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                } else {
                    ProgressView()
                        .frame(height: 100)
                }
            }
            .frame(maxWidth: .infinity)
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
    }
    
    private func loadImage() {
        guard let imageName: String? = molecule.imageURL else {
            return
        }
        self.image = UIImage(named: imageName!)
    }
}
