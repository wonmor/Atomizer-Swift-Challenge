import SwiftUI
import SceneKit

/**
    A view that displays an atom.
*/

struct Atom3DView: UIViewRepresentable {
    let particleNodes: [SCNNode]
    let sphereGeometry: SCNSphere
    let sphereMaterial: SCNMaterial
    
    func makeUIView(context: Context) -> SCNView {
        let sceneView = SCNView(frame: .zero)
        sceneView.backgroundColor = UIColor.black
        sceneView.autoenablesDefaultLighting = true
        sceneView.allowsCameraControl = true
        return sceneView
    }
    
    func updateUIView(_ uiView: SCNView, context: Context) {
        let scene = SCNScene()
        uiView.scene = scene
        
        particleNodes.forEach { scene.rootNode.addChildNode($0) }
        
        let directionalLightNode = SCNNode()
        directionalLightNode.light = SCNLight()
        directionalLightNode.light?.type = .directional
        directionalLightNode.light?.color = UIColor.white
        directionalLightNode.light?.intensity = 100
        directionalLightNode.eulerAngles = SCNVector3(-Float.pi / 4, Float.pi / 4, 0)
        scene.rootNode.addChildNode(directionalLightNode)
        
        let ambientLightNode = SCNNode()
        ambientLightNode.light = SCNLight()
        ambientLightNode.light?.type = .ambient
        ambientLightNode.light?.color = UIColor.white
        ambientLightNode.light?.intensity = 100
        scene.rootNode.addChildNode(ambientLightNode)
        
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        cameraNode.camera?.fieldOfView = 60
        cameraNode.position = SCNVector3(x: 0, y: 0, z: 3)
        scene.rootNode.addChildNode(cameraNode)
    }
}
