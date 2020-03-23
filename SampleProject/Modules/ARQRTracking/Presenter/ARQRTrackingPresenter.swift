//
//  ARQRTrackingPresenter.swift
//  SampleProject
//
//  Created by Eugene Smolyakov on 23/03/2020.
//  Copyright © 2020 JendBy. All rights reserved.
//

import UIKit

final class ARQRTrackingPresenter {

    weak var view: ARQRTrackingViewInput!
    var interactor: ARQRTrackingInteractorInput!
    var router: ARQRTrackingRouterInput!
    var retained: UIViewController? = nil
}

// MARK: - ARQRTrackingModuleInput
extension ARQRTrackingPresenter: ARQRTrackingModuleInput {
	func present(from viewController: UIViewController) {
		self.view.present(from: viewController)
        retained = nil
	}

}

// MARK: - ARQRTrackingViewOutput
extension ARQRTrackingPresenter: ARQRTrackingViewOutput {
    func viewIsReady() {
    }
}

// MARK: - ARQRTrackingInteractorOutput
extension ARQRTrackingPresenter: ARQRTrackingInteractorOutput {
}
