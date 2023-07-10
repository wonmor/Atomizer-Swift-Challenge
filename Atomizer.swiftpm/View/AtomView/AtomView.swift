import SwiftUI

let localizationManager = LocalizationManager.shared
let jsonURL = Bundle.main.url(forResource: localizationManager.getCurrentLocale().starts(with: "ko") ? "ko_atoms" : "atoms", withExtension: "json")!
let jsonData = try! Data(contentsOf: jsonURL)
let decoder = JSONDecoder()
let elements = try! decoder.decode([Element].self, from: jsonData)

/**
 A view that displays a list of atoms.
 
 ATOMIZER
 Developed and Designed by John Seong.
 */

struct AtomView: View {
    @Environment(\.adaptiveSize) var adaptiveSize
    
    @Binding var isShowingSheet: Bool
    
    @State private var result: Bool = true
    @State private var action: Int? = 0
    
    private var isIPad: Bool {
        return adaptiveSize.width >= 768
    }
    
    var columns: [GridItem] {
        return Array(repeating: GridItem(.flexible()), count: isIPad ? 6 : 3)
    }
    
    var body: some View {
        ScrollView(.vertical) {
            VStack {
                Text(localizationManager.localizedString(for: "atoms-promo-text"))
                    .font(.caption)
                    .padding(.horizontal)
                    .foregroundColor(Color.gray)
                    .multilineTextAlignment(.leading)
                
                LazyVGrid(columns: columns, spacing: 16) {
                    ForEach(elements.indices, id: \.self) { index in
                        VStack {
                            NavigationLink(destination: AtomDetailView(element: elements[index]), tag: index + 1, selection: $action) {
                                EmptyView()
                            }
                            
                            Button(action: {
                                result = StoreManager.shared.incrementButtonClickCount()
                                
                                if result == false {
                                    isShowingSheet = true
                                    
                                } else {
                                    //perform some tasks if needed before opening Destination view
                                    self.action = index + 1
                                }
                            }) {
                                VStack {
                                    Text(elements[index].symbol)
                                        .font(Font.system(size: 24, weight: .bold, design: .rounded))
                                        .frame(width: 50, height: 50)
                                        .foregroundColor(Color(AtomView.hexStringToUIColor(hex: elements[index].color)))
                                        .background(Color.white.opacity(0.2))
                                        .clipShape(Circle())
                                    Text(elements[index].name)
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                }
                .padding()
            }
        }
        .navigationTitle(localizationManager.localizedString(for: "atoms"))
    }
    
    static func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}
