//
//  TabBarPresenter.swift
//  SampleProject
//
//  Created by Eugene Smolyakov on 29/02/2020.
//  Copyright © 2020 JendBy. All rights reserved.
//

import UIKit

final class TabBarPresenter {
    var output: TabBarModuleOutput?


    weak var view: TabBarViewInput!
    var interactor: TabBarInteractorInput!
    var router: TabBarRouterInput!
}

// MARK: - TabBarerModuleInput
extension TabBarPresenter: TabBarModuleInput {
    func present(from viewController: UIViewController) {
        if let nav = viewController.navigationController {
            nav.pushViewController(self.view.viewController, animated: true)
            view.setupInitialState(selected: 4)
            delay(0.5) {
                // get rid of all other vcs:
                nav.setViewControllers([nav.viewControllers.last!], animated: false)
            }
        } else {
            fatalError("Tab bar should be used from navigation controller!")
        }
    }
}

// MARK: - TabBarerModuleInput
extension TabBarPresenter: TabBarViewOutput {
    func viewIsReady() {
    }

    func loadViewOf(type: TabType, vc: UIViewController) {
        if type == .json {
            router.createTable(vc)
        }
        if type == .ARTable {
            router.createAR(vc)
        }
//routers
    }
}

// MARK: - TabBarerInteractorOutput
extension TabBarPresenter: TabBarInteractorOutput {
}
