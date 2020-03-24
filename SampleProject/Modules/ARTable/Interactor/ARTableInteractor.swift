//
//  ARTableInteractor.swift
//  SampleProject
//
//  Created by Eugene Smolyakov on 08/03/2020.
//  Copyright © 2020 JendBy. All rights reserved.
//

import UIKit

final class ARTableInteractor {
    weak var output: ARTableInteractorOutput?
}

// MARK: - ARTableInteractorInput
extension ARTableInteractor: ARTableInteractorInput  {
    func loadModels(with theme: Theme) {
        output?.fetched(models:[
            ARTableModel(id: "360 camera view",
                         about: "360 camera view",
                         theme: theme,
                         type: .cameraView),
            ARTableModel(id: "360 sphere scene",
                         about: "360 sphere scene",
                         theme: theme,
                         type: .sphereScene),
            ARTableModel(id: "ARQRTracking",
                         about: "QR Tracking",
                         theme: theme,
                         type: .ARQRTracking),
            ARTableModel(id: "ImageTracking",
                         about: "Image Tracking",
                         theme: theme,
                         type: .ARImageTracking)])
    }
    
}
