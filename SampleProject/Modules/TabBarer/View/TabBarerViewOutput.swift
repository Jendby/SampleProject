//
//  TabBarerViewOutput.swift
//  SampleProject
//
//  Created by Eugene Smolyakov on 28/02/2020.
//  Copyright © 2020 JendBy. All rights reserved.
//

import UIKit

protocol TabBarerViewOutput {
    func viewIsReady()
    func loadViewOf(type: TabType, vc: UIViewController)
}
