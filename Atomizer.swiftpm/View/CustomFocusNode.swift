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
        let geometry = SCNBox(width: 0.15, height: 0.001, length: 0.15, chamferRadius: 0)
        geometry.firstMaterial?.diffuse.contents = UIColor.yellow
        let focusNode = SCNNode(geometry: geometry)
        focusNode.opacity = 0.5
        self.addChildNode(focusNode)
    }

    func updateAlignment(_ alignment: ARPlaneAnchor.Alignment) {
        if alignment == .horizontal {
            self.isHidden = false
        } else {
            self.isHidden = true
        }
    }
}
 
