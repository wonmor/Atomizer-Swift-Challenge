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
            Uses the ElectronVisualized REST API to download the electron coordinates.
            The API was created from scratch by me, using Python and Flask.
            I used SciPy and NumPy to calculate spherical harmonics.
            Then, I sampled the wavefunction by using the Metropolis-Hastings algorithm.

            GitHub repo of the API that I created:
            https://github.com/wonmor/ElectronVisualized
            
            Relevant links:
            https://en.wikipedia.org/wiki/Spherical_harmonics
            https://en.wikipedia.org/wiki/Metropolis–Hastings_algorithm
        */

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

                    // Set up the sphere material with a reflection
                    self.sphereMaterial.lightingModel = .physicallyBased
                    self.sphereMaterial.diffuse.contents = AtomView.hexStringToUIColor(hex: element.color)
                    
                    // Calculate the center of the particle cloud
                    let xMean = xFloatArray.reduce(0, +) / Float(xFloatArray.count)
                    let yMean = yFloatArray.reduce(0, +) / Float(yFloatArray.count)
                    let zMean = zFloatArray.reduce(0, +) / Float(zFloatArray.count)
                    _ = SCNVector3(xMean / 15.0, yMean / 15.0, zMean / 15.0)
                    
                    // Create the particle nodes
                    let particleSphereNodes = (0..<xFloatArray.count).map { index in
                        let particlePosition = SCNVector3(x: Float(xFloatArray[index] / 15.0), y: Float(yFloatArray[index] / 15.0), z: Float(zFloatArray[index]) / 15.0)
                        
                        let particleSphereNode = SCNNode(geometry: sphereGeometry)
                        particleSphereNode.geometry?.materials = [sphereMaterial]
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
                    
                    // Add the rotation animation to the particle node
                    let rotation = SCNAction.rotateBy(x: 0, y: 2 * .pi, z: 0, duration: 10)
                    particlesNode.runAction(SCNAction.repeatForever(rotation))
                    
                    // Create an array of random positions for each particle
                    let randomPositions = particleSphereNodes.map { _ in
                        SCNVector3(Float.random(in: -1.0...1.0), Float.random(in: -1.0...1.0), Float.random(in: -1.0...1.0))
                    }

                    // Animate each particle to its actual position
                    for i in 0..<particleSphereNodes.count {
                        let particleSphereNode = particleSphereNodes[i]
                        let randomPosition = randomPositions[i]
                        let actualPosition = particleSphereNode.position

                        // Set the initial position of the particle to the random position
                        particleSphereNode.position = randomPosition

                        // Add an action to animate the particle to its actual position
                        let moveAction = SCNAction.move(to: actualPosition, duration: 0.5)
                        DispatchQueue.main.asyncAfter(deadline: .now() + Double(i) * 0.001) {
                            particleSphereNode.runAction(moveAction)
                        }
                    }
                    
                    DispatchQueue.main.async {
                        particleNodes = [particlesNode]
                        isLoaded = true
                    }
                }
            } catch {
                DispatchQueue.main.async {
                    let alertController = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "OK", style: .default)
                    alertController.addAction(okAction)
                    UIApplication.shared.windows.first?.rootViewController?.present(alertController, animated: true, completion: nil)
                }
            }
        }
        
        task.resume()
    }
}
