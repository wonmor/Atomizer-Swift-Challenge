import UIKit
import RealityKit
import Combine

class Atom3DViewController: UIViewController {
    
    var sceneEventsUpdateSubscription: Cancellable!
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        let arView = ARView(frame: view.frame,
                             cameraMode: .nonAR,
                             automaticallyConfigureSession: false)
        view.addSubview(arView)
                
        var sphereMaterial = SimpleMaterial()
        sphereMaterial.metallic = MaterialScalarParameter(floatLiteral: 1)
        sphereMaterial.roughness = MaterialScalarParameter(floatLiteral: 0)
                
        let particleRadius: Float = 0.05
                
        guard let url = URL(string: "https://electronvisual.org/api/loadSPH/H") else {
            fatalError("Invalid URL")
        }
            
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            do {
                guard let data = data, error == nil else {
                    throw error ?? URLError(.unknown)
                }
                
                let jsonObject = try JSONSerialization.jsonObject(with: data, options: [])
                
                if let object = jsonObject as? Dictionary<String, AnyObject> {
                    let xArray = object["x_coords"] as! [NSNumber]
                    let yArray = object["y_coords"] as! [NSNumber]
                    let zArray = object["z_coords"] as! [NSNumber]
                            
                    print(xArray)
                            
                    let particleSphereAnchors = (0..<xArray.count).map { index in
                        let particlePosition = SIMD3<Float>(xArray[index].floatValue, yArray[index].floatValue, zArray[index].floatValue)
                                
                        let particleSphereEntity = ModelEntity(mesh: .generateSphere(radius: particleRadius), materials: [sphereMaterial])
                        let particleSphereAnchor = AnchorEntity(world: particlePosition)
                        particleSphereAnchor.addChild(particleSphereEntity)
                                
                        return particleSphereAnchor
                    }
                            
                    let particleAnchorsParent = AnchorEntity(world: .zero)
                    particleSphereAnchors.forEach { particleAnchorsParent.addChild($0) }
                    arView.scene.anchors.append(particleAnchorsParent)
                            
                } else {
                    print("JSON is invalid")
                }
            } catch {
                print("Error loading JSON: \(error.localizedDescription)")
            }
        }

        task.resume()
        
        let camera = PerspectiveCamera()
        camera.camera.fieldOfViewInDegrees = 60
        
        let cameraAnchor = AnchorEntity(world: .zero)
        cameraAnchor.position = [0, 0, 3]
        cameraAnchor.addChild(camera)
        
        arView.scene.addAnchor(cameraAnchor)

        let cameraDistance: Float = 3
        var currentCameraRotation: Float = 0
        let cameraRotationSpeed: Float = 0.01

        self.sceneEventsUpdateSubscription = arView.scene.subscribe(to: SceneEvents.Update.self) { _ in
            let x = sin(currentCameraRotation) * cameraDistance
            let z = cos(currentCameraRotation) * cameraDistance
            
            let cameraTranslation = SIMD3<Float>(x, 0, z)
            let cameraTransform = Transform(scale: .one,
                                            rotation: simd_quatf(),
                                            translation: cameraTranslation)
            
            camera.transform = cameraTransform
            camera.look(at: .zero, from: cameraTranslation, relativeTo: nil)

            currentCameraRotation += cameraRotationSpeed
        }
    }
}
