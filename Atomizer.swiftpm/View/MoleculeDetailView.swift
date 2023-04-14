import SwiftUI
import SceneKit
import GLTFSceneKit

struct Molecule3DView: UIViewRepresentable {
    typealias UIViewType = SCNView

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
        var parent: Molecule3DView
        
        init(_ parent: Molecule3DView) {
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

struct MoleculeDetailView: View {
    let molecule: Molecule

    @State private var selectedTab = 0

    var body: some View {
        VStack {
            Molecule3DView()
                .edgesIgnoringSafeArea(.all)

            Text(molecule.name)
                .font(.largeTitle)
                .bold()
                .padding()

            ZStack(alignment: .bottom) {
                TabView(selection: $selectedTab) {
                    VStack(alignment: .leading, spacing: 20) {
                        Text("Description")
                            .font(.headline)
                        Text(molecule.description)
                        Spacer()
                    }
                    .padding()
                    .tag(0)

                    VStack(alignment: .leading, spacing: 20) {
                        Text("Molecular Formula")
                            .font(.headline)
                        Text(molecule.formula)
                        Spacer()
                    }
                    .padding()
                    .tag(1)

                    VStack(alignment: .leading, spacing: 20) {
                        Text("Shape")
                            .font(.headline)
                        Text(molecule.shape)
                        Spacer()
                    }
                    .padding()
                    .tag(2)

                    VStack(alignment: .leading, spacing: 20) {
                        Text("Polarity")
                            .font(.headline)
                        Text(molecule.polarity)
                        Spacer()
                    }
                    .padding()
                    .tag(3)

                    VStack(alignment: .leading, spacing: 20) {
                        Text("Bond Angle")
                            .font(.headline)
                        Text(molecule.bondAngle)
                        Spacer()
                    }
                    .padding()
                    .tag(4)

                    VStack(alignment: .leading, spacing: 20) {
                        Text("Orbitals")
                            .font(.headline)
                        Text(molecule.orbitals)
                        Spacer()
                    }
                    .padding()
                    .tag(5)

                    VStack(alignment: .leading, spacing: 20) {
                        Text("Hybridization")
                            .font(.headline)
                        Text(molecule.hybridization)
                        Spacer()
                    }
                    .padding()
                    .tag(6)

                    VStack(alignment: .leading, spacing: 20) {
                        Text("Molecular Geometry")
                            .font(.headline)
                        Text(molecule.molecularGeometry)
                        Spacer()
                    }
                    .padding()
                    .tag(7)

                    VStack(alignment: .leading, spacing: 20) {
                        Text("Bonds")
                            .font(.headline)
                        Text(molecule.bonds)
                        Spacer()
                    }
                    .padding()
                    .tag(8)
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                .padding(.horizontal)

                HStack(spacing: 0) {
                    ForEach(0..<9) { i in
                        Rectangle()
                            .fill(i == selectedTab ? Color.white : Color.gray)
                            .frame(width: 30, height: 5)
                            .cornerRadius(3)
                            .padding(.vertical, 8)
                            .animation(.easeInOut, value: selectedTab)
                            .onTapGesture {
                                selectedTab = i
                            }
                    }
                }
                .padding(.bottom)
            }
            .frame(height: 300)

            Spacer()
        }
        .background(Color(UIColor.darkGray).opacity(0.2))
        .cornerRadius(20)
        .shadow(radius: 10)
        .padding()
    }
}






