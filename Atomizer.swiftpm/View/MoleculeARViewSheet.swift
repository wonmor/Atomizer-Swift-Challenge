import SwiftUI

struct MoleculeARViewSheet: View {
    let molecule: Molecule
    
    @Binding var isArView: Bool
    @Binding var isMolecularOrbitalHOMO: Bool
    
    @State private var showMessage = true
    @State private var fingerOffset: CGFloat = 0
    
    var body: some View {
        ZStack(alignment: .center) {
            GLTFARView(molecule: molecule, gltfURL: URL(string: "https://electronvisual.org/api/downloadGLB/\(molecule.formula)_\(isMolecularOrbitalHOMO ? "HOMO" : "LUMO")_GLTF")!)
            
            Image(systemName: "hand.point.up.fill")
                .font(.system(size: 40))
                .foregroundColor(.white)
                .shadow(color: .black, radius: 5, x: 0, y: 0)
                .rotationEffect(.degrees(180))
                .offset(y: -UIScreen.main.bounds.height / 6 + fingerOffset)
                .opacity(showMessage ? 1 : 0)
                .modifier(PressAnimationModifier(isPressed: showMessage))
                .onAppear {
                    withAnimation(Animation.easeInOut(duration: 1.5).repeatForever()) {
                        fingerOffset = -20
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                        withAnimation(Animation.easeInOut(duration: 0.5)) {
                            showMessage = false
                        }
                    }
                }
            
            if showMessage {
                Text("Move around and tap any floor to place the molecule")
                    .font(.headline)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 20)
                    .opacity(showMessage ? 1 : 0)
                    .modifier(PressAnimationModifier(isPressed: showMessage))
                    .shadow(color: .black, radius: 5, x: 0, y: 0)
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                            withAnimation(Animation.easeInOut(duration: 0.5)) {
                                showMessage = false
                            }
                        }
                    }
            }
            
            Button(action: {
                isArView = false
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
                        isArView = false
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
            .edgesIgnoringSafeArea(.all)
        }
        .edgesIgnoringSafeArea(.all)
    }
}

struct PressAnimationModifier: ViewModifier {
    var isPressed: Bool
    
    func body(content: Content) -> some View {
       
        return content.scaleEffect(isPressed ? 0.9 : 1.0)
            .animation(Animation.easeInOut(duration: 0.3))
    }
}

struct BlurView: UIViewRepresentable {
    var style: UIBlurEffect.Style = .systemMaterial
    func makeUIView(context: UIViewRepresentableContext<BlurView>) -> UIVisualEffectView {
        return UIVisualEffectView(effect: UIBlurEffect(style: style))
    }
    
    func updateUIView(_ uiView: UIVisualEffectView, context: UIViewRepresentableContext<BlurView>) {
        uiView.effect = UIBlurEffect(style: style)
    }
}
