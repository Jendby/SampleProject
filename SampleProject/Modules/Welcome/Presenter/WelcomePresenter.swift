//
//  WelcomePresenter.swift
//  SampleProject
//
//  Created by Eugene Smolyakov on 28/02/2020.
//  Copyright © 2020 JendBy. All rights reserved.
//

import UIKit

enum WelcomeType: Int {
    case start = 0
    case phone
}

final class WelcomePresenter {

    weak var view: WelcomeViewInput!
    var interactor: WelcomeInteractorInput!
    var router: WelcomeRouterInput!
    weak var navigation: UINavigationController? = nil
    private var currentType:WelcomeType = .start
    let transitor = StartCoordinator()
}

// MARK: - WelcomeModuleInput
extension WelcomePresenter: WelcomeModuleInput {
    func install(in window: UIWindow!) {
        let nav = UINavigationController(rootViewController: view.viewController)
        nav.isNavigationBarHidden = true
        nav.delegate = transitor
        navigation = nav
        window.rootViewController = nav
    }
}

// MARK: - WelcomeViewOutput
extension WelcomePresenter: WelcomeViewOutput {
    func gradientBtnTapped() {
        switch currentType {
        case .phone:
            print("asd")
        case .start:
            currentType = .phone
            view.scrollToIndex(index: WelcomeType.phone.rawValue)
            view.createTelephoneView()
            view.changeAboutText(
                text: "This is a screen with entering a phone number".localized,
                fontSize: 20)
            view.changeGradientButtonText(text: "To get the code".localized)
        }
    }
    
    func bottomBtnTapped() {
//        TabBarerModule.create().present(from: self.view.viewController)
    }
    
    func firstAppear() {
        view.firstAppear()
    }
    
    func viewIsReady() {
        view.createFirstView()
        view.changeBottomButtonText(text: "Skip".localized)
        view.changeGradientButtonText(text: "Register".localized)
        view.changeAboutText(text: "This is a start screen with a little animation.".localized, fontSize: 30)
    }
}

// MARK: - WelcomeInteractorOutput
extension WelcomePresenter: WelcomeInteractorOutput {
}
