//
//  TabBarRouter.swift
//  SampleProject
//
//  Created by Eugene Smolyakov on 29/02/2020.
//  Copyright © 2020 JendBy. All rights reserved.
//

import UIKit

final class TabBarRouter {
}

// MARK: - : TabBarRouterInput
extension TabBarRouter: TabBarRouterInput {
    func createAbout(_ vc:UIViewController) {
        AboutTabModule.create().installIn(container: vc.view, vc: vc)
    }
    func createTable(_ vc:UIViewController) {
        StartTableModule.create().installIn(container: vc.view, vc: vc)
    }
}
