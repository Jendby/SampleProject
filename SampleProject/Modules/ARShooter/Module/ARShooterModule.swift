//
//  ARShooterModule.swift
//  SampleProject
//
//  Created by Eugene Smolyakov on 27/03/2020.
//  Copyright © 2020 JendBy. All rights reserved.
//

import UIKit

final class ARShooterModule {

    class func create() -> ARShooterModuleInput {
        let router = ARShooterRouter()

        let viewController = ARShooterViewController()
        viewController.hidesBottomBarWhenPushed = true

        let presenter = ARShooterPresenter()
        presenter.retained = viewController
        presenter.view = viewController
        presenter.router = router

        let interactor = ARShooterInteractor()
        interactor.output = presenter

        presenter.interactor = interactor
        viewController.output = presenter

        return presenter
    }

}
