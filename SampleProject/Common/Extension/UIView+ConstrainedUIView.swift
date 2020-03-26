//
//  UIView+ConstrainedUIView.swift
//  SampleProject
//
//  Created by Eugene Smolyakov on 26/03/2020.
//  Copyright © 2020 ES. All rights reserved.
//

import UIKit

extension UIView {
    func attachConnectedToBorders(view: UIView) {
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        addConstraints([view.topAnchor.constraint(equalTo: topAnchor),
                        view.leadingAnchor.constraint(equalTo: leadingAnchor),
                        view.trailingAnchor.constraint(equalTo: trailingAnchor),
                        view.bottomAnchor.constraint(equalTo: bottomAnchor)])
    }
}
