//
//  DataFromFramTextRecPresenter.swift
//  SampleProject
//
//  Created by Eugene Smolyakov on 26/03/2020.
//  Copyright © 2020 JendBy. All rights reserved.
//

import UIKit

final class DataFromFramTextRecPresenter: SingleSectionPresenter {
    weak var view: DataFromFramTextRecViewInput!
	var interactor: DataFromFramTextRecInteractorInput! {
		didSet {
			source = interactor
		}
	}
	var retained: UIViewController? = nil
    var router: DataFromFramTextRecRouterInput!
    
    override func getContents() {
        source?.loadModels(with: theme)
    }
}

// MARK: - DataFromFramTextRecModuleInput
extension  DataFromFramTextRecPresenter: DataFromFramTextRecModuleInput {
	func present(from viewController: UIViewController) {
        self.view.present(from: viewController)
        retained = nil
	}
}

// MARK: - DataFromFramTextRecViewOutput
extension  DataFromFramTextRecPresenter: DataFromFramTextRecViewOutput {
    func viewIsReady() {
    }
    func navtouched() {
        router.createTextRecogniser(from: self.view.viewController,
                                    output: self)
    }
}

// MARK: - DataFromFramTextRecInteractorOutput
extension  DataFromFramTextRecPresenter: DataFromFramTextRecInteractorOutput {
}
// MARK: - FrameworkTextRecognModuleOutput
extension  DataFromFramTextRecPresenter: FrameworkTextRecognModuleOutput {
    func recognized(phones: [PhoneNumberWithCorner]) {
        interactor.recognized(phones: phones)
        self.refreshContents()
    }
}
