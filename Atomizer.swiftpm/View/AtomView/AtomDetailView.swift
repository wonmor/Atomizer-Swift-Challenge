import SwiftUI
import ActivityIndicatorView
import SceneKit

/**
    A view that displays an atom.
 
    ATOMIZER
    Developed and Designed by John Seong.
*/

struct AtomDetailView: View {
    let element: Element
    
    @State private var isLoaded = false
    @State private var particleNodes: [SCNNode] = []
    @State private var isSpinnerVisible = true
    
    let sphereGeometry = SCNSphere(radius: 0.02)
    let sphereMaterial = SCNMaterial()
    
    var body: some View {
        VStack {
            Text(element.symbol)
                .font(.system(size: 96, weight: .bold))
                .foregroundColor(Color(AtomView.hexStringToUIColor(hex: element.color)))
            Text(String(format: "%.2f", element.atomicMass))
                .font(.title)
                .foregroundColor(Color(AtomView.hexStringToUIColor(hex: element.color)))
                .padding(.bottom)
            Text(element.description)
                .padding(.horizontal)
            
            if isLoaded {
                GeometryReader { geometry in
                    ZStack {
                        Atom3DView(particleNodes: particleNodes, sphereGeometry: sphereGeometry, sphereMaterial: sphereMaterial)
                            .frame(width: geometry.size.width, height: geometry.size.height)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.clear)
                    .edgesIgnoringSafeArea(.all)
                }
            } else {
                Spacer()
                
                HStack {
                    ActivityIndicatorView(isVisible: $isSpinnerVisible, type: .arcs(count: 3, lineWidth: 2))
                        .frame(width: 100.0, height: 100.0)
                        .foregroundColor(Color(AtomView.hexStringToUIColor(hex: element.color)))
                        .onAppear {
                            fetchParticleData()
                        }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Electron Config.")
                    .font(.title3)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.horizontal)
                
                let electronConfigurationParts = element.electronConfiguration
                    .components(separatedBy: " ")
                
                HStack(spacing: 8) {
                    ForEach(electronConfigurationParts, id: \.self) { part in
                        let subshell = part
                            .replacingOccurrences(of: "[", with: "")
                            .replacingOccurrences(of: "]", with: "")
                        
                        if subshell == electronConfigurationParts.last {
                            Text(subshell)
                                .font(.title)
                                .fontWeight(.bold) // Set the font weight to bold
                                .foregroundColor(.black)
                                .padding(4)
                                .background(Color(AtomView.hexStringToUIColor(hex: element.color)))
                                .cornerRadius(8)
                            
                        } else {
                            Text(part)
                                .font(.title)
                        }
                    }
                }
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.horizontal)
                .padding(.bottom)
            }
            
            Spacer()
        }
        .navigationBarTitle(element.name)
    }
    
    func fetchParticleData() {
        /**
         Uses the ElectronVisualized API to generate the electron coordinates.
         The API was created from scratch by me, using Python and Flask.
         I used SciPy and NumPy to calculate spherical harmonics.
         Then, I sampled the wavefunction by using the Metropolis-Hastings algorithm.
         
         GitHub repo of the API that I created:
         https://github.com/wonmor/ElectronVisualized
         
         Relevant links:
         https://en.wikipedia.org/wiki/Spherical_harmonics
         https://en.wikipedia.org/wiki/Metropolis–Hastings_algorithm
         */
        
        isSpinnerVisible = true // Show the activity indicator
        
        DispatchQueue.global(qos: .userInitiated).async {
            // Perform long-running task here...
            guard let url = Bundle.main.url(forResource: "SPH_\(element.symbol)", withExtension: "json") else {
                DispatchQueue.main.async {
                    // Update UI with error message...
                    let alertController = UIAlertController(title: "Error", message: "Failed to locate JSON file", preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "OK", style: .default)
                    alertController.addAction(okAction)
                    UIApplication.shared.windows.first?.rootViewController?.present(alertController, animated: true, completion: nil)
                    isSpinnerVisible = false // Hide the activity indicator
                }
                return
            }
            
            do {
                let data = try Data(contentsOf: url)
                let jsonObject = try JSONSerialization.jsonObject(with: data, options: [])
                
                // Parse the JSON data...
                guard let object = jsonObject as? [String: Any],
                      let xArray = object["x_coords"] as? [NSNumber],
                      let yArray = object["y_coords"] as? [NSNumber],
                      let zArray = object["z_coords"] as? [NSNumber]
                else {
                    DispatchQueue.main.async {
                        // Update UI with error message...
                        let alertController = UIAlertController(title: "Error", message: "Failed to parse JSON file", preferredStyle: .alert)
                        let okAction = UIAlertAction(title: "OK", style: .default)
                        alertController.addAction(okAction)
                        UIApplication.shared.windows.first?.rootViewController?.present(alertController, animated: true, completion: nil)
                        isSpinnerVisible = false // Hide the activity indicator
                    }
                    return
                }
                
                let xFloatArray = xArray.map { $0.floatValue }
                let yFloatArray = yArray.map { $0.floatValue }
                let zFloatArray = zArray.map { $0.floatValue }
                
                let particlesNode = createParticleNodes(xFloatArray: xFloatArray, yFloatArray: yFloatArray, zFloatArray: zFloatArray, sphereGeometry: sphereGeometry, sphereMaterial: sphereMaterial)
                
                DispatchQueue.main.async {
                    particleNodes = [particlesNode]
                    isLoaded = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        isSpinnerVisible = false // Hide the activity indicator after a short delay
                    }
                }

            } catch {
                DispatchQueue.main.async {
                    // Update UI with error message...
                    let alertController = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "OK", style: .default)
                    alertController.addAction(okAction)
                    UIApplication.shared.windows.first?.rootViewController?.present(alertController, animated: true, completion: nil)
                    isSpinnerVisible = false // Hide the activity indicator
                }
            }
        }
    }

    func createParticleNodes(xFloatArray: [Float], yFloatArray: [Float], zFloatArray: [Float], sphereGeometry: SCNSphere, sphereMaterial: SCNMaterial) -> SCNNode {
        // Perform time-consuming task here...
        let xMean = xFloatArray.reduce(0, +) / Float(xFloatArray.count)
        let yMean = yFloatArray.reduce(0, +) / Float(yFloatArray.count)
        let zMean = zFloatArray.reduce(0, +) / Float(zFloatArray.count)
        let center = SCNVector3(xMean / 15.0, yMean / 15.0, zMean / 15.0)
        
        sphereMaterial.lightingModel = .physicallyBased
        sphereMaterial.diffuse.contents = AtomView.hexStringToUIColor(hex: element.color)
        
        let particleSphereNodes = (0..<xFloatArray.count).map { index in
            let particlePosition = SCNVector3(x: Float(xFloatArray[index] / 15.0), y: Float(yFloatArray[index] / 15.0), z: Float(zFloatArray[index]) / 15.0)
            
            let particleSphereNodes = SCNNode(geometry: sphereGeometry)
            particleSphereNodes.geometry?.materials = [sphereMaterial]
            particleSphereNodes.position = particlePosition
            let constraint = SCNBillboardConstraint()
            constraint.freeAxes = .all
            particleSphereNodes.constraints = [constraint]
            
            return particleSphereNodes
        }
        
        let particlesNode = SCNNode()
        particleSphereNodes.forEach { particlesNode.addChildNode($0) }
        
        let boundingBox = particlesNode.boundingBox
        let particleSize = SCNVector3(boundingBox.max.x - boundingBox.min.x,
                                      boundingBox.max.y - boundingBox.min.y,
                                      boundingBox.max.z - boundingBox.min.z)
        
        particlesNode.position = SCNVector3(
            -boundingBox.min.x - (boundingBox.max.x - boundingBox.min.x) / 2.0,
             -boundingBox.min.y - (boundingBox.max.y - boundingBox.min.y) / 2.0,
             -boundingBox.min.z - (boundingBox.max.z - boundingBox.min.z) / 2.0
        )
        
        let maxDimension = max(particleSize.x, particleSize.y, particleSize.z)
        let scaleFactor = 1.0 / (maxDimension * 0.5) // Adjust the multiplier as desired
        particlesNode.scale = SCNVector3(scaleFactor, scaleFactor, scaleFactor)
        
        let rotation = SCNAction.rotateBy(x: 0, y: 2 * .pi, z: 0, duration: 10)
        particlesNode.runAction(SCNAction.repeatForever(rotation))
        
        let randomPositions = particleSphereNodes.map { _ in
            SCNVector3(Float.random(in: -1.0...1.0), Float.random(in: -1.0...1.0), Float.random(in: -1.0...1.0))
        }
        
        for i in 0..<particleSphereNodes.count {
            let particleSphereNode = particleSphereNodes[i]
            let randomPosition = randomPositions[i]
            let actualPosition = particleSphereNode.position
            
            particleSphereNode.position = randomPosition
            
            let moveAction = SCNAction.move(to: actualPosition, duration: 0.5)
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(i) * 0.001) {
                particleSphereNode.runAction(moveAction)
            }
        }
        
        return particlesNode
        
    }
}
