//
//  SwiftUIView.swift
//  
//
//  Created by John Seong on 2023-04-13.
//

import SwiftUI
import Kingfisher

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
                        
                        Text("\(molecule.name).")
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
