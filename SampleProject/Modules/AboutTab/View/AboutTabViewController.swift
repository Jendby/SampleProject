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
    var textLabel: UILabel!

    // MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = theme.zbright_aqua
        
        textLabel = UILabel()
        textLabel.numberOfLines = 0
        textLabel.lineBreakMode = .byWordWrapping
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(textLabel)
        self.view.addConstraints([
            textLabel.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            textLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            textLabel.heightAnchor.constraint(equalTo: self.view.heightAnchor, constant: -300),
            textLabel.widthAnchor.constraint(equalTo: self.view.widthAnchor, constant: -100)])
        output.viewIsReady()
    }
    
    private func animateLabel(text: String) {
        let characters = text.map { $0 }
        var index = 0
        textLabel.text = ""
 
        Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true, block: { [weak self] timer in
            guard let `self` = self else { return }
            if index < text.count {
                let char = characters[index]
                self.textLabel.text?.append(char)
                index += 1
            } else {
                timer.invalidate()
            }
        })
    }
}


// MARK: - AboutTabViewInput
extension AboutTabViewController: AboutTabViewInput {
    func setupInitialState(text: String) {
        animateLabel(text: text)
    }
}
