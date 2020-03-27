//
//  ARTableRouter.swift
//  SampleProject
//
//  Created by Eugene Smolyakov on 08/03/2020.
//  Copyright © 2020 JendBy. All rights reserved.
//

import UIKit

final class ARTableRouter {
}

// MARK: - : ARTableRouterInput
extension ARTableRouter: ARTableRouterInput {
    func createSphere(from vc: UIViewController) {
        SphereWorldModule.create().present(from: vc)
    }
    
    func cameraView(from vc: UIViewController) {
        CameraViewModule.create().present(from: vc)
    }
    func ARQRTracking(from vc:UIViewController) {
        ARQRTrackingModule.create().present(from: vc)
    }
    func ARImageTracking(from vc:UIViewController) {
        ARImageTrackingModule.create().present(from: vc)
    }
    func FrameworkTextTracking(from vc:UIViewController) {
        DataFromFramTextRecModule.create().present(from: vc)
    }
    func ArShooter(from vc:UIViewController) {
        ARShooterModule.create().present(from: vc)
    }
}
