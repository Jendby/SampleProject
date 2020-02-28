//
//  StartTableModule.swift
//  SampleProject
//
//  Created by Eugene Smolyakov on 28/02/2020.
//  Copyright © 2020 JendBy. All rights reserved.
//

import UIKit

final class StartTableModule {

    class func create() -> StartTableModuleInput {
        let router = StartTableRouter()

        let viewController = StartTableViewController()
        viewController.manualBuilding = true
        viewController.initializer = { tableview in
            let identifier = String(describing: StartTableCell.self)
            tableview.register(UINib(nibName: identifier, bundle: nil),
                               forCellReuseIdentifier: identifier)
        }

        let presenter = StartTablePresenter()
        presenter.retained = viewController
        presenter.view = viewController
        presenter.router = router

        let interactor = StartTableInteractor()
        interactor.output = presenter

        presenter.interactor = interactor
        viewController.output = presenter
        viewController.viewModel = presenter

        return presenter
    }

}
