//
//  StartTableRouter.swift
//  SampleProject
//
//  Created by Eugene Smolyakov on 28/02/2020.
//  Copyright © 2020 JendBy. All rights reserved.
//

import UIKit

final class StartTableRouter {
}

// MARK: - : StartTableRouterInput
extension StartTableRouter: StartTableRouterInput {
    func showCameraView(from vc: UIViewController) {
        CameraViewModule.create().present(from: vc)
    }
    func showSphereView(from vc: UIViewController) {
        SphereWorldModule.create().present(from: vc)
    }
}
