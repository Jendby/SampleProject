//
//  SphereWorldViewOutput.swift
//  SampleProject
//
//  Created by Eugene Smolyakov on 02/03/2020.
//  Copyright © 2020 JendBy. All rights reserved.
//

import UIKit

protocol SphereWorldViewOutput {
    func viewIsReady()
    func back360attached()
    func navBtnTapped()
    func stopTracking()
}
