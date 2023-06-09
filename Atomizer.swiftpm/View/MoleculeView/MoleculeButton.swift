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
    @State private var result: Bool = true
    @State private var action: Int? = 0
    
    @Binding var isShowingSheet: Bool
    
    var body: some View {
        VStack {
            NavigationLink(destination: MoleculeDetailView(molecule: molecule), tag: 1, selection: $action) {
                EmptyView()
            }
            
            Button(action: {
                result = StoreManager.shared.incrementButtonClickCount()
                
                if result == false {
                    isShowingSheet = true
                    
                } else {
                    //perform some tasks if needed before opening Destination view
                    self.action = 1
                }
            }) {
                
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
                                .font(Font.system(.title2, design: .rounded))
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
