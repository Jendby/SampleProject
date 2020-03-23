//
//  ARImageTrackingViewController.swift
//  SampleProject
//
//  Created by Eugene Smolyakov on 24/03/2020.
//  Copyright © 2020 JendBy. All rights reserved.
//

import UIKit
import ARKit

final class ARImageTrackingViewController: BaseViewController {
    var output: ARImageTrackingViewOutput!
    var sceneView: ARSCNView!

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
        sceneView.session.run(configuration)
        output.viewIsReady()
    }
}

// MARK: - ARSessionDelegate
extension ARImageTrackingViewController: ARSessionDelegate {
    
}
// MARK: - ARSCNViewDelegate
extension ARImageTrackingViewController: ARSCNViewDelegate {
    
}

// MARK: - ARImageTrackingViewInput
extension ARImageTrackingViewController: ARImageTrackingViewInput {
    func setupInitialState() {
    }
}
