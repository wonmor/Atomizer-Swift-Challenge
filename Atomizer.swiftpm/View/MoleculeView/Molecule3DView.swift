import SwiftUI
import SceneKit
import GLTFSceneKit

/**
    A view that displays a molecule.
*/

struct Molecule3DView: UIViewRepresentable {
    typealias UIViewType = SCNView
    
    let molecule: Molecule
    
    @State private var isLoading = true
    @State private var error: Error?
    @State private var angle: Float = 0
    @State private var lastIsMolecularOrbitalHOMO: Bool?
    
    @Binding var isMolecularOrbitalHOMO: Bool
    
    func makeUIView(context: Context) -> SCNView {
        let sceneView = SCNView()
        sceneView.backgroundColor = UIColor.black
        sceneView.allowsCameraControl = true
        sceneView.delegate = context.coordinator
        
        // Add a spinner to indicate that the model is being loaded
        let spinner = UIActivityIndicatorView(style: .medium)
        spinner.color = .white
        spinner.translatesAutoresizingMaskIntoConstraints = false
        sceneView.addSubview(spinner)
        NSLayoutConstraint.activate([
            spinner.centerXAnchor.constraint(equalTo: sceneView.centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: sceneView.centerYAnchor),
        ])
        spinner.startAnimating()
        
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
        
        // Load the GLTF scene
        loadGLTFScene(sceneView: sceneView, spinner: spinner)
        
        return sceneView
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func updateUIView(_ uiView: SCNView, context: Context) {
           if lastIsMolecularOrbitalHOMO == nil || isMolecularOrbitalHOMO != lastIsMolecularOrbitalHOMO {
               let spinner = uiView.subviews.first(where: { $0 is UIActivityIndicatorView }) as? UIActivityIndicatorView
               spinner?.startAnimating()
               loadGLTFScene(sceneView: uiView, spinner: spinner)
               lastIsMolecularOrbitalHOMO = isMolecularOrbitalHOMO
           }
       }
    
    func loadGLTFScene(sceneView: SCNView, spinner: UIActivityIndicatorView?) {
        isLoading = true
        
        // Check if the isMolecularOrbitalHOMO property has changed
        if isMolecularOrbitalHOMO != lastIsMolecularOrbitalHOMO {
            let relativePath = "\(molecule.formula)_\(isMolecularOrbitalHOMO ? "HOMO" : "LUMO")_GLTF"
            guard let url = Bundle.main.url(forResource: relativePath, withExtension: "json") else {
                DispatchQueue.main.async {
                    self.error = NSError(domain: "MoleculeDetailView", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to locate GLTF file"])
                    isLoading = false
                    spinner?.stopAnimating()
                }
                return
            }
            
            do {
                let data = try Data(contentsOf: url)
                let sceneSource = try GLTFSceneSource(data: data, options: nil)
                let scene = try sceneSource.scene()
                let rootNode = scene.rootNode
                
                rootNode.eulerAngles.y = angle
                
                // Add a rotation action to the root node to continuously rotate it
                let rotateAction = SCNAction.repeatForever(SCNAction.rotateBy(x: 0, y: .pi, z: 0, duration: 10))
                let rotationKey = "rotationKey"
                rootNode.removeAction(forKey: rotationKey) // remove existing action, if any
                rootNode.runAction(rotateAction, forKey: rotationKey)
                
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
                
                var scaleFactor = 0.3
                
                switch molecule.formula {
                case "C2H4":
                    scaleFactor = 0.3
                case "H2O":
                    scaleFactor = 0.4
                case "H2":
                    scaleFactor = 0.6
                case "Cl2":
                    scaleFactor = 0.4
                case "HCl":
                    scaleFactor = 0.4
                default:
                    scaleFactor = 0.3
                }
                
                let floatScaleFactor = Float(scaleFactor)
                
                // Scale down the root node
                rootNode.scale = SCNVector3(x: floatScaleFactor, y: floatScaleFactor, z: floatScaleFactor)
                
                DispatchQueue.main.async {
                    sceneView.scene = scene
                    isLoading = false
                    spinner?.stopAnimating()
                }
                
            } catch {
                DispatchQueue.main.async {
                    self.error = error
                    isLoading = false
                    spinner?.stopAnimating()
                }
            }
        } else {
            // If the isMolecularOrbitalHOMO property hasn't changed, simply stop the spinner
            spinner?.stopAnimating()
        }
    }

    
    class Coordinator: NSObject, SCNSceneRendererDelegate {
        var parent: Molecule3DView
        
        init(_ parent: Molecule3DView) {
            self.parent = parent
        }
        
        // Handle long press events
        @objc func handleLongPress(_ gestureRecognizer: UILongPressGestureRecognizer) {
            let sceneView = gestureRecognizer.view as! SCNView
            let rootNode = sceneView.scene!.rootNode
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
    }
}