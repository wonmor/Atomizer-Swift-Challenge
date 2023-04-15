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
                                .foregroundColor(Color(UIColor(hexString: element.color) ?? .clear))
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

extension UIColor {
    convenience init?(hexString: String) {
        let r, g, b, a: CGFloat

        if hexString.hasPrefix("#") {
            let start = hexString.index(hexString.startIndex, offsetBy: 1)
            let hexColor = String(hexString[start...])

            if hexColor.count == 8 {
                let scanner = Scanner(string: hexColor)
                var hexNumber: UInt64 = 0

                if scanner.scanHexInt64(&hexNumber) {
                    r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
                    g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
                    b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
                    a = CGFloat(hexNumber & 0x000000ff) / 255

                    self.init(red: r, green: g, blue: b, alpha: a)
                    return
                }
            }
        }

        return nil
    }
}
