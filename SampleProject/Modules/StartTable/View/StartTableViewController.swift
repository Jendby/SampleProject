//
//  StartTableViewController.swift
//  SampleProject
//
//  Created by Eugene Smolyakov on 28/02/2020.
//  Copyright © 2020 JendBy. All rights reserved.
//

import UIKit

final class StartTableViewController: BaseTableViewController {
    var output: StartTableViewOutput!

    // MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableview.backgroundColor = .clear
        self.view.backgroundColor = .clear
        let item = UIBarButtonItem(title: "Список", style: .plain, target: self, action: nil)
        navigationItem.rightBarButtonItem = item
        output.viewIsReady()
    }
}


// MARK: - StartTableViewInput
extension StartTableViewController: StartTableViewInput {
    func setupInitialState() {
    }
}
