import SwiftUI

struct Element: Codable {
    let symbol: String
    let name: String
    let category: String
    let description: String
    let electronConfiguration: String
    let atomicMass: Double
    let oxidationStates: Int
}

let jsonURL = Bundle.main.url(forResource: "atoms", withExtension: "json")!
let jsonData = try! Data(contentsOf: jsonURL)
let decoder = JSONDecoder()
let elements = try! decoder.decode([Element].self, from: jsonData)

// Now you can use the `elements` array in your SwiftUI code
struct AtomsView: View {
    var body: some View {
        ScrollView(.vertical) {
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3), spacing: 16) {
                ForEach(elements, id: \.symbol) { element in
                    NavigationLink(destination: ElementView(element: element)) {
                        VStack {
                            Text(element.symbol)
                                .font(.system(size: 24, weight: .bold))
                                .frame(width: 50, height: 50)
                                .background(Color.gray.opacity(0.1))
                                .clipShape(Circle())
                            Text(element.name)
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .padding()
        }
        .navigationTitle("Atoms")
    }
}

struct ElementView: View {
    let element: Element
    
    var body: some View {
        VStack {
            Text(element.symbol)
                .font(.system(size: 96, weight: .bold))
            Text("\(element.atomicMass)")
                .font(.title)
                .padding(.bottom)
            Text(element.description)
                .padding(.horizontal)
            Spacer()
        }
        .navigationBarTitle(element.name)
    }
}

struct AtomsView_Previews: PreviewProvider {
    static var previews: some View {
        AtomsView()
    }
}
