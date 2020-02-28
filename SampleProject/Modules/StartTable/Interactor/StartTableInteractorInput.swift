//
//  StartTableInteractorInput.swift
//  SampleProject
//
//  Created by Eugene Smolyakov on 28/02/2020.
//  Copyright © 2020 JendBy. All rights reserved.
//

import UIKit

protocol StartTableInteractorInput: SingleSectionInteractorInput {
    var output: StartTableInteractorOutput? { get set }
}
