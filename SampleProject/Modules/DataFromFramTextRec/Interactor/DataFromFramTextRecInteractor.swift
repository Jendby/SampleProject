//
//  DataFromFramTextRecInteractor.swift
//  SampleProject
//
//  Created by Eugene Smolyakov on 26/03/2020.
//  Copyright © 2020 JendBy. All rights reserved.
//

import UIKit

final class DataFromFramTextRecInteractor {
    weak var output: DataFromFramTextRecInteractorOutput?
}

extension DataFromFramTextRecInteractor: DataFromFramTextRecInteractorInput {
	func loadModels(with theme: Theme) {
        output?.fetched(models: [DataFromFTRModel(id: "d",
                                                  phoneNumber: "",
                                                  topleft: "a",
                                                  btmright: "a",
                                                  theme: theme)])
	}
}
