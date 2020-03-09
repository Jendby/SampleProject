//
//  StartTableCellModel.swift
//  SampleProject
//
//  Created by Eugene Smolyakov on 28/02/2020.
//  Copyright © 2020 ES. All rights reserved.
//

import UIKit

protocol StartTableCellModel: CommonCell { }

struct StartTableModel: StartTableCellModel{
    var id: String
    let about: String
    let body: String
    let theme: Theme
    
    func setup(cell: StartTableCell) {
        
        cell.about.font = theme.regularFont.withSize(theme.sz.small0)
        cell.about.textColor = theme.ztomato
        cell.about.text = about
        
        cell.myview.layer.cornerRadius = 25
        cell.myview.clipsToBounds = true
        cell.myview.backgroundColor = randomColor()
    }
}
