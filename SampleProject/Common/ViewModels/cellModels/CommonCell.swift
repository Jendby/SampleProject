//
//  CommonCell.swift
//  SampleProject
//
//  Created by Eugene Smolyakov on 28/02/2020.
//  Copyright © 2020 ES. All rights reserved.
//


import UIKit

protocol CommonCell: CellAnyModel {
    associatedtype CellType: UIView
    func setup(cell: CellType)
}

extension CommonCell {
    static var CellAnyType: UIView.Type {
        return CellType.self
    }
    func setupAny(cell: UIView) {
        if let c = cell as? CellType {
            setup(cell: c)
        }
    }
}
