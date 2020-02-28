//
//  WelcomePresenter.swift
//  SampleProject
//
//  Created by Eugene Smolyakov on 28/02/2020.
//  Copyright © 2020 JendBy. All rights reserved.
//

import UIKit

final class WelcomePresenter {

    weak var view: WelcomeViewInput!
    var interactor: WelcomeInteractorInput!
    var router: WelcomeRouterInput!
}

// MARK: - WelcomeModuleInput
extension WelcomePresenter: WelcomeModuleInput {
	func present(from viewController: UIViewController) {
		// TODO: add me
	}

	func present() {
		// TODO: add me
	}
}

// MARK: - WelcomeViewOutput
extension WelcomePresenter: WelcomeViewOutput {
    func viewIsReady() {
    }
}

// MARK: - WelcomeInteractorOutput
extension WelcomePresenter: WelcomeInteractorOutput {
}
