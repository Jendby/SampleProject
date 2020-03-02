//
//  MotionTrackerService.swift
//  SampleProject
//
//  Created by Eugene Smolyakov on 02/03/2020.
//  Copyright © 2020 ES. All rights reserved.
//

import Foundation
import CoreMotion

protocol MotionTrackerServiceListener: class {
    var name: String { get }
    func changed(motion: CMDeviceMotion?, error: Error?)
}

protocol MotionTrackerService {
    func isAvailable() -> Bool
    func startTrackingFor(delegate: MotionTrackerServiceListener) -> Error?
    func stopTrackingFor(delegate: MotionTrackerServiceListener)
}
