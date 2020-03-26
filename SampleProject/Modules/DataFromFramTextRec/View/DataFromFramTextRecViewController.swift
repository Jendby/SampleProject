//
//  DataFromFramTextRecViewController.swift
//  SampleProject
//
//  Created by Eugene Smolyakov on 26/03/2020.
//  Copyright © 2020 JendBy. All rights reserved.
//

import UIKit

final class DataFromFramTextRecViewController: BaseTableViewController {
    var output: DataFromFramTextRecViewOutput!
    
    // MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        let rItem = UIBarButtonItem(title: "Scan", style: .plain, target: self, action: #selector(tItemTapped))
        navigationItem.rightBarButtonItem = rItem
        output.viewIsReady()
    }
    
    @objc func tItemTapped() {
        output.navtouched()
    }
}

// MARK: - DataFromFramTextRecViewInput
extension DataFromFramTextRecViewController: DataFromFramTextRecViewInput {
    func setupInitialState() {
    }
}
