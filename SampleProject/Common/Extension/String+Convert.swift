//
//  String+Convert.swift
//  SampleProject
//
//  Created by Eugene Smolyakov on 07/03/2020.
//  Copyright © 2020 ES. All rights reserved.
//

import Foundation

extension String {
    var toDouble: Double {
        return Double(self) ?? 0.0
    }
}

extension String {
    var toInt: Int {
        return Int(self) ?? 0
    }
}

extension String {
    var toUInt: UInt {
        return UInt(self) ?? 0
    }
}
