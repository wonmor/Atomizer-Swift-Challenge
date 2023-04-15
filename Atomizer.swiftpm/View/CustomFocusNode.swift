//
//  CustomFocusMode.swift
//  Atomizer
//
//  Created by John Seong on 2023-04-15.
//

import SceneKit
import ARKit

class CustomFocusNode: SCNNode {
    var focusNode: SCNNode?

    override init() {
        super.init()
        setupFocusNode()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupFocusNode() {
        guard let url = Bundle.main.url(forResource: "FocusNode", withExtension: "scn", subdirectory: "Models.scnassets") else { return }
        guard let node = SCNReferenceNode(url: url) else { return }

        node.load()
        self.focusNode = node

        self.addChildNode(node)
    }

    func updateAlignment(_ alignment: ARPlaneAnchor.Alignment) {
        if alignment == .horizontal {
            focusNode?.isHidden = false
        } else {
            focusNode?.isHidden = true
        }
    }
}
