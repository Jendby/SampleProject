//
//  Bullet.swift
//  SampleProject
//
//  Created by Eugene Smolyakov on 27/03/2020.
//  Copyright © 2020 ES. All rights reserved.
//

import UIKit
import SceneKit

class Bullet: SCNNode {
    override init () {
        super.init()
        let sphere = SCNSphere(radius: 0.025)
        self.geometry = sphere
        let shape = SCNPhysicsShape(geometry: sphere, options: nil)
        self.physicsBody = SCNPhysicsBody(type: .dynamic, shape: shape)
        self.physicsBody?.isAffectedByGravity = false
        
        self.physicsBody?.categoryBitMask = BitMaskCategory.bullet
        self.physicsBody?.collisionBitMask = BitMaskCategory.box
        self.physicsBody?.contactTestBitMask = BitMaskCategory.box
      
        self.geometry?.firstMaterial?.diffuse.contents = UIColor.yellow
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
