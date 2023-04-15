import SwiftUI
import SmartHitTest
import SceneKit
import ARKit
import GLTFSceneKit
import FocusNode

struct GLTFARView: UIViewRepresentable {
    let molecule: Molecule
    let focusNode = FocusSquare()
    
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
        
        var parent: GLTFARView
        weak var arView: ARSCNView?
        var gltfURL: URL
        let focusNode = FocusSquare()

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

                    DispatchQueue.main.async {
                        if let arView = self?.arView {
                            let position = SCNVector3(x: 0, y: 0, z: -1)
                            let camera = arView.pointOfView?.camera ?? SCNCamera()
                            let cameraNode = SCNNode()
                            cameraNode.camera = camera
                            cameraNode.position = position
                            arView.scene.rootNode.addChildNode(cameraNode)
                            arView.scene.rootNode.addChildNode(rootNode)
                            arView.scene.rootNode.addChildNode(self?.focusNode ?? FocusSquare())
                        }
                    }
                } catch {
                    print("Failed to load the GLTF model: \(error)")
                }
            }
            task.resume()
        }
    }
}
