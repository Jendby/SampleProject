//
//  DataFromFramTextRecRouterInput.swift
//  SampleProject
//
//  Created by Eugene Smolyakov on 26/03/2020.
//  Copyright © 2020 JendBy. All rights reserved.
//

import UIKit

protocol DataFromFramTextRecRouterInput {
    func createTextRecogniser(from vc:UIViewController, output: FrameworkTextRecognModuleOutput)
}
