import SwiftUI

struct InstructionPopupView: View {
    var body: some View {
            ZStack {
                VStack {
                    VStack {
                        Text("What are HOMO and LUMO?")
                            .padding()
                            .font(.title)
                        Text("HOMO stands for Highest Occupied Molecular Orbital and LUMO stands for Lowest Unoccupied Molecular Orbital. Think of HOMO as the top floor of a building and LUMO as the basement. HOMO is where the electrons hang out the most and LUMO is where they like to go when they're excited. Electrons are tiny particles that make up everything around us!")
                            .padding(.horizontal)
                            .font(.body)
                            .foregroundColor(.white)
                        
                        VStack {
                            HStack {
                                AsyncImage(url: URL(string: "https://www.chem.ucalgary.ca/courses/351/Carey5th/Ch10/ethene2mos.jpg")) { image in
                                    image.resizable()
                                } placeholder: {
                                    ProgressView()
                                }
                                .frame(width: 200, height: 200)
                                
                                AsyncImage(url: URL(string: "https://www.chem.ucalgary.ca/courses/353/Carey5th/Ch10/pimo01.jpg")) { image in
                                    image.resizable()
                                } placeholder: {
                                    ProgressView()
                                }
                                .frame(width: 200, height: 200)
                            }
                            Text("Image Source: UCalgary").foregroundColor(.white).font(.caption)
                        }
                        .padding()
                        
                        Text("When atoms come together to form molecules, their electrons are located in orbitals, which are like little clouds that surround the atoms. There are two types of orbitals involved in bonding: bonding orbitals and antibonding orbitals.")
                            .padding()
                            .font(.body)
                            .foregroundColor(.white)
                        
                        Text("Bonding orbitals are like friendly hugs between atoms. When two atoms come close enough together, their orbitals can overlap in a way that allows their electrons to share the same space. This sharing of electrons creates a bond between the atoms, which corresponds to the HOMO. In contrast, antibonding orbitals are like two people pushing against each other. When two atoms come too close together, their orbitals can overlap in a way that causes their electrons to repel each other, preventing the formation of a bond. This corresponds to the LUMO.")
                            .padding()
                            .font(.body)
                            .foregroundColor(.white)
                        
                        Text("In summary, bonding orbitals allow for the formation of chemical bonds, which correspond to the HOMO. Antibonding orbitals prevent bonding, which correspond to the LUMO. Electrons can move from bonding orbitals to antibonding orbitals, which can weaken or break chemical bonds.")
                            .padding()
                            .font(.body)
                            .foregroundColor(.white)
                        
                    }
                    .padding()
                    .background(Color(red: 0.1, green: 0.1, blue: 0.1))
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color.white.opacity(0.1), lineWidth: 1)
                    )
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .edgesIgnoringSafeArea(.all)
            }
            .animation(.easeInOut(duration: 0.5)) // Apply the animation to the ZStack
        }
    }
    

