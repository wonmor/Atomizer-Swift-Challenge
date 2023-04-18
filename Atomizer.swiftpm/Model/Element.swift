import Foundation

/**
 * A model that represents an element on the periodic table.
 */

struct Element: Codable {
    let symbol: String
    let name: String
    let category: String
    let description: String
    let electronConfiguration: String
    let atomicMass: Double
    let oxidationStates: Int
    let orbitalBlock: String
    let color: String
}
