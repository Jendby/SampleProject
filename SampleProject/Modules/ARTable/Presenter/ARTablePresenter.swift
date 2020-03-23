//
//  ARTablePresenter.swift
//  SampleProject
//
//  Created by Eugene Smolyakov on 08/03/2020.
//  Copyright © 2020 JendBy. All rights reserved.
//

import UIKit
enum ARTableType {
    case cameraView
    case sphereScene
    case ARQRTracking
}

final class ARTablePresenter:SingleSectionPresenter {

    weak var view: ARTableViewInput!
    var interactor: ARTableInteractorInput!{
        didSet {
            source = interactor
            delegate = self
        }
    }
    var router: ARTableRouterInput!
    var retained: UIViewController? = nil
}

// MARK: - ARTableModuleInput
extension ARTablePresenter: ARTableModuleInput {
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

// MARK: - ARTableViewOutput
extension ARTablePresenter: ARTableViewOutput {
    func viewIsReady() {
    }
}

// MARK: - ARTableInteractorOutput
extension ARTablePresenter: ARTableInteractorOutput {
}

// MARK: - SingleSectionPresenterDelegate
extension ARTablePresenter: SingleSectionPresenterDelegate {
    func modelChanged(model: CellAnyModel, index: Int) {
        if let m = model as? ARTableModel {
            if m.type == .cameraView {
                router.cameraView(from: self.view.viewController)
            }
            if m.type == .sphereScene {
                router.createSphere(from: self.view.viewController)
            }
            if m.type == .ARQRTracking {
                router.ARQRTracking(from: self.view.viewController)
            }
        }
    }
}
