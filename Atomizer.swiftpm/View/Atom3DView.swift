import SwiftUI
import RealityKit
import ARKit

struct Atom3DView: UIViewRepresentable {
    typealias UIViewType = ARView

    func makeUIView(context: Context) -> ARView {
        let arView = ARView(frame: .zero)
        let arConfiguration = ARWorldTrackingConfiguration()
        arView.session.run(arConfiguration, options: [])

        // Create and add spheres to the scene
        for _ in 0..<20 {
            let sphere = MeshResource.generateSphere(radius: 0.1)
            let material = SimpleMaterial(color: UIColor.random(), roughness: 0.1, isMetallic: false)
            let model = ModelEntity(mesh: sphere, materials: [material])

            let x = Float.random(in: -1...1)
            let y = Float.random(in: -1...1)
            let z = Float.random(in: -1...1)
            let position = SIMD3<Float>(x, y, z)
            model.position = position

            let anchorEntity = AnchorEntity(world: position)
            anchorEntity.addChild(model)
            arView.scene.addAnchor(anchorEntity)
        }

        // Set up gesture recognizers for panning and zooming
        let panRecognizer = UIPanGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.handlePan(_:)))
        arView.addGestureRecognizer(panRecognizer)

        let pinchRecognizer = UIPinchGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.handlePinch(_:)))
        arView.addGestureRecognizer(pinchRecognizer)

        return arView
    }

    func updateUIView(_ uiView: ARView, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject {
        var parent: Atom3DView

        init(_ parent: Atom3DView) {
            self.parent = parent
        }

        @objc func handlePan(_ recognizer: UIPanGestureRecognizer) {
            let translation = recognizer.translation(in: recognizer.view)
            let panX = Float(translation.x)
            let panY = Float(-translation.y)
            let sensitivity: Float = 0.005
            let rotateX = simd_quatf(angle: panY * sensitivity, axis: SIMD3<Float>(1, 0, 0))
            let rotateY = simd_quatf(angle: panX * sensitivity, axis: SIMD3<Float>(0, 1, 0))
            let rotation = rotateY * rotateX

            if let arView = recognizer.view as? ARView {
                arView.scene.anchors.forEach { anchor in
                    anchor.children.forEach { child in
                        child.transform.rotation *= rotation
                    }
                }
            }
            recognizer.setTranslation(.zero, in: recognizer.view)
        }

        @objc func handlePinch(_ recognizer: UIPinchGestureRecognizer) {
            let zoomFactor = Float(recognizer.scale)
            let sensitivity: Float = 0.1
            let scaleFactor = 1 + (zoomFactor > 1 ? sensitivity : -sensitivity) * abs(zoomFactor - 1)

            if let arView = recognizer.view as? ARView {
                arView.scene.anchors.forEach { anchor in
                    anchor.children.forEach { child in
                        child.transform.scale *= scaleFactor
                    }
                }
            }
            recognizer.scale = 1
        }
    }
}

// Extension to generate random colors
extension UIColor {
static func random() -> UIColor {
let hue = CGFloat.random(in: 0...1)
let saturation = CGFloat.random(in: 0.5...1)
let brightness = CGFloat.random(in: 0.5...1)
return UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: 1)
}
}

