import SwiftUI
import SceneKit
import ARKit
import GLTFSceneKit

struct GLTFARView: UIViewRepresentable {
    var gltfURL: URL

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
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
        var parent: GLTFARView
        weak var arView: ARSCNView?
        var gltfURL: URL

        init(_ parent: GLTFARView) {
            self.parent = parent
            self.gltfURL = parent.gltfURL
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

                    rootNode.scale = SCNVector3(x: 0.005, y: 0.005, z: 0.005)

                    DispatchQueue.main.async {
                        if let arView = self?.arView {
                            let position = SCNVector3(x: 0, y: 0, z: -1)
                            let camera = arView.pointOfView?.camera ?? SCNCamera()
                            let cameraNode = SCNNode()
                            cameraNode.camera = camera
                            cameraNode.position = position
                            arView.scene.rootNode.addChildNode(cameraNode)
                            arView.scene.rootNode.addChildNode(rootNode)
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
