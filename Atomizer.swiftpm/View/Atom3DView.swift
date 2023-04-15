import SwiftUI

struct Atom3DView: UIViewControllerRepresentable {
    
    typealias UIViewControllerType = Atom3DViewController
    
    func makeUIViewController(context: Context) -> Atom3DViewController {
        return Atom3DViewController()
    }
    
    func updateUIViewController(_ uiViewController: Atom3DViewController, context: Context) {
        // Optional: Add any update logic here
    }
    
}
