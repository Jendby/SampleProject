//
//  StartTablePresenter.swift
//  SampleProject
//
//  Created by Eugene Smolyakov on 28/02/2020.
//  Copyright © 2020 JendBy. All rights reserved.
//

import UIKit

final class StartTablePresenter: SingleSectionPresenter {

    weak var view: StartTableViewInput!
    var interactor: StartTableInteractorInput! {
        didSet {
            source = interactor
            delegate = self
        }
    }
    var router: StartTableRouterInput!
    var retained: UIViewController? = nil
}

// MARK: - StartTableModuleInput
extension StartTablePresenter: StartTableModuleInput {
	func present(from viewController: UIViewController) {
		// TODO: add me
	}

	func present() {
		// TODO: add me
	}
    func installIn(container view: UIView!, vc: UIViewController) {
        self.view.showInContainer(container: view, in: vc)
        retained = nil
    }
}

// MARK: - StartTableViewOutput
extension StartTablePresenter: StartTableViewOutput {
    func viewIsReady() {
    }
}

// MARK: - StartTableInteractorOutput
extension StartTablePresenter: StartTableInteractorOutput {
    func handle(err: NSError) {
        view.hideBusyIndicator()
        view.handle(error: err)
    }
}

// MARK: - SingleSectionPresenterDelegate
extension StartTablePresenter: SingleSectionPresenterDelegate {
    func modelChanged(model: CellAnyModel, index: Int) {
        
    }
}
