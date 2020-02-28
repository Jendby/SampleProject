//
//  ErrableOutput.swift
//  SampleProject
//
//  Created by Eugene Smolyakov on 28/02/2020.
//  Copyright © 2020 ES. All rights reserved.
//


import Foundation

protocol ErrableOutput {
    func handle(err: NSError)
}
