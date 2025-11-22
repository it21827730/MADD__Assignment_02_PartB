import SwiftUI
import SceneKit

struct SceneKitMeditationView: UIViewRepresentable {
    var selectedScene: MeditationScene

    func makeUIView(context: Context) -> SCNView {
        let view = SCNView()
        view.allowsCameraControl = false
        view.autoenablesDefaultLighting = true
        view.backgroundColor = .clear
        view.scene = makeScene(for: selectedScene)
        view.isPlaying = true

        return view
    }

    func updateUIView(_ uiView: SCNView, context: Context) {
        uiView.scene = makeScene(for: selectedScene)
    }

    private func makeScene(for scene: MeditationScene) -> SCNScene {
        let scnScene = SCNScene()

        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        cameraNode.position = SCNVector3(x: 0, y: 0, z: 8)
        scnScene.rootNode.addChildNode(cameraNode)

        let lightNode = SCNNode()
        lightNode.light = SCNLight()
        lightNode.light?.type = .omni
        lightNode.position = SCNVector3(x: 0, y: 5, z: 10)
        scnScene.rootNode.addChildNode(lightNode)

        let ambientLightNode = SCNNode()
        ambientLightNode.light = SCNLight()
        ambientLightNode.light?.type = .ambient
        ambientLightNode.light?.color = UIColor(white: 0.4, alpha: 1.0)
        scnScene.rootNode.addChildNode(ambientLightNode)

        let sphere = SCNSphere(radius: 2.5)
        sphere.segmentCount = 96

        let material = SCNMaterial()
        material.diffuse.contents = gradientColor(for: scene)
        material.emission.contents = gradientColor(for: scene).withAlphaComponent(0.6)
        material.locksAmbientWithDiffuse = true
        sphere.materials = [material]

        let sphereNode = SCNNode(geometry: sphere)
        scnScene.rootNode.addChildNode(sphereNode)

        let rotation = CABasicAnimation(keyPath: "rotation")
        rotation.fromValue = SCNVector4(0, 1, 0, 0)
        rotation.toValue = SCNVector4(0, 1, 0, Float.pi * 2)
        rotation.duration = 40
        rotation.repeatCount = .infinity
        sphereNode.addAnimation(rotation, forKey: "slow-rotation")

        return scnScene
    }

    private func gradientColor(for scene: MeditationScene) -> UIColor {
        switch scene {
        case .lavender:
            return UIColor(red: 0.78, green: 0.69, blue: 0.99, alpha: 1.0)
        case .sunset:
            return UIColor(red: 1.0, green: 0.60, blue: 0.54, alpha: 1.0)
        case .ocean:
            return UIColor(red: 0.10, green: 0.38, blue: 0.70, alpha: 1.0)
        case .forest:
            return UIColor(red: 0.19, green: 0.47, blue: 0.36, alpha: 1.0)
        }
    }
}
