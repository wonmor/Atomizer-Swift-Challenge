import SwiftUI
import SceneKit
import GLTFSceneKit

struct MoleculeDetailView: UIViewRepresentable {
    typealias UIViewType = SCNView
    
    let molecule: Molecule
    
    @State private var isLoading = true
    @State private var error: Error?
    
    func makeUIView(context: Context) -> SCNView {
            let sceneView = SCNView()
            sceneView.backgroundColor = UIColor.black
            sceneView.allowsCameraControl = true
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

            return sceneView
        }


    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func updateUIView(_ uiView: SCNView, context: Context) {
        if isLoading {
            // Start loading the GLTF file if it hasn't been loaded yet
            let url = URL(string: "https://electronvisual.org/api/downloadGLB/C2H4_HOMO_GLTF")!
            let urlSession = URLSession(configuration: .default)
            let task = urlSession.dataTask(with: url) { data, _, error in
                if let error = error {
                    DispatchQueue.main.async {
                        self.error = error
                        isLoading = false
                    }
                    return
                }
                
                guard let data = data else {
                    DispatchQueue.main.async {
                        self.error = NSError(domain: "MoleculeDetailView", code: 0, userInfo: [NSLocalizedDescriptionKey: "No data was received"])
                        isLoading = false
                    }
                    return
                }
                
                do {
                    let sceneSource = try GLTFSceneSource(data: data, options: nil)
                    let scene = try sceneSource.scene()
                    let rootNode = scene.rootNode
                    
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

                    // Scale down the root node
                    rootNode.scale = SCNVector3(x: 0.3, y: 0.3, z: 0.3)

                    DispatchQueue.main.async {
                        uiView.scene = scene
                        isLoading = false
                    }

                } catch {
                    DispatchQueue.main.async {
                        self.error = error
                        isLoading = false
                    }
                }
            }
            
            task.resume()
        }
    }


    
    class Coordinator: NSObject, SCNSceneRendererDelegate {
        var parent: MoleculeDetailView
        
        init(_ parent: MoleculeDetailView) {
            self.parent = parent
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
    }
}
