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
        var mm = [StartTableModel]()
        for item in 0...15 {
            mm.append(StartTableModel(id: "\(item)",
                                      about: "Sample",
                                      theme: theme))
        }
        output?.fetched(models: mm)
    }
}
