//
//  SwiftUIView.swift
//  
//
//  Created by John Seong on 2023-04-14.
//

import SwiftUI
import SceneKit
import GLTFSceneKit

struct Molecule3DView: UIViewRepresentable {
    typealias UIViewType = SCNView
    
    @State private var isLoading = true
    @State private var error: Error?
    @State private var angle: Float = 0
    
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
        
        return sceneView
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    // Add a method to update the angle state variable
    func rotateModel() {
        angle += .pi / 4
    }
    
    func updateUIView(_ uiView: SCNView, context: Context) {
        if isLoading {
            // Start loading the GLTF file if it hasn't been loaded yet
            let url = URL(string: "https://electronvisual.org/api/downloadGLB/C2H4_HOMO_GLTF")!
            let urlSession = URLSession(configuration: .default)
            let task = urlSession.dataTask(with: url) { data, _, error in
                if let error
                    = error {
                    DispatchQueue.main.async {
                        self.error = error
                        isLoading = false
                        // Stop the spinner
                        uiView.subviews.first(where: { $0 is UIActivityIndicatorView })?.removeFromSuperview()
                    }
                    return
                }
                
                guard let data = data else {
                    DispatchQueue.main.async {
                        self.error = NSError(domain: "MoleculeDetailView", code: 0, userInfo: [NSLocalizedDescriptionKey: "No data was received"])
                        isLoading = false
                        // Stop the spinner
                        uiView.subviews.first(where: { $0 is UIActivityIndicatorView })?.removeFromSuperview()
                    }
                    return
                }
                
                do {
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
                    
                    // Scale down the root node
                    rootNode.scale = SCNVector3(x: 0.3, y: 0.3, z: 0.3)
                    
                    DispatchQueue.main.async {
                        uiView.scene = scene
                        isLoading = false
                        // Stop the spinner
                        uiView.subviews.first(where: { $0 is UIActivityIndicatorView })?.removeFromSuperview()
                    }
                    
                } catch {
                    DispatchQueue.main.async {
                        self.error = error
                        isLoading = false
                        // Stop the spinner
                        uiView.subviews.first(where: { $0 is UIActivityIndicatorView })?.removeFromSuperview()
                    }
                }
            }
            
            task.resume()
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
    
    // Add a preview for the Molecule3DView
    struct Molecule3DView_Previews: PreviewProvider {
        static var previews: some View {
            Molecule3DView()
        }
    }
}


