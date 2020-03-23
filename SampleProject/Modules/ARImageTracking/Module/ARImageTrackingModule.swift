//
//  ARImageTrackingModule.swift
//  SampleProject
//
//  Created by Eugene Smolyakov on 24/03/2020.
//  Copyright © 2020 JendBy. All rights reserved.
//

import UIKit

final class ARImageTrackingModule {

    class func create() -> ARImageTrackingModuleInput {
        let router = ARImageTrackingRouter()

        let viewController = ARImageTrackingViewController()

        let presenter = ARImageTrackingPresenter()
        presenter.retained = viewController
        presenter.view = viewController
        presenter.router = router

        let interactor = ARImageTrackingInteractor()
        interactor.output = presenter

        presenter.interactor = interactor
        viewController.output = presenter

        return presenter
    }

}
