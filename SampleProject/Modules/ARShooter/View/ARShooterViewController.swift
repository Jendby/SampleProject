//
//  ARShooterViewController.swift
//  SampleProject
//
//  Created by Eugene Smolyakov on 27/03/2020.
//  Copyright © 2020 JendBy. All rights reserved.
//

import UIKit
import SceneKit
import ARKit
import Vision

final class ARShooterViewController: BaseViewController {
    var output: ARShooterViewOutput!
    var sceneView: ARSCNView!
    
    let currentMLModel = hand2().model
    private let serialQueue = DispatchQueue(label: "dispatchqueueml")
    private var visionRequests = [VNRequest]()
    
    private var timer = Timer()

    // MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        sceneView = ARSCNView()
        self.view = sceneView
        sceneView.delegate = self
        sceneView.session.delegate = self
        sceneView.showsStatistics = true
        sceneView.autoenablesDefaultLighting = true
        sceneView.scene.physicsWorld.contactDelegate = self
        
        let scene = SCNScene()
        sceneView.scene = scene
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .horizontal
        
        setupCoreML()

        sceneView.session.run(configuration)
        
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.loopCoreMLUpdate), userInfo: nil, repeats: true)
        addBox()
        
        output.viewIsReady()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        sceneView.session.pause()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Create a session configuration
        
    }
    
    func addBox() {
        let box = Box()
        
        let posX = floatBetween(-0.5, and: 0.5)
        let posY = floatBetween(-0.5, and: 0.5  )
        box.position = SCNVector3(posX, posY, -1)
        sceneView.scene.rootNode.addChildNode(box)
    }
    
    func addBullet() {
        let bulletsNode = Bullet()
        guard let pov = sceneView.pointOfView else { return }
        let transform = pov.transform
        let orientation = SCNVector3(-transform.m31, -transform.m32, -transform.m33)
        let location = SCNVector3(transform.m41, transform.m42, transform.m43)
        let position = SCNVector3(orientation.x + location.x, orientation.y + location.y, orientation.z + location.z)
        bulletsNode.position = position
        let force: Float = 2
        bulletsNode.physicsBody?.applyForce(SCNVector3(orientation.x * force, orientation.y * force, orientation.z * force), asImpulse: true)
        sceneView.scene.rootNode.addChildNode(bulletsNode)
    }
    
    func floatBetween(_ first: Float,  and second: Float) -> Float { // random float between upper and lower bound (inclusive)
        return (Float(arc4random()) / Float(UInt32.max)) * (first - second) + second
    }
    
    private func setupCoreML() {
        guard let selectedModel = try? VNCoreMLModel(for: currentMLModel) else {
            fatalError("Could not load model.")
        }
        
        let classificationRequest = VNCoreMLRequest(model: selectedModel,
                                                    completionHandler: classificationCompleteHandler)
        classificationRequest.imageCropAndScaleOption = VNImageCropAndScaleOption.centerCrop // Crop from centre of images and scale to appropriate size.
        visionRequests = [classificationRequest]
    }
    @objc private func loopCoreMLUpdate() {
        serialQueue.async {
            self.updateCoreML()
        }
    }
    
    private func updateCoreML() {
        let pixbuff : CVPixelBuffer? = (sceneView.session.currentFrame?.capturedImage)
        if pixbuff == nil { return }
        
        let imageRequestHandler = VNImageRequestHandler(cvPixelBuffer: pixbuff!, orientation: .right ,options: [:])
        do {
            try imageRequestHandler.perform(self.visionRequests)
        } catch {
            print(error)
        }
        
    }
    
    private func classificationCompleteHandler(request: VNRequest, error: Error?) {
        if error != nil {
            print("Error: " + (error?.localizedDescription)!)
            return
        }
        guard let observations = request.results else {
            return
        }
        
        let classifications = observations[0...2]
            .compactMap({ $0 as? VNClassificationObservation })
            .map({ "\($0.identifier) \(String(format:" : %.2f", $0.confidence))" })
            .joined(separator: "\n")
        
//        print("Classifications: \(classifications)")
        
        DispatchQueue.main.async {
            let topPrediction = classifications.components(separatedBy: "\n")[0]
            let topPredictionName = topPrediction.components(separatedBy: ":")[0].trimmingCharacters(in: .whitespaces)
            guard let topPredictionScore: Float = Float(topPrediction.components(separatedBy: ":")[1].trimmingCharacters(in: .whitespaces)) else { return }
            
                
                if topPredictionName == "hand_fist" {
                    self.addBullet()
//                    print("closed")
                }
        }
    }
}


// MARK: - ARShooterViewInput
extension ARShooterViewController: ARShooterViewInput {
    func setupInitialState() {
    }
}
// MARK: - ARSessionDelegate
extension ARShooterViewController: ARSessionDelegate {
    
}
// MARK: - ARSCNViewDelegate
extension ARShooterViewController: ARSCNViewDelegate {
}

// MARK: - SCNPhysicsContactDelegate
extension ARShooterViewController: SCNPhysicsContactDelegate {
    func physicsWorld(_ world: SCNPhysicsWorld, didBegin contact: SCNPhysicsContact) {
        contact.nodeB.removeFromParentNode()
        print("Hit ship!")
        contact.nodeA.removeFromParentNode()
    }
}
