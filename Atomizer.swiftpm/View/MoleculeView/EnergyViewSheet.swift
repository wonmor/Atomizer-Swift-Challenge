import SwiftUI
import Kingfisher

struct EnergyViewSheet: View {
    let molecule: Molecule
    @Binding var isEnergyView: Bool
    
    @State private var showMessage = true
    @State private var fingerOffset: CGFloat = 0
    
    let localizationManager = LocalizationManager.shared
    
    var body: some View {
        ZStack {
            Color(.white)
                .edgesIgnoringSafeArea(.all)
            
            VStack(alignment: .center) {
                KFImage(URL(string: "https://electronvisual.org/api/downloadPNG/\(molecule.name.lowercased().trimmingCharacters(in: .whitespacesAndNewlines).replacingOccurrences(of: " ", with: "_"))_energy_diagram"))
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .padding()
                
                Text(localizationManager.localizedString(for: "energy-level-diagram"))
                    .font(.largeTitle)
                    .padding()
                    .multilineTextAlignment(.center)
                
                Text("This diagram depicts the energy levels of \(molecule.name.lowercased()). Each step in the diagram represents a change in energy state.")
                    .font(.body)
                    .padding(.horizontal)
                    .multilineTextAlignment(.center)
                
                Button(action: {
                    withAnimation(Animation.easeInOut(duration: 0.5)) {
                        isEnergyView = false
                    }
                }) {
                    HStack {
                        Image(systemName: "x.circle.fill")
                            .font(.system(size: 24))
                            .foregroundColor(.white)
                        Text("Close")
                            .foregroundColor(.white)
                            .font(.headline)
                    }
                    .padding(16)
                    .background(BlurView(style: .systemMaterialDark).opacity(0.8))
                    .cornerRadius(20)
                    .shadow(radius: 10)
                }
                .padding()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
            .foregroundColor(Color.black)
            .padding()
        }
    }
}
