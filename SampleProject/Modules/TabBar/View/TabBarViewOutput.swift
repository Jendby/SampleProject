//
//  TabBarViewOutput.swift
//  SampleProject
//
//  Created by Eugene Smolyakov on 29/02/2020.
//  Copyright © 2020 JendBy. All rights reserved.
//

import UIKit

protocol TabBarViewOutput {
    func viewIsReady()
    func loadViewOf(type: TabType, vc: UIViewController)
}
