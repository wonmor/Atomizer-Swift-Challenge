import SwiftUI
import Alamofire
import Kingfisher
import UIKit
import Combine
import CoreImage
import CoreImage.CIFilterBuiltins

struct ChemicalResult: Identifiable {
    let id = UUID()
    let name: String
    let formula: String
    let imageUrl: URL?
    let otherNames: [String]
    
    var imageView: KFImage? {
            guard let imageUrl = imageUrl else { return nil }
            print(imageUrl)
            let processedUrl = imageUrl.absoluteString.trimmingCharacters(in: .whitespacesAndNewlines)
            let url = URL(string: processedUrl)
            return url.map { KFImage($0) }
        }

        var trimmedImage: UIImage? {
            guard let imageUrl = imageUrl else { return nil }
            if let imageData = try? Data(contentsOf: imageUrl),
               let image = UIImage(data: imageData) {
                return image.trim(padding: 10)
            }
            return nil
        }
    }

struct SearchBar: View {
    @State private var searchText = ""
    @State private var results: [ChemicalResult] = []
    @State private var isShowingResults = false
    
    private var searchCancellable: AnyCancellable?
    
    let context = CIContext()
     let colorFilter = CIFilter.colorControls()
     
    func processImage(_ image: UIImage) -> UIImage? {
        guard let ciImage = CIImage(image: image) else { return nil }

        // Adjust brightness and contrast to darken the gray areas
        colorFilter.inputImage = ciImage
        colorFilter.brightness = -1.0 // Decrease brightness
        colorFilter.contrast = 5.0 // Increase contrast

        guard let outputCIImage = colorFilter.outputImage else { return nil }

        // Render the filtered image
        if let outputCGImage = context.createCGImage(outputCIImage, from: outputCIImage.extent) {
            // Create a black and white filter to convert the image to black and white
            let blackAndWhiteFilter = CIFilter(name: "CIColorControls")
            blackAndWhiteFilter?.setDefaults()
            blackAndWhiteFilter?.setValue(CIImage(cgImage: outputCGImage), forKey: "inputImage")
            blackAndWhiteFilter?.setValue(0.0, forKey: "inputSaturation")

            if let blackAndWhiteImage = blackAndWhiteFilter?.outputImage,
               let processedCGImage = context.createCGImage(blackAndWhiteImage, from: blackAndWhiteImage.extent) {
                return UIImage(cgImage: processedCGImage)
            }
        }

        return nil
    }
     

    var body: some View {
        ZStack {
            Color.black
                .ignoresSafeArea()

            VStack {
                HStack {
                    TextField("Search by IUPAC Name or Formula", text: $searchText)
                        .padding(.leading, 16)
                        .padding(.vertical, 8)
                        .background(Color(.darkGray))
                        .cornerRadius(8)
                        .shadow(color: Color.white.opacity(0.1), radius: 2, x: 0, y: 2)

                    Button(action: {
                        searchPubChem(term: searchText)
                    }) {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                            .padding(.horizontal, 12)
                            .frame(height: 36)
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.gray, lineWidth: 1)
                            )
                    }
                    .buttonStyle(PlainButtonStyle())
                }
                .padding()

                if results.isEmpty {
                    Text("No results found")
                        .foregroundColor(.gray)
                        .font(.headline)
                } else {
                    VStack {
                        ForEach(results) { result in
                            Button(action: {
                                isShowingResults = true
                            }) {
                                VStack {
                                    if let trimmedImage = result.trimmedImage,
                                        let processedImage = processImage(trimmedImage) {
                                            Image(uiImage: processedImage)
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: 200, height: 200)
                                                .clipShape(Rectangle().inset(by: 10))
                                                .overlay(
                                                    GeometryReader { geometry in
                                                        Image(uiImage: trimmedImage)
                                                            .resizable()
                                                            .scaledToFit()
                                                            .frame(width: geometry.size.width, height: geometry.size.height)
                                                            .clipped()
                                                    }
                                                )
                                                .colorInvert() // Apply color inversion
                                        
                                    }
                                    Text("\(result.name.capitalized) (\(result.formula))")
                                        .foregroundColor(.white)
                                        .font(.headline)
                                }
                                .padding()
                                .background(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color.gray, lineWidth: 1)
                                )
                            }
                            .sheet(isPresented: $isShowingResults) {
                                ResultsView(results: [result])
                            }
                        }
                    }
                }
            }
        }
    }
    
    func searchPubChem(term: String) {
        let url = "https://electronvisual.org/api/get_chemistry_data?term=\(term)"

        AF.request(url)
            .validate()
            .responseDecodable(of: PubChemResponse.self) { response in
                switch response.result {
                case .success(let pubChemResponse):
                    if let compounds = pubChemResponse.PC_Compounds {
                        self.results = compounds.compactMap { compound -> ChemicalResult? in
                            let properties = extractProperties(compound: compound)

                            guard let name = properties["IUPAC Name"],
                                let formula = properties["Molecular Formula"],
                                let cid: Int? = compound.id.id.cid,
                                let imageUrl = URL(string: "https://electronvisual.org/api/get_chemistry_image?cid=\(cid!)") else {
                                    return nil
                            }
                            
                            var otherNames: [String] = []

                            compound.props.forEach { prop in
                                if prop.urn.label == "IUPAC Name",
                                   let otherName = prop.value.sval {
                                    otherNames.append(otherName.lowercased())
                                }
                            }

                            return ChemicalResult(name: name, formula: formula, imageUrl: imageUrl, otherNames: otherNames)
                        }

                        if self.results.isEmpty {
                            print("No results found")
                        }
                    } else {
                        self.results = []
                        print("No results found")
                    }
                case .failure(let error):
                    print("Error fetching data: \(error)")
                    self.results = []
                    print("No results found")
                }
            }
    }



    func extractProperties(compound: PubChemCompound) -> [String: String] {
        var properties: [String: String] = [:]

        compound.props.forEach { prop in
            if let label = prop.urn.label,
               let value = prop.value.sval {
                properties[label] = value
            }
        }

        return properties
    }
}

struct ResultsView: View {
    @Environment(\.presentationMode) var presentationMode

    let results: [ChemicalResult]

    var body: some View {
        NavigationView {
            ZStack {
                Color.black
                    .ignoresSafeArea()

                if results.isEmpty {
                    Text("No results found")
                        .foregroundColor(.gray)
                        .font(.headline)
                } else {
                    ScrollView {
                        LazyVStack(spacing: 16) {
                            ForEach(results) { result in
                                ResultRow(result: result)
                            }
                        }
                        .padding()
                    }
                }
            }
            .navigationBarTitle("Search Results")
            .navigationBarItems(trailing: Button(action: dismiss) {
                Text("Close")
            })

        }
        .navigationViewStyle(StackNavigationViewStyle())
    }

    func dismiss() {
        presentationMode.wrappedValue.dismiss()
    }

}

struct ResultRow: View {
    let result: ChemicalResult

    var body: some View {
        VStack {
            if let trimmedImage = result.trimmedImage {
                Image(uiImage: trimmedImage)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
                    .clipShape(Rectangle().inset(by: 10))
                    .overlay(
                        GeometryReader { geometry in
                            Image(uiImage: trimmedImage)
                                .resizable()
                                .scaledToFit()
                                .frame(width: geometry.size.width, height: geometry.size.height)
                                .clipped()
                        }
                    )
                    .colorInvert() // Apply color inversion
            }
        }
    }
}

struct PubChemResponse: Codable {
    let PC_Compounds: [PubChemCompound]?
}

struct PubChemCompound: Codable {
    let atoms: Atoms
    let bonds: Bonds
    let charge: Int
    let coords: [Coords]
    let count: Count
    let id: ID
    let props: [PubChemProperty]
}

struct Atoms: Codable {
    let aid: [Int]
    let element: [Int]
}

struct Bonds: Codable {
    let aid1: [Int]
    let aid2: [Int]
    let order: [Int]
}

struct Coords: Codable {
    let aid: [Int]
    let conformers: [Conformer]
    let type: [Int]
}

struct Conformer: Codable {
    let x: [Double]
    let y: [Double]
}

struct Count: Codable {
    let atom_chiral: Int
    let atom_chiral_def: Int
    let atom_chiral_undef: Int
    let bond_chiral: Int
    let bond_chiral_def: Int
    let bond_chiral_undef: Int
    let covalent_unit: Int
    let heavy_atom: Int
    let isotope_atom: Int
    let tautomers: Int
}

struct ID: Codable {
    let id: IDValue
}

struct IDValue: Codable {
    let cid: Int
}

struct PubChemProperty: Codable {
    let urn: URN
    let value: PropertyValue
}

struct URN: Codable {
    let datatype: Int
    let label: String?
    let name: String?
    let release: String?
    let software: String?
    let source: String?
    let version: String?
}

struct PropertyValue: Codable {
    let ival: Int?
    let fval: Double?
    let sval: String?
    let binary: String?
}

extension UIImage {
    func trim(padding: CGFloat) -> UIImage {
            let newRect = self.cropRect.insetBy(dx: -padding, dy: -padding) // Adjust the crop rectangle with padding
            if let imageRef = self.cgImage!.cropping(to: newRect) {
                return UIImage(cgImage: imageRef)
            }
            return self
        }

    var cropRect: CGRect {
        let cgImage = self.cgImage
        let context = createARGBBitmapContextFromImage(inImage: cgImage!)
        if context == nil {
            return CGRect.zero
        }

        let height = CGFloat(cgImage!.height)
        let width = CGFloat(cgImage!.width)

        let rect = CGRect(x: 0, y: 0, width: width, height: height)
        context?.draw(cgImage!, in: rect)

        //let data = UnsafePointer<CUnsignedChar>(CGBitmapContextGetData(context))
        guard let data = context?.data?.assumingMemoryBound(to: UInt8.self) else {
            return CGRect.zero
        }

        var lowX = width
        var lowY = height
        var highX: CGFloat = 0
        var highY: CGFloat = 0

        let heightInt = Int(height)
        let widthInt = Int(width)
        //Filter through data and look for non-transparent pixels.
        for y in (0 ..< heightInt) {
            let y = CGFloat(y)
            for x in (0 ..< widthInt) {
                let x = CGFloat(x)
                let pixelIndex = (width * y + x) * 4 /* 4 for A, R, G, B */

                if data[Int(pixelIndex)] == 0  { continue } // crop transparent

                if data[Int(pixelIndex+1)] > 0xE0 && data[Int(pixelIndex+2)] > 0xE0 && data[Int(pixelIndex+3)] > 0xE0 { continue } // crop white

                if (x < lowX) {
                    lowX = x
                }
                if (x > highX) {
                    highX = x
                }
                if (y < lowY) {
                    lowY = y
                }
                if (y > highY) {
                    highY = y
                }

            }
        }

        return CGRect(x: lowX, y: lowY, width: highX - lowX, height: highY - lowY)
    }

    func createARGBBitmapContextFromImage(inImage: CGImage) -> CGContext? {

        let width = inImage.width
        let height = inImage.height

        let bitmapBytesPerRow = width * 4
        let bitmapByteCount = bitmapBytesPerRow * height

        let colorSpace = CGColorSpaceCreateDeviceRGB()

        let bitmapData = malloc(bitmapByteCount)
        if bitmapData == nil {
            return nil
        }

        let context = CGContext (data: bitmapData,
                                 width: width,
                                 height: height,
                                 bitsPerComponent: 8,      // bits per component
            bytesPerRow: bitmapBytesPerRow,
            space: colorSpace,
            bitmapInfo: CGImageAlphaInfo.premultipliedFirst.rawValue)

        return context
    }
}
