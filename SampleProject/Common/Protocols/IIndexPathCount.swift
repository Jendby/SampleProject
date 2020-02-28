//
//  IIndexPathCount.swift
//  SampleProject
//
//  Created by Eugene Smolyakov on 28/02/2020.
//  Copyright © 2020 ES. All rights reserved.
//


import Foundation

/// represents group of elements in table or collection views
/// starting from path and ending path.row + count elements
struct IIndexPathCount {
    let path: IndexPath
    let count: Int
    let animated: Bool
}
