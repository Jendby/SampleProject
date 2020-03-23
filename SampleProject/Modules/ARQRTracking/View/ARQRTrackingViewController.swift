//
//  ARQRTrackingViewController.swift
//  SampleProject
//
//  Created by Eugene Smolyakov on 23/03/2020.
//  Copyright © 2020 JendBy. All rights reserved.
//

import UIKit
import ARKit

final class ARQRTrackingViewController: BaseViewController {
    var output: ARQRTrackingViewOutput!
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
        configuration.worldAlignment = .camera
        sceneView.session.run(configuration)
        
        output.viewIsReady()
    }


    override func viewWillDisappear(_ animated: Bool) {
      super.viewWillDisappear(animated)

      // Pause the view's session
      sceneView.session.pause()
    }
}
// MARK: - ARSessionDelegate
extension ARQRTrackingViewController: ARSessionDelegate {
    
}
// MARK: - ARSCNViewDelegate
extension ARQRTrackingViewController: ARSCNViewDelegate {
    
}

// MARK: - ARQRTrackingViewInput
extension ARQRTrackingViewController: ARQRTrackingViewInput {
    func setupInitialState() {
    }
}
