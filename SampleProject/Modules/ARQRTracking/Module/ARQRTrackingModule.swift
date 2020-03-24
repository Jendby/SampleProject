//
//  ARQRTrackingModule.swift
//  SampleProject
//
//  Created by Eugene Smolyakov on 23/03/2020.
//  Copyright © 2020 JendBy. All rights reserved.
//

import UIKit

final class ARQRTrackingModule {

    class func create() -> ARQRTrackingModuleInput {
        let router = ARQRTrackingRouter()

        let viewController = ARQRTrackingViewController()
        viewController.hidesBottomBarWhenPushed = true

        let presenter = ARQRTrackingPresenter()
        presenter.retained = viewController
        presenter.view = viewController
        presenter.router = router

        let interactor = ARQRTrackingInteractor()
        interactor.output = presenter

        presenter.interactor = interactor
        viewController.output = presenter

        return presenter
    }

}
