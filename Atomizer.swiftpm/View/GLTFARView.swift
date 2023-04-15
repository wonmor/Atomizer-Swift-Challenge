import SwiftUI
import SmartHitTest
import SceneKit
import ARKit
import GLTFSceneKit
import FocusNode

struct GLTFARView: UIViewRepresentable {
    let molecule: Molecule
    
    var gltfURL: URL

    func makeCoordinator() -> Coordinator {
        Coordinator(me: self, molecule: molecule)
    }

    func makeUIView(context: Context) -> ARSCNView {
        let arView = ARSCNView()
        arView.delegate = context.coordinator
        arView.session.delegate = context.coordinator
        arView.autoenablesDefaultLighting = true

        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .horizontal
        arView.session.run(configuration)

        context.coordinator.arView = arView
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.handleTap(_:)))
        arView.addGestureRecognizer(tapGestureRecognizer)

        return arView
    }

    func updateUIView(_ uiView: ARSCNView, context: Context) {
        if gltfURL != context.coordinator.gltfURL {
            context.coordinator.gltfURL = gltfURL
            context.coordinator.loadModel(from: gltfURL)
        }
    }

    class Coordinator: NSObject, ARSCNViewDelegate, ARSessionDelegate {
        let molecule: Molecule
        
        var isFocusNodeVisible = true
        var parent: GLTFARView
        weak var arView: ARSCNView?
        var gltfURL: URL
        let focusNode = CustomFocusNode()
        var modelNode: SCNNode?

        init(me: GLTFARView, molecule: Molecule) {
            self.parent = me
            self.molecule = molecule
            self.gltfURL = me.gltfURL
            super.init()
            self.loadModel(from: gltfURL)
        }

        func loadModel(from url: URL) {
            let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
                guard let data = data else {
                    print("Failed to load the GLTF model: \(error?.localizedDescription ?? "unknown error")")
                    return
                }
                do {
                    let sceneSource = try GLTFSceneSource(data: data, options: nil)
                    let scene = try sceneSource.scene()
                    let rootNode = scene.rootNode
                    
                    self?.modelNode = rootNode
                    
                    var scaleFactor = 0.005
                    
                    switch self?.molecule.formula {
                    case "C2H4":
                        scaleFactor = 0.005
                    case "H2O":
                        scaleFactor = 0.007
                    default:
                        scaleFactor = 0.005
                    }
                    
                    let floatScaleFactor = Float(scaleFactor)
                    rootNode.scale = SCNVector3(x: floatScaleFactor, y: floatScaleFactor, z: floatScaleFactor)
                } catch {
                    print("Failed to load the GLTF model: \(error)")
                }
            }
            task.resume()
        }
        
        func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
            guard let planeAnchor = anchor as? ARPlaneAnchor else { return }
            
            if planeAnchor.alignment == .horizontal {
                DispatchQueue.main.async {
                    self.focusNode.removeFromParentNode()
                    node.addChildNode(self.focusNode)
                }
            }
        }
        
        func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
            guard let planeAnchor = anchor as? ARPlaneAnchor else { return }
            
            if planeAnchor.alignment == .horizontal {
                DispatchQueue.main.async {
                    self.focusNode.updateAlignment(planeAnchor.alignment)
                }
            }
        }

        func session(_ session: ARSession, didUpdate frame: ARFrame) {
                guard let arView = arView, isFocusNodeVisible else { return }
                let hitTestResults = frame.hitTest(arView.center, types: [.existingPlaneUsingGeometry, .estimatedHorizontalPlane])

                if let hitResult = hitTestResults.first {
                    let worldTransform = hitResult.worldTransform
                    let position = SCNVector3(x: worldTransform.columns.3.x, y: worldTransform.columns.3.y, z: worldTransform.columns.3.z)
                    focusNode.position = position

                    if focusNode.parent == nil {
                        arView.scene.rootNode.addChildNode(focusNode)
                    }
                }
            }

        func session(_ session: ARSession, cameraDidChangeTrackingState camera: ARCamera) {
            if case .normal = camera.trackingState {
                DispatchQueue.main.async {
                    self.focusNode.isHidden = false
                }
            } else {
                DispatchQueue.main.async {
                    self.focusNode.isHidden = true
                }
            }
        }
        
        @objc func handleTap(_ gestureRecognize: UITapGestureRecognizer) {
                guard let arView = arView, let modelNode = modelNode else { return }
                let hitTestResults = arView.hitTest(gestureRecognize.location(in: arView), types: [.existingPlaneUsingGeometry, .estimatedHorizontalPlane])
                
                if let hitResult = hitTestResults.first {
                    let worldTransform = hitResult.worldTransform
                    let position = SCNVector3(x: worldTransform.columns.3.x, y: worldTransform.columns.3.y, z: worldTransform.columns.3.z)

                    let modelClone = modelNode.clone()
                    modelClone.position = position
                    arView.scene.rootNode.addChildNode(modelClone)
                    
                    // Hide and remove the focus node after tapping
                    focusNode.removeFromParentNode()
                    isFocusNodeVisible = false
                }
            }
    }
}
