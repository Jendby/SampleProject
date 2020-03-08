//
//  ARTableCellModel.swift
//  SampleProject
//
//  Created by Eugene Smolyakov on 08/03/2020.
//  Copyright © 2020 ES. All rights reserved.
//

import UIKit

protocol ARTableCellModel: CommonCell { }

struct ARTableModel: ARTableCellModel{
    var id: String
    let about: String
    let theme: Theme
    let type: ARTableType
    
    
    func setup(cell: ARTableCell) {
        cell.textLabel?.text = about
    }
}
