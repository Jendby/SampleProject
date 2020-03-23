//
//  ARImageTrackingPresenter.swift
//  SampleProject
//
//  Created by Eugene Smolyakov on 24/03/2020.
//  Copyright © 2020 JendBy. All rights reserved.
//

import UIKit

final class ARImageTrackingPresenter {

    weak var view: ARImageTrackingViewInput!
    var interactor: ARImageTrackingInteractorInput!
    var router: ARImageTrackingRouterInput!
    var retained: UIViewController? = nil
}

// MARK: - ARImageTrackingModuleInput
extension ARImageTrackingPresenter: ARImageTrackingModuleInput {
	func present(from viewController: UIViewController) {
        self.view.present(from: viewController)
        retained = nil
    }
}

// MARK: - ARImageTrackingViewOutput
extension ARImageTrackingPresenter: ARImageTrackingViewOutput {
    func viewIsReady() {
    }
}

// MARK: - ARImageTrackingInteractorOutput
extension ARImageTrackingPresenter: ARImageTrackingInteractorOutput {
}
