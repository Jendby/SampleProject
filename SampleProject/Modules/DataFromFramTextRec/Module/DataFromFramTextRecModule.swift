//
//  DataFromFramTextRecModule.swift
//  SampleProject
//
//  Created by Eugene Smolyakov on 26/03/2020.
//  Copyright © 2020 JendBy. All rights reserved.
//

import UIKit

final class DataFromFramTextRecModule {
    class func create() -> DataFromFramTextRecModuleInput {
        let router = DataFromFramTextRecRouter()

		let viewController = DataFromFramTextRecViewController()
		viewController.manualBuilding = true
		viewController.initializer = { tableview in
			let identifier = String(describing: DataFromFTRCell.self)
			tableview.register(UINib(nibName: identifier, bundle: nil),
																	forCellReuseIdentifier: identifier)
			tableview.allowsSelection = false
		}

        let presenter = DataFromFramTextRecPresenter()
		viewController.viewModel = presenter
		presenter.retained = viewController
        presenter.view = viewController
        presenter.router = router

        let interactor = DataFromFramTextRecInteractor()
        interactor.output = presenter

        presenter.interactor = interactor
        viewController.output = presenter

        return presenter
    }
}
