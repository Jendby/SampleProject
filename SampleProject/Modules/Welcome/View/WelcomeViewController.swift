//
//  WelcomeViewController.swift
//  SampleProject
//
//  Created by Eugene Smolyakov on 28/02/2020.
//  Copyright © 2020 JendBy. All rights reserved.
//

import UIKit

final class WelcomeViewController: BaseViewController {
    var output: WelcomeViewOutput!

    // MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        output.viewIsReady()
    }
}


// MARK: - WelcomeViewInput
extension WelcomeViewController: WelcomeViewInput {
    func setupInitialState() {
    }
}

extension WelcomeViewController: ViewControllerable {
    static var storyBoardName: String {
        return "Welcome"
    }
}
