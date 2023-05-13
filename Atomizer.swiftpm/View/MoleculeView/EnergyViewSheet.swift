import SwiftUI
import Kingfisher

/**
    A view that displays an article.
*/

struct EnergyViewSheet: View {
    let molecule: Molecule
    @Binding var isEnergyView: Bool
    
    @State private var showMessage = true
    @State private var fingerOffset: CGFloat = 0
    
    let localizationManager = LocalizationManager.shared
    
    var body: some View {
        VStack {
            KFImage(URL(string: "https://electronvisual.org/api/downloadPNG/ethene_energy_diagram"))
                .resizable()
                .aspectRatio(contentMode: .fit)
                .padding()
            
            Text(localizationManager.localizedString(for: "energy-level-diagram"))
                .font(.largeTitle)
                .padding()
            
            Button(action: {
                isEnergyView = false
            }) {
                HStack {
                    Image(systemName: "x.circle.fill")
                        .font(.system(size: 24))
                        .foregroundColor(.white)
                        .padding(16)
                    Text("Close")
                        .foregroundColor(.white)
                        .font(.headline)
                        .padding(.trailing, 16)
                        .padding(.vertical, 8)
                }
                .background(BlurView(style: .systemMaterialDark).opacity(0.8))
                .cornerRadius(20)
                .padding(20)
                .shadow(radius: 10)
                .onTapGesture {
                    withAnimation(Animation.easeInOut(duration: 0.5)) {
                        isEnergyView = false
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
            .padding()
            
        }
    }
}
