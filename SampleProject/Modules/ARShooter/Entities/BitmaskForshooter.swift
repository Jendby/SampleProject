//
//  BitmaskForshooter.swift
//  SampleProject
//
//  Created by Eugene Smolyakov on 27/03/2020.
//  Copyright © 2020 ES. All rights reserved.
//

struct BitMaskCategory {
    
    static let none  = 0 << 0 // 00000000...0  0
    static let box   = 1 << 0 // 00000000...1  1
    static let bullet = 1 << 1 // 0000000...10  2
}
