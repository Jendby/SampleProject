//
//  FrameworkTextRecognPresenter.swift
//  SampleProject
//
//  Created by Eugene Smolyakov on 26/03/2020.
//  Copyright © 2020 JendBy. All rights reserved.
//

import UIKit
#if !targetEnvironment(simulator)
import SampleFramework
#endif

final class FrameworkTextRecognPresenter {
    var output: FrameworkTextRecognModuleOutput? = nil
    weak var view: FrameworkTextRecognViewInput!
    var interactor: FrameworkTextRecognInteractorInput!
    var router: FrameworkTextRecognRouterInput!
    var retained: UIViewController? = nil
    #if !targetEnvironment(simulator)
    var vc: SViewController? = nil
    #endif
}

// MARK: - FrameworkTextRecognModuleInput
extension FrameworkTextRecognPresenter: FrameworkTextRecognModuleInput {
	func present(from viewController: UIViewController) {
		self.view.present(from: viewController)
        retained = nil
	}
}

// MARK: - FrameworkTextRecognViewOutput
extension FrameworkTextRecognPresenter: FrameworkTextRecognViewOutput {
    func viewIsReady() {
    }
    
    func viewDidAppear() {
        #if !targetEnvironment(simulator)
        vc = SViewController()
        vc?.sdelegate = self
        view.attach(view: vc!.view)
        #else
        view.show(error: "zzz")
        #endif
    }
    func viewWillDisappea() {
        #if !targetEnvironment(simulator)
        view.deattach()
        vc = nil
        #endif
    }
}

// MARK: - FrameworkTextRecognInteractorOutput
extension FrameworkTextRecognPresenter: FrameworkTextRecognInteractorOutput {
}
#if !targetEnvironment(simulator)
// MARK: - SampleFrameworkDelegate
extension FrameworkTextRecognPresenter: SampleFrameworkDelegate {
    func getPhoneNumbers(numbers: [[String : String]]) {
        var data = [PhoneNumberWithCorner]()
        for item in numbers {
            data.append(
                PhoneNumberWithCorner(phoneNumber: item["phone"] ?? "",
                                      topLeft: item["topleft"] ?? "",
                                      btmright: item["botright"] ?? ""))
        }
        output?.recognized(phones: data)
    }
}
#endif
