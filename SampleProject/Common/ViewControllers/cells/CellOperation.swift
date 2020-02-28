//
//  CellOperation.swift
//  SampleProject
//
//  Created by Eugene Smolyakov on 28/02/2020.
//  Copyright © 2020 ES. All rights reserved.
//


import Foundation

public enum CellOperation {
    case delete
}

public protocol CellOperationProtocol {
    func cellOperation(for indexPath: IndexPath) -> [CellOperation]
    func deleteCell(at indexPath: IndexPath)
}
