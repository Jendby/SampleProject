//
//  AboutTabViewController.swift
//  SampleProject
//
//  Created by Eugene Smolyakov on 28/02/2020.
//  Copyright © 2020 JendBy. All rights reserved.
//

import UIKit

final class AboutTabViewController: BaseViewController {
    var output: AboutTabViewOutput!

    // MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .red
        output.viewIsReady()
    }
}


// MARK: - AboutTabViewInput
extension AboutTabViewController: AboutTabViewInput {
    func setupInitialState() {
    }
}
