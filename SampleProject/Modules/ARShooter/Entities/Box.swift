//
//  Box.swift
//  SampleProject
//
//  Created by Eugene Smolyakov on 27/03/2020.
//  Copyright © 2020 ES. All rights reserved.
//

import UIKit
import SceneKit

// Floating boxes that appear around you
class Box: SCNNode {
    override init() {
        super.init()
        let box = SCNBox(width: 0.2, height: 0.2, length: 0.2, chamferRadius: 0)
        self.geometry = box
        let shape = SCNPhysicsShape(geometry: box, options: nil)
        self.physicsBody = SCNPhysicsBody(type: .dynamic, shape: shape)
        self.physicsBody?.isAffectedByGravity = false
        
        self.physicsBody?.categoryBitMask = BitMaskCategory.box
        self.physicsBody?.collisionBitMask = BitMaskCategory.bullet
        self.physicsBody?.contactTestBitMask = BitMaskCategory.bullet
//        self.geometry?.firstMaterial?.diffuse.contents = UIColor.yellow
        let material = SCNMaterial()
        let im:UIImage = #imageLiteral(resourceName: "imgFor360")
        material.diffuse.contents = im
        self.geometry?.materials  = [material]
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
