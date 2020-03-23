//
//  ARQRTrackingViewController.swift
//  SampleProject
//
//  Created by Eugene Smolyakov on 23/03/2020.
//  Copyright © 2020 JendBy. All rights reserved.
//

import UIKit
import ARKit
import Vision

final class ARQRTrackingViewController: BaseViewController {
    var output: ARQRTrackingViewOutput!
    var sceneView: ARSCNView!
    var requests = [VNRequest]()
    let updateQueue = DispatchQueue(label: "\(Bundle.main.bundleIdentifier!).SCNQueue")
    var detectedDataAnchor: ARAnchor?
    
    // MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sceneView = ARSCNView()
        self.view = sceneView
        sceneView.delegate = self
        sceneView.session.delegate = self
        sceneView.showsStatistics = true

        let scene = SCNScene()
        sceneView.scene = scene
        
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .horizontal
//        configuration.worldAlignment = .camera
        sceneView.session.run(configuration)
        setupVision()
        output.viewIsReady()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
      super.viewWillDisappear(animated)
      sceneView.session.pause()
    }
    
 
    func setupVision() {
        let barcodeRequest = VNDetectBarcodesRequest(completionHandler: barcodeDetectionHandler)
        barcodeRequest.symbologies = [.QR]
        self.requests = [barcodeRequest]
    }
    
    func barcodeDetectionHandler(request: VNRequest, error: Error?) {
        guard let results = request.results else { return }
        guard let result = results.first as? VNBarcodeObservation else  {
            return
        }
        guard let currentFrame = sceneView.session.currentFrame else { return }
        var rect = result.boundingBox
        
        
        rect = rect.applying(CGAffineTransform(scaleX: 1, y: -1))
        rect = rect.applying(CGAffineTransform(translationX: 0, y: 1))
        
        let center = CGPoint(x: rect.midX, y: rect.midY)
        print("center", center)
        
        DispatchQueue.main.async() {
            let hitTestResults = currentFrame.hitTest(center, types: [.featurePoint])
            if let hitTestResult = hitTestResults.first {
                if let detectedDataAnchor = self.detectedDataAnchor,
                    let node = self.sceneView.node(for: detectedDataAnchor) {
                    print("transform")
                    node.transform = SCNMatrix4(hitTestResult.worldTransform)
                    
                } else {
                    print("det")
                    self.detectedDataAnchor = ARAnchor(transform: hitTestResult.worldTransform)
                    self.sceneView.session.add(anchor: self.detectedDataAnchor!)
                }
            }
        }
    }
}
// MARK: - ARSessionDelegate
extension ARQRTrackingViewController: ARSessionDelegate {
    func session(_ session: ARSession, didUpdate frame: ARFrame) {
        updateQueue.async {
            do {
                let imageRequestHandler = VNImageRequestHandler(cvPixelBuffer: frame.capturedImage,
                                                                options: [:])
                try imageRequestHandler.perform(self.requests)
            } catch {
                print("error")
            }
        }
    }
}
// MARK: - ARSCNViewDelegate
extension ARQRTrackingViewController: ARSCNViewDelegate {
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
            if self.detectedDataAnchor?.identifier == anchor.identifier {
                
                guard let ship = SCNScene(named: "art.scnassets/ship.scn") else {
                    return nil
                }
                
                let node = SCNNode()
                node.addChildNode(ship.rootNode)
                node.transform = SCNMatrix4(anchor.transform)
                
                return node
            }
            
            return nil
        }
}

// MARK: - ARQRTrackingViewInput
extension ARQRTrackingViewController: ARQRTrackingViewInput {
    func setupInitialState() {
    }
}
