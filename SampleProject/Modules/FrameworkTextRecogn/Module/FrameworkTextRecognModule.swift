//
//  FrameworkTextRecognModule.swift
//  SampleProject
//
//  Created by Eugene Smolyakov on 26/03/2020.
//  Copyright © 2020 JendBy. All rights reserved.
//

import UIKit

final class FrameworkTextRecognModule {

    class func create() -> FrameworkTextRecognModuleInput {
        let router = FrameworkTextRecognRouter()

        let viewController = FrameworkTextRecognViewController()

        let presenter = FrameworkTextRecognPresenter()
        presenter.retained = viewController
        presenter.view = viewController
        presenter.router = router

        let interactor = FrameworkTextRecognInteractor()
        interactor.output = presenter

        presenter.interactor = interactor
        viewController.output = presenter

        return presenter
    }

}
