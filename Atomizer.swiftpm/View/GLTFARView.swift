import SwiftUI
import SceneKit
import ARKit
import ModelIO
import SceneKit.ModelIO
import MetalKit

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
        // No-op
    }

    class Coordinator: NSObject, ARSCNViewDelegate, ARSessionDelegate {
        var parent: GLTFARView
        weak var arView: ARSCNView?

        init(_ parent: GLTFARView) {
            self.parent = parent
            super.init()
            self.loadModel(from: parent.gltfURL)
        }

        func loadModel(from url: URL) {
            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                if let data = data {
                    do {
                        // Save the file with the .gltf extension
                        let fileURL = FileManager.default.temporaryDirectory.appendingPathComponent("model.gltf")
                        try data.write(to: fileURL)

                        guard let device = MTLCreateSystemDefaultDevice() else {
                                print("Failed to create Metal device")
                                return
                            }

                            let bufferAllocator = MTKMeshBufferAllocator(device: device)

                          let vertexDescriptor = MDLVertexDescriptor()
                          vertexDescriptor.attributes[0] = MDLVertexAttribute(name: MDLVertexAttributePosition, format: .float3, offset: 0, bufferIndex: 0)
                          vertexDescriptor.layouts[0] = MDLVertexBufferLayout(stride: 12)

                          let asset = MDLAsset(url: url, vertexDescriptor: vertexDescriptor, bufferAllocator: bufferAllocator)

                        
                        let scene = SCNScene(mdlAsset: asset)
                        DispatchQueue.main.async {
                            self.addNode(scene: scene)
                        }
                    } catch {
                        print("Failed to load the GLTF model:", error)
                    }
                }
            }
            task.resume()
        }


        func addNode(scene: SCNScene) {
            if let node = scene.rootNode.childNodes.first, let arView = arView {
                node.position = SCNVector3(0, 0, -1)
                arView.scene.rootNode.addChildNode(node)
            }
        }
    }
}
