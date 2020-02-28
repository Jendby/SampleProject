//
//  TabBarModule.swift
//  SampleProject
//
//  Created by Eugene Smolyakov on 29/02/2020.
//  Copyright © 2020 JendBy. All rights reserved.
//

import UIKit

final class TabBarModule {

    class func create() -> TabBarModuleInput {
        let router = TabBarRouter()

        let viewController = TabBarViewController()
        let presenter = TabBarPresenter()
        viewController.output = presenter
        presenter.router = router
        presenter.view = viewController

        let interactor = TabBarInteractor()
        interactor.output = presenter

        presenter.interactor = interactor
        viewController.output = presenter

        return presenter
    }

}
