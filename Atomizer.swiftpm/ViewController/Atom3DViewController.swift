import UIKit
import SceneKit
import Combine

class Atom3DViewController: UIViewController {
    var element: Element
    var sceneView: SCNView!
    let sphereGeometry = SCNSphere(radius: 0.03)
    let sphereMaterial = SCNMaterial()
    let particleRadius: Float = 0.02
    
    init(element: Element) {
        self.element = element
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Create a scene view and set its properties
        sceneView = SCNView(frame: view.frame)
        sceneView.backgroundColor = UIColor.black
        sceneView.autoenablesDefaultLighting = true
        sceneView.allowsCameraControl = true
        sceneView.showsStatistics = true
        view.addSubview(sceneView)
        
        // Create a new scene
        let scene = SCNScene()
        sceneView.scene = scene

        // Set up the sphere material with a reflection
        sphereMaterial.lightingModel = .physicallyBased
        sphereMaterial.diffuse.contents = AtomView.hexStringToUIColor(hex: element.color)
        sphereMaterial.metalness.contents = 1.0
        sphereMaterial.roughness.contents = 0.1
        sphereMaterial.reflective.intensity = 0.5
        
        // Load the environment map texture
        if let reflectionImage = UIImage(named: "workshop.exr") {
            let reflectionProperty = SCNMaterialProperty(contents: reflectionImage)
            sphereMaterial.reflective.contents = reflectionProperty
        }

        
        // Load the particle data
        guard let url = URL(string: "https://electronvisual.org/api/loadSPH/\(element.symbol)") else {
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
                    
                    let xFloatArray = xArray.map { $0.floatValue }
                    let yFloatArray = yArray.map { $0.floatValue }
                    let zFloatArray = zArray.map { $0.floatValue }
                    
                    DispatchQueue.main.async {
                        // Calculate the center of the particle cloud
                        let xMean = xFloatArray.reduce(0, +) / Float(xFloatArray.count)
                        let yMean = yFloatArray.reduce(0, +) / Float(yFloatArray.count)
                        let zMean = zFloatArray.reduce(0, +) / Float(zFloatArray.count)
                        let center = SCNVector3(xMean / 15.0, yMean / 15.0, zMean / 15.0)
                        
                        // Create the particle nodes
                        let particleSphereNodes = (0..<xFloatArray.count).map { index in
                            let particlePosition = SCNVector3(x: Float(xFloatArray[index] / 15.0), y: Float(yFloatArray[index] / 15.0), z: Float(zFloatArray[index]) / 15.0)
                            
                            let particleSphereNode = SCNNode(geometry: self.sphereGeometry)
                            particleSphereNode.geometry?.materials = [self.sphereMaterial]
                            particleSphereNode.position = particlePosition
                            
                            // Particle constraint
                            let constraint = SCNBillboardConstraint()
                            constraint.freeAxes = .all
                            particleSphereNode.constraints = [constraint]

                            // Particle movement
                            //particleSphereNode.addParticleSystem(particleSystem)
                            
                            return particleSphereNode
                        }
                        
                        // Create a node to hold all of the particle nodes
                        let particlesNode = SCNNode()
                        particleSphereNodes.forEach { particlesNode.addChildNode($0) }
                        particlesNode.position = SCNVector3(-center.x - 0.5, -center.y + 0.5, -center.z)
                        
                        // Add the particle node to the scene
                        scene.rootNode.addChildNode(particlesNode)
                        
                        
                        let directionalLightNode = SCNNode()
                        directionalLightNode.light = SCNLight()
                        directionalLightNode.light?.type = .directional
                        directionalLightNode.light?.color = UIColor.white
                        directionalLightNode.light?.intensity = 100
                        directionalLightNode.eulerAngles = SCNVector3(-Float.pi / 4, Float.pi / 4, 0)
                        scene.rootNode.addChildNode(directionalLightNode)

                        
                        let ambientLightNode = SCNNode()
                        ambientLightNode.light = SCNLight()
                        ambientLightNode.light?.type = .ambient
                        ambientLightNode.light?.color = UIColor.white
                        ambientLightNode.light?.intensity = 100
                        scene.rootNode.addChildNode(ambientLightNode)

                        
                        // Create a camera node and add it to the scene
                        let cameraNode = SCNNode()
                        cameraNode.camera = SCNCamera()
                        cameraNode.camera?.fieldOfView = 60
                        cameraNode.position = SCNVector3(x: 0, y: 0, z: 3)
                        scene.rootNode.addChildNode(cameraNode)

                    }
                }
            } catch {
                DispatchQueue.main.async {
                    let alertController = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "OK", style: .default)
                    alertController.addAction(okAction)
                    self.present(alertController, animated: true, completion: nil)
                }
            }
        }
        
        task.resume()
    }
}
