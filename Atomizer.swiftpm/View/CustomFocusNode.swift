import SceneKit
import ARKit

class CustomFocusNode: SCNNode {

    override init() {
        super.init()
        setupFocusNode()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupFocusNode() {
        let geometry = SCNSphere(radius: 0.1)
        geometry.firstMaterial?.diffuse.contents = UIColor.yellow
        geometry.firstMaterial?.specular.contents = UIColor.white
        
        let sphereNode = SCNNode(geometry: geometry)
        sphereNode.opacity = 0.3
        sphereNode.runAction(SCNAction.repeatForever(SCNAction.rotateBy(x: 0, y: 2 * .pi, z: 0, duration: 2)))
        
        let torusGeometry = SCNTorus(ringRadius: 0.15, pipeRadius: 0.005)
        torusGeometry.firstMaterial?.diffuse.contents = UIColor.yellow
        torusGeometry.firstMaterial?.specular.contents = UIColor.white
        
        let torusNode = SCNNode(geometry: torusGeometry)
        torusNode.opacity = 0.5
        torusNode.runAction(SCNAction.repeatForever(SCNAction.rotateBy(x: 2 * .pi, y: 0, z: 0, duration: 2)))
        
        self.addChildNode(sphereNode)
        self.addChildNode(torusNode)
    }


    func updateAlignment(_ alignment: ARPlaneAnchor.Alignment) {
        if alignment == .horizontal {
            self.isHidden = false
        } else {
            self.isHidden = true
        }
    }
}
 
