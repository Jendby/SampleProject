//
//  CamConnectService.swift
//  SampleProject
//
//  Created by Eugene Smolyakov on 02/03/2020.
//  Copyright © 2020 ES. All rights reserved.
//

import Foundation
import AVFoundation

protocol CamConnectServiceListener: class {
    var nameForImageFromCamera: String { get }
    func changed(layer: AVCaptureVideoPreviewLayer?)
}

protocol CamConnectService {
    func startCameraFor(delegate: CamConnectServiceListener) -> String?
    func stopCameraFor(delegate: CamConnectServiceListener)
}
