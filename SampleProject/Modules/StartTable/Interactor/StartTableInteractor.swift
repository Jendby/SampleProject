//
//  StartTableInteractor.swift
//  SampleProject
//
//  Created by Eugene Smolyakov on 28/02/2020.
//  Copyright © 2020 JendBy. All rights reserved.
//

import UIKit

final class StartTableInteractor {
    weak var output: StartTableInteractorOutput?
}

// MARK: - StartTableInteractorInput
extension StartTableInteractor: StartTableInteractorInput  {
    func loadModels(with theme: Theme) {
        
        output?.fetched(models: [StartTableModel(id: "camera",
                                                 about: "Camera View",
                                                 theme: theme,
                                                 type: .cameraView),
                                 StartTableModel(id: "Sphere",
                                                 about: "Sphere View",
                                                 theme: theme,
                                                 type: .view360)])
    }
}

enum StartTableCellType {
    case cameraView
    case view360
}
