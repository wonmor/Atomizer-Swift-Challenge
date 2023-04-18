import Foundation

/**
   A model that represents a molecule.

   ATOMIZER
   Developed and Designed by John Seong.
 */

class Molecule: Identifiable, Decodable {
    let id = UUID()
    let name: String
    let formula: String
    let description: String
    let shape: String
    let polarity: String
    let bondAngle: String
    let orbitals: String
    let hybridization: String
    let molecularGeometry: String
    let bonds: String
    let imageURL: URL?
    
    enum CodingKeys: String, CodingKey {
        case name, formula, description, shape, polarity, bondAngle, orbitals, hybridization, molecularGeometry, bonds
        case imageURL = "imageURL"
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(String.self, forKey: .name)
        formula = try container.decode(String.self, forKey: .formula)
        description = try container.decode(String.self, forKey: .description)
        shape = try container.decode(String.self, forKey: .shape)
        polarity = try container.decode(String.self, forKey: .polarity)
        bondAngle = try container.decode(String.self, forKey: .bondAngle)
        orbitals = try container.decode(String.self, forKey: .orbitals)
        hybridization = try container.decode(String.self, forKey: .hybridization)
        molecularGeometry = try container.decode(String.self, forKey: .molecularGeometry)
        bonds = try container.decode(String.self, forKey: .bonds)
        imageURL = try container.decodeIfPresent(URL.self, forKey: .imageURL)
    }
}
