//
//  SwiftUIView.swift
//  
//
//  Created by John Seong on 2023-04-13.
//

import SwiftUI
import Kingfisher

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
