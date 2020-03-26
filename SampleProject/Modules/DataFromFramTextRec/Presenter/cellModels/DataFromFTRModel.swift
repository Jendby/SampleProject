//
//  DataFromFTRModel.swift
//  SampleProject
//
//  Created by Eugene Smolyakov on 26/03/2020.
//  Copyright © 2020 ES. All rights reserved.
//

import UIKit

protocol DataFromFTRCellModel: CommonCell { }

struct DataFromFTRModel: DataFromFTRCellModel{
    var id: String
    let phoneNumber: String
    let topleft: String
    let btmright: String
    let theme: Theme
    
    func setup(cell: DataFromFTRCell) {
        cell.phoneNumber.text = phoneNumber
        cell.topLeft.text = topleft
        cell.btmright.text = btmright
    }
}
