//
//  ARTableModuleInput.swift
//  SampleProject
//
//  Created by Eugene Smolyakov on 08/03/2020.
//  Copyright © 2020 JendBy. All rights reserved.
//

import UIKit

protocol ARTableModuleInput {
    func present(from viewController: UIViewController)
    func present()
    func installIn(container view: UIView!, vc: UIViewController)
}
