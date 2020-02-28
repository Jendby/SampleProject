//
//  StartTableModuleInput.swift
//  SampleProject
//
//  Created by Eugene Smolyakov on 28/02/2020.
//  Copyright © 2020 JendBy. All rights reserved.
//

import UIKit

protocol StartTableModuleInput {
    func present(from viewController: UIViewController)
    func present()
    func installIn(container view: UIView!, vc: UIViewController)
}
