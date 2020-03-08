//
//  ARTableInteractorInput.swift
//  SampleProject
//
//  Created by Eugene Smolyakov on 08/03/2020.
//  Copyright © 2020 JendBy. All rights reserved.
//

import UIKit

protocol ARTableInteractorInput:SingleSectionInteractorInput {
    var output: ARTableInteractorOutput? { get set }
}
