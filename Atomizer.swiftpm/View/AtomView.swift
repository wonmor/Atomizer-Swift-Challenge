import SwiftUI

let jsonURL = Bundle.main.url(forResource: "atoms", withExtension: "json")!
let jsonData = try! Data(contentsOf: jsonURL)
let decoder = JSONDecoder()
let elements = try! decoder.decode([Element].self, from: jsonData)

// Now you can use the `elements` array in your SwiftUI code
struct AtomView: View {
    @Environment(\.adaptiveSize) var adaptiveSize
    
    private var isIPad: Bool {
        return adaptiveSize.width >= 768
    }
    
    var columns: [GridItem] {
        return Array(repeating: GridItem(.flexible()), count: isIPad ? 6 : 3)
    }
    
    var body: some View {
        ScrollView(.vertical) {
            LazyVGrid(columns: columns, spacing: 16) {
                ForEach(elements, id: \.symbol) { element in
                    NavigationLink(destination: AtomDetailView(element: element)) {
                        VStack {
                            Text(element.symbol)
                                .font(.system(size: 24, weight: .bold))
                                .frame(width: 50, height: 50)
                                .background(Color.white.opacity(0.2))
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

struct AtomsView_Previews: PreviewProvider {
    static var previews: some View {
        AtomView()
    }
}
