import SwiftUI

/**
    A view that displays an article.
*/

struct MoleculeDetailView: View {
    let molecule: Molecule
    
    @State private var selectedTab = 0
    @State private var isInstructionPopupVisible = true // Add this state property
    @State private var selectedOrbital = 0 // Add a state property for the selected orbital
    @State private var isMolecularOrbitalHOMO = true;
    @State private var isArView = false;
    
    // Add a timer to automatically swipe through the tabs
    let timer = Timer.publish(every: 3, on: .main, in: .common).autoconnect()
    
    var body: some View {
        ZStack {
            VStack {
                Molecule3DView(molecule: molecule, isMolecularOrbitalHOMO: $isMolecularOrbitalHOMO)
                    .edgesIgnoringSafeArea(.all)
                    .overlay(
                            Button(action: {
                                isArView = true;
                            }) {
                                HStack {
                                    Image(systemName: "arkit")
                                    Text("AR")
                                }
                                    .font(.system(size: 20))
                                    .foregroundColor(.white)
                                    .padding(10)
                                    .background(Color.white.opacity(0.1))
                                    .cornerRadius(10)
                            }
                            .padding(.trailing, 20)
                            , alignment: .bottomTrailing
                        )
                
                VStack {
                    Text(molecule.name)
                        .font(.largeTitle)
                        .padding()
                    
                    ZStack(alignment: .bottom) {
                        TabView(selection: $selectedTab) {
                            VStack(alignment: .center, spacing: 20) {
                                Text("Description")
                                    .font(.headline)
                                Text(molecule.description)
                                    .padding(.horizontal)
                                Spacer()
                            }
                            .padding(.horizontal)
                            .tag(0)
                            
                            VStack(alignment: .center, spacing: 20) {
                                Text("Molecular Formula")
                                    .font(.headline)
                                Text(molecule.formula)
                                Spacer()
                            }
                            .padding(.horizontal)
                            .tag(1)
                            
                            VStack(alignment: .center, spacing: 20) {
                                Text("Shape")
                                    .font(.headline)
                                Text(molecule.shape)
                                Spacer()
                            }
                            .padding(.horizontal)
                            .tag(2)
                            
                            VStack(alignment: .center, spacing: 20) {
                                Text("Polarity")
                                    .font(.headline)
                                Text(molecule.polarity)
                                Spacer()
                            }
                            .padding(.horizontal)
                            .tag(3)
                            
                            VStack(alignment: .center, spacing: 20) {
                                Text("Bond Angle")
                                    .font(.headline)
                                Text(molecule.bondAngle)
                                Spacer()
                            }
                            .padding(.horizontal)
                            .tag(4)
                            
                            VStack(alignment: .center, spacing: 20) {
                                Text("Orbitals")
                                    .font(.headline)
                                Text(molecule.orbitals)
                                Spacer()
                            }
                            .padding(.horizontal)
                            .tag(5)
                            
                            VStack(alignment: .center, spacing: 20) {
                                Text("Hybridization")
                                    .font(.headline)
                                Text(molecule.hybridization)
                                Spacer()
                            }
                            .padding(.horizontal)
                            .tag(6)
                            
                            VStack(alignment: .center, spacing: 20) {
                                Text("Molecular Geometry")
                                    .font(.headline)
                                Text(molecule.molecularGeometry)
                                Spacer()
                            }
                            .padding(.horizontal)
                            .tag(7)
                            
                            VStack(alignment: .center, spacing: 20) {
                                Text("Bonds")
                                    .font(.headline)
                                Text(molecule.bonds)
                                Spacer()
                            }
                            .padding(.horizontal)
                            .tag(8)
                        }
                        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                        
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
                .background(Color(UIColor.darkGray).opacity(0.2))
                .cornerRadius(20)
                .shadow(radius: 10)
                .padding()
                
                HStack {
                    Picker(selection: $selectedOrbital, label: Text("Orbital")) {
                        Text("HOMO").tag(0)
                        Text("LUMO").tag(1)
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding(.horizontal)
                .onChange(of: selectedOrbital) { value in
                        if value == 0 {
                            isMolecularOrbitalHOMO = true
                        } else {
                            isMolecularOrbitalHOMO = false
                        }
                    }
            }
            .frame(width: 200)
            .padding(.bottom)
            }
        }
        .onAppear {
            // Show the instruction popup
            isInstructionPopupVisible = true
            
            // Hide the instruction popup after 2 seconds
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                isInstructionPopupVisible = false
            }
        }
        .sheet(isPresented: $isArView) {
            MoleculeARViewSheet(molecule: molecule, isArView: $isArView, isMolecularOrbitalHOMO: $isMolecularOrbitalHOMO)
        }
    }
}
