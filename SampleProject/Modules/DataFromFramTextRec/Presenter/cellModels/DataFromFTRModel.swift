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
        if phoneNumber == "" && topleft == "" && btmright == "" {
            cell.phoneNumber.text = "Empty, try to find one".localized
            cell.phoneNumber.font = theme.boldFont.withSize(30)
            cell.topLeft.text = ""
            cell.btmright.text = ""
        } else {
            cell.phoneNumber.text = "Phone: " + phoneNumber
            cell.phoneNumber.font = theme.boldFont.withSize(30)
            cell.topLeft.text = "topleft: " + topleft
            cell.btmright.text = "btmright: " + btmright
        }
    }
}
