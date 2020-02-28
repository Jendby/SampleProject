//
//  TabBarerPresenter.swift
//  SampleProject
//
//  Created by Eugene Smolyakov on 28/02/2020.
//  Copyright © 2020 JendBy. All rights reserved.
//

import UIKit

final class TabBarerPresenter {
    var output: TabBarerModuleOutput?
    private func commonInit() {
        view.setupInitialState(selected: 0)
    }

    weak var view: TabBarerViewInput!
    var interactor: TabBarerInteractorInput!
    var router: TabBarerRouterInput!
}

// MARK: - TabBarerModuleInput
extension TabBarerPresenter: TabBarerModuleInput {
    func present(from viewController: UIViewController) {
        if let nav = viewController.navigationController {
            nav.pushViewController(self.view.viewController, animated: true)
            commonInit()
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
extension TabBarerPresenter: TabBarerViewOutput {
    func viewIsReady() {
    }

    func loadViewOf(type: TabType, vc: UIViewController) {
//routers
    }
}

// MARK: - TabBarerInteractorOutput
extension TabBarerPresenter: TabBarerInteractorOutput {
}

