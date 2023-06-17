import SwiftUI
import Alamofire
import Kingfisher

struct ChemicalResult: Identifiable {
    let id = UUID()
    let name: String
    let formula: String
    let imageUrl: URL?
    
    var imageView: KFImage? {
        guard let imageUrl = imageUrl else { return nil }
        let processedUrl = imageUrl.absoluteString.trimmingCharacters(in: .whitespacesAndNewlines)
        let url = URL(string: processedUrl)
        return url.map { KFImage($0) }
    }
}

struct SearchBar: View {
    @State private var searchText = ""
    @State private var results: [ChemicalResult] = []

    var body: some View {
        VStack {
            HStack {
                TextField("Search", text: $searchText)
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

            if self.results.isEmpty {
                Text("No results found")
                    .foregroundColor(.gray)
            } else {
                ScrollView {
                    LazyVStack {
                        ForEach(self.results) { result in
                            VStack {
                                if let imageView = result.imageView {
                                    imageView
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 200, height: 200)
                                }
                                
                                Text("\(result.name) (\(result.formula))")
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                }
            }
        }
        .padding(.bottom)
        .padding(.leading)
        .padding(.trailing)
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
                                  let imageUrl = URL(string: "https://electronvisual.org/api/get_chemistry_image?cid=\(cid)") else {
                                return nil
                            }

                            return ChemicalResult(name: name, formula: formula, imageUrl: imageUrl)
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
