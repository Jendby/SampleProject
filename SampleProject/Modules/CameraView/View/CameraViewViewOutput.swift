//
//  CameraViewViewOutput.swift
//  SampleProject
//
//  Created by Eugene Smolyakov on 02/03/2020.
//  Copyright © 2020 JendBy. All rights reserved.
//

import UIKit

protocol CameraViewViewOutput {
    func viewIsReady()
    func videoFromCameraAttached()
    func navBtnTapped()
    func stopTracking()
}
