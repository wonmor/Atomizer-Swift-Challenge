import SwiftUI
import SceneKit

/**
    A view that displays an atom.
 
    ATOMIZER
    Developed and Designed by John Seong.
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
        
        let blackPlaneGeometry = SCNPlane(width: 100, height: 100)
        let blackPlaneMaterial = SCNMaterial()
        blackPlaneMaterial.diffuse.contents = UIColor.black
        blackPlaneGeometry.materials = [blackPlaneMaterial]
        
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        cameraNode.camera?.fieldOfView = 60
        scene.rootNode.addChildNode(cameraNode)
    
        // Animate camera zoom in and out
        SCNTransaction.begin()
        SCNTransaction.animationDuration = 10.0 // Total animation duration
        let timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        SCNTransaction.animationTimingFunction = timingFunction

        
        // Zoom in for first 2 seconds
        SCNTransaction.animationDuration = 2.0
        cameraNode.position = SCNVector3(x: 0, y: 0, z: 2)
        SCNTransaction.commit()
        
        // Oscillate between zoomed in and zoomed out versions
        let waitDuration = 8.0 // Total duration of each zoom level

        let zoomInPosition = SCNVector3(x: 0, y: 0, z: 1.5)
        let zoomOutPosition = SCNVector3(x: 0, y: 0, z: 3)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 4.0) {
            let zoomInAction = SCNAction.move(to: zoomInPosition, duration: waitDuration * 0.3)
            zoomInAction.timingMode = .easeInEaseOut

            let zoomOutAction = SCNAction.move(to: zoomOutPosition, duration: waitDuration * 0.7)
            zoomOutAction.timingMode = .easeInEaseOut

            let fadeInAction = SCNAction.fadeIn(duration: waitDuration * 0.3)
            fadeInAction.timingMode = .easeInEaseOut

            let fadeOutAction = SCNAction.fadeOut(duration: waitDuration * 0.7)
            fadeOutAction.timingMode = .easeInEaseOut

            let sequence = SCNAction.sequence([fadeOutAction, zoomInAction, fadeInAction, zoomOutAction])
            let repeatAction = SCNAction.repeatForever(sequence)

            cameraNode.runAction(repeatAction, forKey: "zoom")
        }
    }
}

extension SCNVector3 {
    // Linear interpolation between two vectors
    func lerp(to: SCNVector3, progress: Float) -> SCNVector3 {
        return SCNVector3(
            x: self.x + (to.x - self.x) * progress,
            y: self.y + (to.y - self.y) * progress,
            z: self.z + (to.z - self.z) * progress
        )
    }
}
