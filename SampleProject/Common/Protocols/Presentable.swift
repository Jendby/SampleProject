//
//  Presentable.swift
//  SampleProject
//
//  Created by Eugene Smolyakov on 28/02/2020.
//  Copyright © 2020 ES. All rights reserved.
//


import UIKit
import PanModal

protocol Presentable: AlertProtocol {

    var viewController: UIViewController { get }

    func presentAsNavController()
    func presentAsNavController(from viewController: UIViewController)
    func presentAsNavController(from viewController: UIViewController, animated: Bool)

    func present(from viewController: UIViewController)
    func presentModally(from viewController: UIViewController, completion: (() -> Void)?)
    func showInContainer(container: UIView, in viewController: UIViewController)

    // Сюда добавляются методы по необходимости, например dismiss или showInContainer
    func dismissAsNavController()
}

extension Presentable where Self: UIViewController {

    var viewController: UIViewController {
        return self
    }

    func presentAsNavController() {
        let navigation = UINavigationController(rootViewController: viewController)

        if Const.Devices.iPad {
            navigation.modalPresentationStyle = .formSheet
            navigation.preferredContentSize = Const.Sizes.iPadContentSize
        }

        // Config nav bar
        navigation.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigation.navigationBar.shadowImage = UIImage()
        navigation.navigationBar.isTranslucent = true
        navigation.navigationBar.backgroundColor = .clear

        SceneDelegate.currentWindow.rootViewController = navigation
    }

    func presentAsNavController(from viewController: UIViewController) {
        presentAsNavController(from: viewController, animated: true)
    }

    func presentAsNavController(from viewController: UIViewController, animated: Bool) {
        UINavigationController.present(from: viewController, rootVC: self, animated: true)
    }

    func present(from viewController: UIViewController) {
        viewController.navigationController?.pushViewController(self, animated: true)
    }
    
    func presentModally(from viewController: UIViewController, completion: (() -> Void)?) {
        viewController.present(self, animated: true, completion: completion)
    }

    func showInContainer(container: UIView, in viewController: UIViewController) {

        self.view.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(self.view)

        self.view.topAnchor.constraint(equalTo: container.topAnchor).isActive = true
        self.view.leadingAnchor.constraint(equalTo: container.leadingAnchor).isActive = true
        self.view.trailingAnchor.constraint(equalTo: container.trailingAnchor).isActive = true
        let bottomConstraint = self.view.bottomAnchor.constraint(equalTo: container.bottomAnchor)
        bottomConstraint.priority = UILayoutPriority(900)
        bottomConstraint.isActive = true

        viewController.addChild(self)
        self.didMove(toParent: viewController)
    }

    func dismissAsNavController() {
        viewController.navigationController?.dismiss(animated: true, completion: nil)
    }
}
