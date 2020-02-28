//
//  CellAnyModel.swift
//  SampleProject
//
//  Created by Eugene Smolyakov on 28/02/2020.
//  Copyright © 2020 ES. All rights reserved.
//


import UIKit

protocol CellAnyModel: CommonCellModel {
    static var CellAnyType: UIView.Type { get }
    func setupAny(cell: UIView)
}
