//
//  FrameworkTextRecognViewController.swift
//  SampleProject
//
//  Created by Eugene Smolyakov on 26/03/2020.
//  Copyright © 2020 JendBy. All rights reserved.
//

import UIKit

final class FrameworkTextRecognViewController: BaseViewController {
    var output: FrameworkTextRecognViewOutput!
    
    // MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .black
        output.viewIsReady()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        output.viewDidAppear()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        output.viewWillDisappea()
        
    }
}


// MARK: - FrameworkTextRecognViewInput
extension FrameworkTextRecognViewController: FrameworkTextRecognViewInput {
    func attach(view: UIView) {
        self.view.attachConnectedToBorders(view: view)
    }
    
    func setupInitialState() {
    }
    
    func deattach() {
        for v in self.view.subviews {
            v.removeFromSuperview()
        }
    }
}

