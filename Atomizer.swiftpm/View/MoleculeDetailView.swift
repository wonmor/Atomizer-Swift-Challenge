import SwiftUI
import SceneKit
import GLTFSceneKit

struct MoleculeDetailView: UIViewRepresentable {
    typealias UIViewType = SCNView
    
    let molecule: Molecule
    
    func makeUIView(context: Context) -> SCNView {
        // Create a SceneKit view
        let sceneView = SCNView()
        sceneView.backgroundColor = UIColor.white
        
        // Load the GLTF file
        let url = URL(string: "https://electronvisual.org/api/downloadGLB/C2H4_HOMO_GLTF")!
        let gltfScene = try! GLTFSceneSource(url: url, options: nil).scene()
        
        // Add the GLTF scene to the SceneKit view
        sceneView.scene = gltfScene
        
        return sceneView
    }
    
    func updateUIView(_ uiView: SCNView, context: Context) {
        // Do nothing
    }
}
