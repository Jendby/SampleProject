//
//  ARTableModule.swift
//  SampleProject
//
//  Created by Eugene Smolyakov on 08/03/2020.
//  Copyright © 2020 JendBy. All rights reserved.
//

import UIKit

final class ARTableModule {

    class func create() -> ARTableModuleInput {
        let router = ARTableRouter()

        let viewController = ARTableViewController()
        viewController.manualBuilding = true
        viewController.initializer = { tableview in
            let identifier = String(describing: ARTableCell.self)
            tableview.register(UINib(nibName: identifier, bundle: nil),
                               forCellReuseIdentifier: identifier)
        }

        let presenter = ARTablePresenter()
        presenter.retained = viewController
        presenter.view = viewController
        presenter.router = router

        let interactor = ARTableInteractor()
        interactor.output = presenter

        presenter.interactor = interactor
        viewController.output = presenter
        viewController.viewModel = presenter

        return presenter
    }

}
