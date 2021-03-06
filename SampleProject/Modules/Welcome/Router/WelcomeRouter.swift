//
//  WelcomeRouter.swift
//  SampleProject
//
//  Created by Eugene Smolyakov on 28/02/2020.
//  Copyright © 2020 JendBy. All rights reserved.
//

import UIKit

final class WelcomeRouter {
}

// MARK: - : WelcomeRouterInput
extension WelcomeRouter: WelcomeRouterInput {
    func createTabbar(from vc: UIViewController) {
        TabBarModule.create().present(from: vc)
    }
}
