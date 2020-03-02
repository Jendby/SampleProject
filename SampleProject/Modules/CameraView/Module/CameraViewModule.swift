//
//  CameraViewModule.swift
//  SampleProject
//
//  Created by Eugene Smolyakov on 02/03/2020.
//  Copyright © 2020 JendBy. All rights reserved.
//

import UIKit

final class CameraViewModule {

    class func create() -> CameraViewModuleInput {
        let router = CameraViewRouter()

        let viewController = CameraViewViewController()

        let presenter = CameraViewPresenter(camConnectService: ServicesAssembler.inject())
        presenter.retained = viewController
        presenter.view = viewController
        presenter.router = router

        let interactor = CameraViewInteractor()
        interactor.output = presenter

        presenter.interactor = interactor
        viewController.output = presenter

        return presenter
    }

}
