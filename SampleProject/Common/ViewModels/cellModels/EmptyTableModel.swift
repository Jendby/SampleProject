//
//  EmptyTableModel.swift
//  SampleProject
//
//  Created by Eugene Smolyakov on 28/02/2020.
//  Copyright © 2020 ES. All rights reserved.
//


import UIKit

struct EmptyTableModel: CommonCell {
    var id: String

    init() {
        id = ""
    }

    func setup(cell: UITableViewCell) {}
}
