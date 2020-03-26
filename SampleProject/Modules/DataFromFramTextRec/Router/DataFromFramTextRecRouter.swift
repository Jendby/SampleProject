//
//  DataFromFramTextRecRouter.swift
//  SampleProject
//
//  Created by Eugene Smolyakov on 26/03/2020.
//  Copyright © 2020 JendBy. All rights reserved.
//

import UIKit

final class DataFromFramTextRecRouter { }

extension DataFromFramTextRecRouter: DataFromFramTextRecRouterInput {
    func createTextRecogniser(from vc:UIViewController) {
        FrameworkTextRecognModule.create().present(from: vc)
    }
}
