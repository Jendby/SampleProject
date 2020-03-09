//
//  AboutTabModuleInput.swift
//  SampleProject
//
//  Created by Eugene Smolyakov on 28/02/2020.
//  Copyright © 2020 JendBy. All rights reserved.
//

import UIKit

protocol AboutTabModuleInput {
    func present(from viewController: UIViewController, withText text:String)
    func present()
    func installIn(container view: UIView!, vc: UIViewController)
}
