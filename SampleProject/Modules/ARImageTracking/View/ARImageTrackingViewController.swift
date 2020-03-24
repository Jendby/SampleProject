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
    
    var gunNode: SCNNode?
    var shipNode: SCNNode?
    var nodes = [SCNNode]()
    var addedNodes = [String:SCNNode]()

    // MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        sceneView = ARSCNView()
        self.view = sceneView
        sceneView.delegate = self
        sceneView.session.delegate = self
        sceneView.showsStatistics = true
        sceneView.autoenablesDefaultLighting = true
        
        let scene = SCNScene()
        sceneView.scene = scene
        
        let configuration = ARWorldTrackingConfiguration()
        guard let storedImages =  ARReferenceImage.referenceImages(inGroupNamed: "AR Resources", bundle: nil) else {
            fatalError("Missing AR Resources images")
        }
        configuration.detectionImages = storedImages
        configuration.maximumNumberOfTrackedImages = 2
        
        if let gunScene = SCNScene(named: "art.scnassets/Handgun_dae copy.scn") {
            gunNode = gunScene.rootNode
            if let nodes = gunNode?.childNodes.first?.childNodes {
                for item in nodes {
                    actionAnimationForNode(item, action: false)
                }
            }
        }
        
        let ship = SCNScene(named: "art.scnassets/ship.scn")
        shipNode = ship?.rootNode
        shipNode?.scale = SCNVector3(0.2, 0.2, 0.2)
        
        sceneView.session.run(configuration)
        
        output.viewIsReady()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
      super.viewWillDisappear(animated)
      sceneView.session.pause()
    }
    
    func actionAnimationForNode(_ node:SCNNode, action: Bool) {
        for key in node.animationKeys where node.animationPlayer(forKey: key) != nil
        {
            let player = node.animationPlayer(forKey: key)
            if action {
                player?.play()
            } else {
                player?.stop()
            }
        }
    }
}

// MARK: - ARSessionDelegate
extension ARImageTrackingViewController: ARSessionDelegate {
    
}
// MARK: - ARSCNViewDelegate
extension ARImageTrackingViewController: ARSCNViewDelegate {
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        guard let imageAnchor = anchor as? ARImageAnchor else {return nil}
        let node = SCNNode()
        let plane = SCNPlane(width: imageAnchor.referenceImage.physicalSize.width,
                             height: imageAnchor.referenceImage.physicalSize.height)
        plane.firstMaterial?.diffuse.contents = UIColor.black.withAlphaComponent(0.8)
        
        let planeNode = SCNNode(geometry: plane)
        let ninetyDegrees = GLKMathDegreesToRadians(-90)
        planeNode.eulerAngles = SCNVector3(ninetyDegrees, 0, 0)
        node.addChildNode(planeNode)
        
        var scnnode: SCNNode?
        if imageAnchor.referenceImage.name == TrackingImage.bubble.rawValue {
            scnnode = gunNode
        }
        if imageAnchor.referenceImage.name == TrackingImage.candy.rawValue {
            scnnode = shipNode
        }
        guard let scnn = scnnode else { return nil }
        node.addChildNode(scnn)
        nodes.append(node)
        return node
    }
    
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        guard let pointOfView = sceneView.pointOfView else { return }
        let transform = pointOfView.transform
        let location = SCNVector3(transform.m41, transform.m42, transform.m43)

        if nodes.count == 2 {
            let loc = SCNVector3ToGLKVector3(location)
            let pos1 = SCNVector3ToGLKVector3(nodes[0].position)
            let dist = GLKVector3Distance(loc, pos1)
            if dist < 7 {
                if let nodes = gunNode?.childNodes.first?.childNodes {
                    for item in nodes {
                        actionAnimationForNode(item, action: false)
                    }
                }
                gunNode!.enumerateChildNodes { (child, _) in
                    for key in child.animationKeys {
                        let animation = child.animation(forKey: key)!
                        animation.usesSceneTimeBase = false
                        animation.repeatCount = Float.infinity
                        child.addAnimation(animation, forKey: key)
                    }
                }
            }
        }
    }

    
}

// MARK: - ARImageTrackingViewInput
extension ARImageTrackingViewController: ARImageTrackingViewInput {
    func setupInitialState() {
    }
}
