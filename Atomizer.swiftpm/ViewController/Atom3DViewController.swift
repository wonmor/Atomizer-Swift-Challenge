import UIKit
import SceneKit
import Combine

class Atom3DViewController: UIViewController {
    
    var sceneView: SCNView!
    let sphereGeometry = SCNSphere(radius: 0.05)
    let sphereMaterial = SCNMaterial()
    let particleRadius: Float = 0.05
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sceneView = SCNView(frame: view.frame)
        sceneView.backgroundColor = UIColor.black
        sceneView.autoenablesDefaultLighting = true
        sceneView.allowsCameraControl = true
        sceneView.showsStatistics = true
        view.addSubview(sceneView)
        
        let scene = SCNScene()
        sceneView.scene = scene
        
        sphereMaterial.diffuse.contents = UIColor.white
        
        guard let url = URL(string: "https://electronvisual.org/api/loadSPH/Cu") else {
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
                        let xMean = xFloatArray.reduce(0, +) / Float(xFloatArray.count)
                        let yMean = yFloatArray.reduce(0, +) / Float(yFloatArray.count)
                        let zMean = zFloatArray.reduce(0, +) / Float(zFloatArray.count)
                        let center = SCNVector3(xMean / 10.0, yMean / 10.0, zMean / 10.0)

                        let particleSphereNodes = (0..<xFloatArray.count).map { index in
                            let particlePosition = SCNVector3(x: Float(xFloatArray[index] / 10.0) - center.x, y: Float(yFloatArray[index] / 10.0) - center.y, z: Float(zFloatArray[index]) / 10.0 - center.z)

                            
                            let particleSphereNode = SCNNode(geometry: self.sphereGeometry)
                            particleSphereNode.geometry?.materials = [self.sphereMaterial]
                            particleSphereNode.position = particlePosition
                            
                            return particleSphereNode
                        }
                        
                        particleSphereNodes.forEach { scene.rootNode.addChildNode($0) }
                        
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
