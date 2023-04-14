import SwiftUI
import SceneKit
import ARKit
import GLTFSceneKit

struct Molecule3DView: UIViewRepresentable {
    typealias UIViewType = ARSCNView
    
    @Binding var isMolecularOrbitalHOMO: Bool
    @Binding var isArView: Bool
    
    func makeUIView(context: Context) -> ARSCNView {
        let sceneView = ARSCNView(frame: .zero)
        sceneView.delegate = context.coordinator
        
        // Create a new scene
        let scene = SCNScene()
        
        // Create an ambient light
        let ambientLightNode = SCNNode()
        ambientLightNode.light = SCNLight()
        ambientLightNode.light?.type = .ambient
        ambientLightNode.light?.color = UIColor(white: 0.5, alpha: 1.0)
        scene.rootNode.addChildNode(ambientLightNode)
        
        // Create a new node to hold the omni light
        let lightNode = SCNNode()
        lightNode.light = SCNLight()
        lightNode.light?.type = .omni // Set the light type to Omni (point light)
        lightNode.position = SCNVector3(x: 0, y: 0, z: 10) // Set the position of the light
        scene.rootNode.addChildNode(lightNode) // Add the light node to the scene
        
        // Create a directional light
        let directionalLightNode = SCNNode()
        directionalLightNode.light = SCNLight()
        directionalLightNode.light?.type = .directional
        directionalLightNode.light?.color = UIColor(white: 0.8, alpha: 1.0)
        directionalLightNode.eulerAngles = SCNVector3(x: -.pi / 3, y: .pi / 4, z: 0)
        scene.rootNode.addChildNode(directionalLightNode)
        
        sceneView.scene = scene
        
        // Add long press gesture recognizer to handle touch events
        let longPressGesture = UILongPressGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.handleLongPress(_:)))
        longPressGesture.minimumPressDuration = 0.3
        sceneView.addGestureRecognizer(longPressGesture)
        
        // Set up AR session configuration if isArView is true
        if isArView {
            let configuration = ARWorldTrackingConfiguration()
            configuration.planeDetection = [.horizontal, .vertical]
            sceneView.session.run(configuration)
        }
        
        return sceneView
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func updateUIView(_ uiView: ARSCNView, context: Context) {
        guard isArView else { return }
        // Load the GLTF file if it hasn't been loaded yet
        let moleculeName = isMolecularOrbitalHOMO ? "HOMO" : "LUMO"
        let url = URL(string: "https://electronvisual.org/api/downloadGLB/C2H4_\(moleculeName)_GLTF")!
        let urlSession = URLSession(configuration: .default)
        let task = urlSession.dataTask(with: url) { data, _, error in
            guard let data = data else {
                DispatchQueue.main.async {
                    context.coordinator.isLoading = false
                    context.coordinator.error = error
                }
                return
            }
            
            do {
                let sceneSource = try GLTFSceneSource(data: data, options: nil)
                let scene = try sceneSource.scene()
                let rootNode = scene.rootNode
                
                // Add a rotation action to the root node
                let rotateAction = SCNAction.repeatForever(SCNAction.rotateBy(x: 0, y: .pi, z: 0, duration: 10))
                let rotationKey = "rotationKey"
                rootNode.removeAction(forKey: rotationKey) // remove existing action, if any
                rootNode.runAction(rotateAction, forKey: rotationKey)
                
                // Scale down the root node
                rootNode.scale = SCNVector3(x: 0.3, y: 0.3, z: 0.3)
                
                // Apply material to the nodes of the scene
                func applyMaterial(to node: SCNNode) {
                    if let geometry = node.geometry {
                        if let material = geometry.firstMaterial {
                            material.lightingModel = .constant
                            material.isDoubleSided = true
                            geometry.materials = [material]
                        }
                    }
                    for childNode in node.childNodes {
                        applyMaterial(to: childNode)
                    }
                }
                
                applyMaterial(to: rootNode)
                
                DispatchQueue.main.async {
                    uiView.scene = scene
                    context.coordinator.isLoading = false
                }
                
            } catch {
                DispatchQueue.main.async {
                    context.coordinator.isLoading = false
                    context.coordinator.error = error
                }
            }
        }
        
        if context.coordinator.isLoading {
            task.resume()
        }
    }
    
    class Coordinator: NSObject, ARSCNViewDelegate {
        var parent: Molecule3DView
        var isLoading = true
        var error: Error?
        
        init(_ parent: Molecule3DView) {
            self.parent = parent
        }
        
        // Handle long press events
        @objc func handleLongPress(_ gestureRecognizer: UILongPressGestureRecognizer) {
            guard parent.isArView else { return }
            let sceneView = gestureRecognizer.view as! ARSCNView
            let rootNode = sceneView.scene.rootNode
            let rotationKey = "rotationKey"
            
            if gestureRecognizer.state == .began {
                rootNode.removeAction(forKey: rotationKey)
            } else if gestureRecognizer.state == .ended {
                let rotateAction = SCNAction.repeatForever(SCNAction.rotateBy(x: 0, y: .pi, z: 0, duration: 10))
                rootNode.runAction(rotateAction, forKey: rotationKey)
            }
        }
        
        func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
            if let camera = renderer.pointOfView?.camera {
                camera.usesOrthographicProjection = true
                camera.wantsDepthOfField = false
                camera.wantsHDR = false
                camera.zNear = 0.1
                camera.zFar = 1000
                camera.fieldOfView = 60
            }
        }
        
        // Add ARKit delegate methods
        func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
            if anchor is ARPlaneAnchor {
                // Create a plane node for the detected plane and add it to the scene
                let plane = SCNPlane(width: 1, height: 1)
                plane.firstMaterial?.diffuse.contents = UIColor.red.withAlphaComponent(0.5)
                let planeNode = SCNNode(geometry: plane)
                planeNode.eulerAngles.x = -.pi / 2
                node.addChildNode(planeNode)
            }
        }
        
        func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
            if anchor is ARPlaneAnchor {
                // Update the size of the plane node to match the detected plane
                if let planeNode = node.childNodes.first, let plane
                    = anchor as? ARPlaneAnchor {
                    planeNode.geometry = SCNPlane(width: CGFloat(plane.extent.x), height: CGFloat(plane.extent.z))
                    planeNode.position = SCNVector3(plane.center.x, 0, plane.center.z)
                }
            }
        }
    }
    
    struct Molecule3DView_Previews: PreviewProvider {
        static var previews: some View {
            Molecule3DView(isMolecularOrbitalHOMO: .constant(true), isArView: .constant(false))
        }
    }
}
