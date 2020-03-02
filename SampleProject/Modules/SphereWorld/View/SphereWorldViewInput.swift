//
//  SphereWorldViewInput.swift
//  SampleProject
//
//  Created by Eugene Smolyakov on 02/03/2020.
//  Copyright © 2020 JendBy. All rights reserved.
//

import UIKit
import CoreMotion

protocol SphereWorldViewInput: class, Presentable {
    func setupInitialState()
    func attachArViewWithSphereAnd(image: UIImage)
    func detachArViewWithSphere()
    func changed(attitude: CMAttitude)
    func set360btn(tracked: Bool)
}
