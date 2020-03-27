//
//  ARShooterPresenter.swift
//  SampleProject
//
//  Created by Eugene Smolyakov on 27/03/2020.
//  Copyright © 2020 JendBy. All rights reserved.
//

import UIKit

final class ARShooterPresenter {

    weak var view: ARShooterViewInput!
    var interactor: ARShooterInteractorInput!
    var router: ARShooterRouterInput!
    var retained: UIViewController? = nil
}

// MARK: - ARShooterModuleInput
extension ARShooterPresenter: ARShooterModuleInput {
	func present(from viewController: UIViewController) {
		self.view.present(from: viewController)
        retained = nil
	}

}

// MARK: - ARShooterViewOutput
extension ARShooterPresenter: ARShooterViewOutput {
    func viewIsReady() {
    }
}

// MARK: - ARShooterInteractorOutput
extension ARShooterPresenter: ARShooterInteractorOutput {
}
