import SwiftUI

struct Atom3DView: UIViewControllerRepresentable {
    let element: Element
    
    typealias UIViewControllerType = Atom3DViewController
    
    func makeUIViewController(context: Context) -> Atom3DViewController {
        return Atom3DViewController(element: element)
    }
    
    func updateUIViewController(_ uiViewController: Atom3DViewController, context: Context) {
        // Optional: Add any update logic here
    }
    
}
