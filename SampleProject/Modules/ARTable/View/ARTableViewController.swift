//
//  ARTableViewController.swift
//  SampleProject
//
//  Created by Eugene Smolyakov on 08/03/2020.
//  Copyright © 2020 JendBy. All rights reserved.
//

import UIKit

final class ARTableViewController: BaseTableViewController {
    var output: ARTableViewOutput!

    // MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "AR"
        output.viewIsReady()
    }
}


// MARK: - ARTableViewInput
extension ARTableViewController: ARTableViewInput {
    func setupInitialState() {
    }
}
