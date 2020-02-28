//
//  WelcomeModule.swift
//  SampleProject
//
//  Created by Eugene Smolyakov on 28/02/2020.
//  Copyright © 2020 JendBy. All rights reserved.
//

import UIKit

final class WelcomeModule {

    class func create() -> WelcomeModuleInput {
        let router = WelcomeRouter()

        let viewController = WelcomeViewController.create()

        let presenter = WelcomePresenter()
        presenter.view = viewController
        presenter.router = router

        let interactor = WelcomeInteractor()
        interactor.output = presenter

        presenter.interactor = interactor
        viewController.output = presenter

        return presenter
    }

}
