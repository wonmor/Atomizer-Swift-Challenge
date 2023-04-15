import SwiftUI

struct AtomDetailView: View {
    let element: Element
    @State private var isLoaded = false
    
    var body: some View {
        VStack {
            Text(element.symbol)
                .font(.system(size: 96, weight: .bold))
                .foregroundColor(Color(AtomView.hexStringToUIColor(hex: element.color)))
            Text(String(format: "%.2f", element.atomicMass))
                .font(.title)
                .foregroundColor(Color(AtomView.hexStringToUIColor(hex: element.color)))
                .padding(.bottom)
            Text(element.description)
                .padding(.horizontal)
            
            if isLoaded {
                Atom3DView()
                    .frame(maxHeight: .infinity)
            } else {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    .scaleEffect(2.0, anchor: .center)
                    .frame(maxHeight: .infinity)
            }
            
            Spacer()
        }
        .navigationBarTitle(element.name)
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                isLoaded = true
            }
        }
    }
}
