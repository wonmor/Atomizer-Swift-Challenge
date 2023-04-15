import SwiftUI
import SmartHitTest
import SceneKit
import ARKit
import GLTFSceneKit
import Vision
import Dispatch

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
        if #available(iOS 13.0, *), ARWorldTrackingConfiguration.supportsSceneReconstruction(.meshWithClassification) {
            configuration.sceneReconstruction = .meshWithClassification
        }
        arView.session.run(configuration)

        context.coordinator.arView = arView
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.handleTap(_:)))
            arView.addGestureRecognizer(tapGestureRecognizer)

        let longPressGestureRecognizer = UILongPressGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.handleLongPress(_:)))
        arView.addGestureRecognizer(longPressGestureRecognizer)

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
        
        private var handObservation: VNHumanHandPoseObservation?
        private let handPoseRequest = VNDetectHumanHandPoseRequest()
        private let processingQueue = DispatchQueue(label: "com.johnseong.handpose.processing", qos: .userInitiated)

        var isFocusNodeVisible = true
        var attachedModelNode: SCNNode?
        var parent: GLTFARView
        weak var arView: ARSCNView?
        var gltfURL: URL
        let focusNode = CustomFocusNode()
        var modelNode: SCNNode?
        var initialObjectPosition: SCNVector3?
        var objectPlacedOnGround = false

        init(me: GLTFARView, molecule: Molecule) {
            self.parent = me
            self.molecule = molecule
            self.gltfURL = me.gltfURL
            super.init()
            self.loadModel(from: gltfURL)
        }
        
        func handleHandPose(_ observation: VNHumanHandPoseObservation) {
            guard let arView = arView, let modelNode = modelNode else { return }

            guard let wristPoint = try? observation.recognizedPoint(.wrist) else {
                if let initialPosition = initialObjectPosition, let attachedModelNode = attachedModelNode {
                    attachedModelNode.position = initialPosition
                    objectPlacedOnGround = true
                }
                attachedModelNode = nil
                return
            }

            let wristLocation = CGPoint(x: CGFloat(wristPoint.location.x), y: CGFloat(wristPoint.location.y))

            let hitTestResults = arView.hitTest(wristLocation, types: [.featurePoint])

            if let hitResult = hitTestResults.first {
                let worldTransform = hitResult.worldTransform
                let position = SCNVector3(x: worldTransform.columns.3.x, y: worldTransform.columns.3.y, z: worldTransform.columns.3.z)

                if attachedModelNode == nil {
                    if objectPlacedOnGround {
                        if let modelClone = arView.scene.rootNode.childNode(withName: "modelNode", recursively: true) {
                            initialObjectPosition = modelClone.position
                            attachedModelNode = modelClone
                            objectPlacedOnGround = false
                        }
                    } else {
                        let modelClone = modelNode.clone()
                        modelClone.position = position
                        arView.scene.rootNode.addChildNode(modelClone)
                        attachedModelNode = modelClone
                    }
                } else {
                    // Smoothly animate the object towards the hand position
                    let moveAction = SCNAction.move(to: position, duration: 0.2)
                    moveAction.timingMode = .easeInEaseOut
                    attachedModelNode?.runAction(moveAction)
                }
            }
        }



        
        @objc func handleLongPress(_ gestureRecognize: UILongPressGestureRecognizer) {
            if gestureRecognize.state == .began {
                attachedModelNode = nil
            }
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
                    
                    var scaleFactor = 0.03
                    
                    switch self?.molecule.formula {
                    case "C2H4":
                        scaleFactor = 0.03
                    case "H2O":
                        scaleFactor = 0.05
                    default:
                        scaleFactor = 0.03
                    }
                    
                    let floatScaleFactor = Float(scaleFactor)
                    rootNode.scale = SCNVector3(x: floatScaleFactor, y: floatScaleFactor, z: floatScaleFactor)
                    
                } catch {
                    print("Failed to load the GLTF model: \(error)")
                }
            }
            task.resume()
        }
        
        // Object Occlusion in ARKit and SceneKit: https://stackoverflow.com/questions/64846510/scenekit-lidar-features-for-object-occlusion

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
            if #available(iOS 13.0, *), ARWorldTrackingConfiguration.supportsSceneReconstruction(.meshWithClassification) {
                guard let meshAnchor = anchor as? ARMeshAnchor else {
                    return
                }
                
                let geometry = createGeometryFromAnchor(meshAnchor: meshAnchor)
                
                // Optionally hide the node from rendering as well
                geometry.firstMaterial?.colorBufferWriteMask = []
                geometry.firstMaterial?.writesToDepthBuffer = true
                geometry.firstMaterial?.readsFromDepthBuffer = true
                
                
                node.geometry = geometry
            }
            
            guard let planeAnchor = anchor as? ARPlaneAnchor else { return }
            
            if planeAnchor.alignment == .horizontal {
                DispatchQueue.main.async {
                    self.focusNode.updateAlignment(planeAnchor.alignment)
                }
            }
        }
        
        // Taken from https://developer.apple.com/forums/thread/130599
        func createGeometryFromAnchor(meshAnchor: ARMeshAnchor) -> SCNGeometry {
            let meshGeometry = meshAnchor.geometry
            let vertices = meshGeometry.vertices
            let normals = meshGeometry.normals
            let faces = meshGeometry.faces
            
            // use the MTL buffer that ARKit gives us
            let vertexSource = SCNGeometrySource(buffer: vertices.buffer, vertexFormat: vertices.format, semantic: .vertex, vertexCount: vertices.count, dataOffset: vertices.offset, dataStride: vertices.stride)
            
            let normalsSource = SCNGeometrySource(buffer: normals.buffer, vertexFormat: normals.format, semantic: .normal, vertexCount: normals.count, dataOffset: normals.offset, dataStride: normals.stride)
            // Copy bytes as we may use them later
            let faceData = Data(bytes: faces.buffer.contents(), count: faces.buffer.length)
            
            // create the geometry element
            let geometryElement = SCNGeometryElement(data: faceData, primitiveType: primitiveType(type: faces.primitiveType), primitiveCount: faces.count, bytesPerIndex: faces.bytesPerIndex)
            
            return SCNGeometry(sources: [vertexSource, normalsSource], elements: [geometryElement])
        }

        func primitiveType(type: ARGeometryPrimitiveType) -> SCNGeometryPrimitiveType {
                switch type {
                    case .line: return .line
                    case .triangle: return .triangles
                default : return .triangles
                }
        }

        private var lastProcessingDate = Date()

        func session(_ session: ARSession, didUpdate frame: ARFrame) {
            guard let arView = arView, isFocusNodeVisible else { return }

            // Limit the processing rate
            let currentDate = Date()
            guard currentDate.timeIntervalSince(lastProcessingDate) >= 0.1 else { return }
            lastProcessingDate = currentDate

            processingQueue.async { [weak self] in
                guard let self = self else { return }
                let handler = VNImageRequestHandler(cvPixelBuffer: frame.capturedImage, orientation: .right)
                do {
                    try handler.perform([self.handPoseRequest])
                    if let result = self.handPoseRequest.results?.first as? VNHumanHandPoseObservation {
                        self.handObservation = result
                        DispatchQueue.main.async {
                            self.handleHandPose(result)
                        }
                    }
                } catch {
                    print("Error detecting hand pose: \(error)")
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

                // Set objectPlacedOnGround to true
                objectPlacedOnGround = true

                // Hide and remove the focus node after tapping
                focusNode.removeFromParentNode()
                isFocusNodeVisible = false
            }
        }

    }
}
