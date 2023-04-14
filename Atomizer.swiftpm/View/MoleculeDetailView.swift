import SwiftUI

struct MoleculeDetailView: View {
    let molecule: Molecule
    
    @State private var selectedTab = 0
    @State private var isInstructionPopupVisible = true // Add this state property
    
    // Add a timer to automatically swipe through the tabs
    let timer = Timer.publish(every: 3, on: .main, in: .common).autoconnect()
    
    var body: some View {
        ZStack {
            VStack {
                Molecule3DView()
                    .edgesIgnoringSafeArea(.all)
                
                Text(molecule.name)
                    .font(.largeTitle)
                    .bold()
                    .padding()
                
                ZStack(alignment: .bottom) {
                    TabView(selection: $selectedTab) {
                        VStack(alignment: .leading, spacing: 20) {
                            Text("Description")
                                .font(.headline)
                            Text(molecule.description)
                            Spacer()
                        }
                        .padding()
                        .tag(0)
                        
                        VStack(alignment: .leading, spacing: 20) {
                            Text("Molecular Formula")
                                .font(.headline)
                            Text(molecule.formula)
                            Spacer()
                        }
                        .padding()
                        .tag(1)
                        
                        VStack(alignment: .leading, spacing: 20) {
                            Text("Shape")
                                .font(.headline)
                            Text(molecule.shape)
                            Spacer()
                        }
                        .padding()
                        .tag(2)
                        
                        VStack(alignment: .leading, spacing: 20) {
                            Text("Polarity")
                                .font(.headline)
                            Text(molecule.polarity)
                            Spacer()
                        }
                        .padding()
                        .tag(3)
                        
                        VStack(alignment: .leading, spacing: 20) {
                            Text("Bond Angle")
                                .font(.headline)
                            Text(molecule.bondAngle)
                            Spacer()
                        }
                        .padding()
                        .tag(4)
                        
                        VStack(alignment: .leading, spacing: 20) {
                            Text("Orbitals")
                                .font(.headline)
                            Text(molecule.orbitals)
                            Spacer()
                        }
                        .padding()
                        .tag(5)
                        
                        VStack(alignment: .leading, spacing: 20) {
                            Text("Hybridization")
                                .font(.headline)
                            Text(molecule.hybridization)
                            Spacer()
                        }
                        .padding()
                        .tag(6)
                        
                        VStack(alignment: .leading, spacing: 20) {
                            Text("Molecular Geometry")
                                .font(.headline)
                            Text(molecule.molecularGeometry)
                            Spacer()
                        }
                        .padding()
                        .tag(7)
                        
                        VStack(alignment: .leading, spacing: 20) {
                            Text("Bonds")
                                .font(.headline)
                            Text(molecule.bonds)
                            Spacer()
                        }
                        .padding()
                        .tag(8)
                    }
                    .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                    .padding(.horizontal)
                    
                    HStack(spacing: 0) {
                        ForEach(0..<9) { i in
                            Rectangle()
                                .fill(i == selectedTab ? Color.white : Color.gray)
                                .frame(width: 30, height: 5)
                                .cornerRadius(3)
                                .padding(.vertical, 8)
                                .animation(.easeInOut, value: selectedTab)
                                .onTapGesture {
                                    selectedTab = i
                                }
                        }
                    }
                    .padding(.bottom)
                    .opacity(0.3)
                    // Use the timer to automatically swipe through the tabs
                    .onReceive(timer) { _ in
                        withAnimation {
                            selectedTab = (selectedTab + 1) % 9
                        }
                    }
                }
                .padding(.bottom)
            }
            if isInstructionPopupVisible {
                InstructionPopupView(isVisible: $isInstructionPopupVisible)
            }
        }
        .onAppear {
            // Hide the instruction popup after 3 seconds
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                withAnimation {
                    isInstructionPopupVisible = false
                }
            }
        }
    }
}
