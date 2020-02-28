//
//  UINavigationController + Common.swift
//  SampleProject
//
//  Created by Eugene Smolyakov on 28/02/2020.
//  Copyright © 2020 ES. All rights reserved.
//


import UIKit

extension UINavigationController {
    open override var preferredStatusBarStyle: UIStatusBarStyle {
        return topViewController?.preferredStatusBarStyle ?? .default
    }
    
    static func present(from vc: UIViewController, rootVC: UIViewController, animated: Bool, completion: (() -> Void)? = nil) {
        let nvc = UINavigationController(rootViewController: rootVC)
        if Const.Devices.iPad {
            nvc.modalPresentationStyle = .formSheet
            nvc.preferredContentSize = Const.Sizes.iPadContentSize
        }
        vc.present(nvc, animated: animated, completion: completion)
    }
}
