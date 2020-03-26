//
//  FrameworkTextRecognModule.swift
//  SampleProject
//
//  Created by Eugene Smolyakov on 26/03/2020.
//  Copyright © 2020 JendBy. All rights reserved.
//

import UIKit

final class FrameworkTextRecognModule {

    class func create(output: FrameworkTextRecognModuleOutput) -> FrameworkTextRecognModuleInput {
        let router = FrameworkTextRecognRouter()

        let viewController = FrameworkTextRecognViewController()
        viewController.hidesBottomBarWhenPushed = true

        let presenter = FrameworkTextRecognPresenter()
        presenter.retained = viewController
        presenter.view = viewController
        presenter.router = router
        presenter.output = output

        let interactor = FrameworkTextRecognInteractor()
        interactor.output = presenter

        presenter.interactor = interactor
        viewController.output = presenter

        return presenter
    }

}
