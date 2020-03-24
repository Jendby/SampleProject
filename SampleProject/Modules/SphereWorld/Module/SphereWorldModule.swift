//
//  SphereWorldModule.swift
//  SampleProject
//
//  Created by Eugene Smolyakov on 02/03/2020.
//  Copyright © 2020 JendBy. All rights reserved.
//

import UIKit

final class SphereWorldModule {

    class func create() -> SphereWorldModuleInput {
        let router = SphereWorldRouter()

        let viewController = SphereWorldViewController()
        viewController.hidesBottomBarWhenPushed = true

        let presenter = SphereWorldPresenter(motionTracker: ServicesAssembler.inject())
        presenter.retained = viewController
        presenter.view = viewController
        presenter.router = router

        let interactor = SphereWorldInteractor()
        interactor.output = presenter

        presenter.interactor = interactor
        viewController.output = presenter

        return presenter
    }

}
