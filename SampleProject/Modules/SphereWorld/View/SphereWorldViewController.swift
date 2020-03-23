//
//  SphereWorldViewController.swift
//  SampleProject
//
//  Created by Eugene Smolyakov on 02/03/2020.
//  Copyright © 2020 JendBy. All rights reserved.
//

import UIKit
import CoreMotion
import SceneKit

final class SphereWorldViewController: BaseViewController {
    var output: SphereWorldViewOutput!
    
    private weak var sceneView: SCNView? = nil
    private var cameraNode: SCNNode? = nil
    var rItem:UIBarButtonItem!

    // MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .cyan
        rItem = UIBarButtonItem(title: "", style: .plain, target: self, action: #selector(change))
        navigationItem.rightBarButtonItem = rItem
        output.viewIsReady()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        output.stopTracking()
    }
    @objc func change() {
        output.navBtnTapped()
    }
}


// MARK: - SphereWorldViewInput
extension SphereWorldViewController: SphereWorldViewInput {
    func set360btn(tracked: Bool) {
        if tracked {
            rItem.title = "Remove sphere".localized
        } else {
            rItem.title = "Add sphere".localized
        }
    }
    
    func setupInitialState() {
    }
    
    func attachArViewWithSphereAnd(image: UIImage){
        // check if it's attached first:
        detachArViewWithSphere()
        // create a scene
        let scene = SCNScene()
        let sceneView = SCNView()
        sceneView.translatesAutoresizingMaskIntoConstraints = false
        sceneView.scene = scene
        sceneView.allowsCameraControl = false

        // create sphere where we'll attach our image to
        let sphere = SCNSphere(radius: 20.0)
        sphere.firstMaterial!.isDoubleSided = true
        sphere.firstMaterial!.diffuse.contents = image
        let sphereNode = SCNNode(geometry: sphere)
        sphereNode.position = SCNVector3Make(0,0,0)
        scene.rootNode.addChildNode(sphereNode)

        // add camera for moving around it:
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        cameraNode.position = SCNVector3Make(0, 0, 0)
        scene.rootNode.addChildNode(cameraNode)

        self.view.addSubview(sceneView)
        self.view.addConstraints(
            [sceneView.topAnchor.constraint(equalTo: self.view.topAnchor),
             sceneView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
             sceneView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
             sceneView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
        ])
        // attach it to background view
        self.cameraNode = cameraNode
        self.sceneView = sceneView
        output.back360attached()
    }
    
    func detachArViewWithSphere(){
        if sceneView != nil {
            cameraNode?.removeAllActions()
            sceneView?.removeFromSuperview()
        }
    }
    
    func changed(attitude: CMAttitude){
        guard cameraNode != nil else { return }
        let secattitude = attitude.quaternion
        let aq = GLKQuaternionMake(Float(secattitude.x),
                                   Float(secattitude.y),
                                   Float(secattitude.z),
                                   Float(secattitude.w))
        let final: SCNVector4
        let cq = GLKQuaternionMakeWithAngleAndAxis(Float(-Double.pi*0.5), 1, 0, 0)
        let q = GLKQuaternionMultiply(cq, aq)

        final = SCNVector4(x: q.x, y: q.y, z: q.z, w: q.w)
        cameraNode?.orientation = SCNVector4Make(final.x, final.y, final.z, final.w)
    }
}
