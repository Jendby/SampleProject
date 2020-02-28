//
//  AboutTabModule.swift
//  SampleProject
//
//  Created by Eugene Smolyakov on 28/02/2020.
//  Copyright © 2020 JendBy. All rights reserved.
//

import UIKit

final class AboutTabModule {

    class func create() -> AboutTabModuleInput {
        let router = AboutTabRouter()

        let viewController = AboutTabViewController()

        let presenter = AboutTabPresenter()
        presenter.retained = viewController
        presenter.view = viewController
        presenter.router = router

        let interactor = AboutTabInteractor()
        interactor.output = presenter

        presenter.interactor = interactor
        viewController.output = presenter

        return presenter
    }

}
