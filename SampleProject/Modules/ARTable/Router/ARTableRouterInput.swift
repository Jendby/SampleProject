//
//  ARTableRouterInput.swift
//  SampleProject
//
//  Created by Eugene Smolyakov on 08/03/2020.
//  Copyright © 2020 JendBy. All rights reserved.
//

import UIKit

protocol ARTableRouterInput {
    func createSphere(from vc:UIViewController)
    func cameraView(from vc:UIViewController)
    func ARQRTracking(from vc:UIViewController)
    func ARImageTracking(from vc:UIViewController)
}
