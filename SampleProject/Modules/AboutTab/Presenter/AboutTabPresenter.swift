//
//  AboutTabPresenter.swift
//  SampleProject
//
//  Created by Eugene Smolyakov on 28/02/2020.
//  Copyright © 2020 JendBy. All rights reserved.
//

import UIKit

final class AboutTabPresenter {

    weak var view: AboutTabViewInput!
    var interactor: AboutTabInteractorInput!
    var router: AboutTabRouterInput!
    var retained: UIViewController? = nil
    private var bodyText: String!
}

// MARK: - AboutTabModuleInput
extension AboutTabPresenter: AboutTabModuleInput {
	func present(from viewController: UIViewController, withText text:String) {
        bodyText = text
        self.view.present(from: viewController)
        retained = nil
	}

	func present() {
		// TODO: add me
	}
    func installIn(container view: UIView!, vc: UIViewController) {
        self.view.showInContainer(container: view, in: vc)
        retained = nil
    }
}

// MARK: - AboutTabViewOutput
extension AboutTabPresenter: AboutTabViewOutput {
    func viewIsReady() {
        self.view.setupInitialState(text: bodyText)
    }
}

// MARK: - AboutTabInteractorOutput
extension AboutTabPresenter: AboutTabInteractorOutput {
}
