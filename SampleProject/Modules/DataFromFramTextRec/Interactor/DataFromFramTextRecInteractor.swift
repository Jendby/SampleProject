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
    var phones = [PhoneNumberWithCorner]()
}

extension DataFromFramTextRecInteractor: DataFromFramTextRecInteractorInput {
    func recognized(phones: [PhoneNumberWithCorner]) {
        self.phones = phones
    }
    
	func loadModels(with theme: Theme) {
        if phones.isEmpty {
            output?.fetched(models: [DataFromFTRModel(id: "empty",
                                                      phoneNumber: "",
                                                      topleft: "",
                                                      btmright: "",
                                                      theme: theme)])
        } else {
            var data = [DataFromFTRModel]()
            for item in phones {
                data.append(DataFromFTRModel(id: item.phoneNumber,
                                             phoneNumber: item.phoneNumber,
                                             topleft: item.topLeft,
                                             btmright: item.btmright,
                                             theme: theme))
            }
            output?.fetched(models: data)
        }
        
	}
}
