import SwiftUI
import Kingfisher

struct EnergyViewSheet: View {
    let molecule: Molecule
    
    @Binding var isEnergyView: Bool
    
    @State private var showMessage = true
    @State private var fingerOffset: CGFloat = 0
    @State private var moleculeName = "ethene"
    @State private var description = ""
    
    var body: some View {
        ZStack {
            Color(.white)
                .edgesIgnoringSafeArea(.all)
                .onAppear {
                    do {
                        let localizationManager = LocalizationManager.shared
                        let jsonURL = Bundle.main.url(forResource: "molecules", withExtension: "json")!
                        let jsonData = try! Data(contentsOf: jsonURL)
                        let decoder = JSONDecoder()
                        
                        let data = try Data(contentsOf: jsonURL)
                        let molecules = try JSONDecoder().decode([Molecule].self, from: data)
                        
                        for item in molecules {
                            if item.formula == self.molecule.formula {
                                self.moleculeName = item.name
                            }
                        }
                        
                        description = localizationManager.getCurrentLocale().starts(with: "ko") ? "이 다이어그램은 \(molecule.name.lowercased())의 에너지 수준을 보여줍니다. 다이어그램의 각 단계는 에너지 상태의 변화를 나타냅니다." : "This diagram depicts the energy levels of \(molecule.name.lowercased()). Each step in the diagram represents a change in energy state."
                        
                    } catch {}
                }
            
            VStack(alignment: .center) {
                HSLColorBarLegend()
                    .padding()
                
                KFImage(URL(string: "https://electronvisual.org/api/downloadPNG/\(moleculeName.lowercased().trimmingCharacters(in: .whitespacesAndNewlines).replacingOccurrences(of: " ", with: "_"))_energy_diagram"))
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .padding()
                
                Text(localizationManager.localizedString(for: "energy-level-diagram"))
                    .font(.largeTitle)
                    .padding()
                    .multilineTextAlignment(.center)
                
                Text(description)
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
                            .foregroundColor(.black)
                        Text(localizationManager.localizedString(for: "close"))
                            .foregroundColor(.black)
                            .font(.headline)
                    }
                    .padding(16)
                    .background(BlurView(style: .systemMaterialLight).opacity(0.8))
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
