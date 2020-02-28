//
//  TabBarerModule.swift
//  SampleProject
//
//  Created by Eugene Smolyakov on 28/02/2020.
//  Copyright © 2020 JendBy. All rights reserved.
//

import UIKit

final class TabBarerModule {

    class func create() -> TabBarerModuleInput {
        let router = TabBarerRouter()

        let viewController = TabBarerViewController()
        
        let presenter = TabBarerPresenter()
        viewController.output = presenter
        presenter.router = router
        presenter.view = viewController

        let interactor = TabBarerInteractor()
        interactor.output = presenter

        presenter.interactor = interactor
        viewController.output = presenter

        return presenter
    }

}
