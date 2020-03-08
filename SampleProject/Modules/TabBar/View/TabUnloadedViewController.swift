//
//  TabUnloadedViewController.swift
//  SampleProject
//
//  Created by Eugene Smolyakov on 29/02/2020.
//  Copyright © 2020 ES. All rights reserved.
//

import UIKit

protocol TabUnloadedVCDelegate: class {
    func viewWillAppearOf(type: TabType, vc: UIViewController)
    func viewWillDisappearOf(type: TabType, vc: UIViewController)
}

/// shows an empty view for UITabBarController
/// in order to safe the system resources
/// for loading a real content
/// implement methods of TabUnloadedVCDelegate protocol
final class TabUnloadedViewController: UIViewController {
    let type: TabType
    weak var delegate: TabUnloadedVCDelegate? = nil

    init(type: TabType) {
        self.type = type
        super.init(nibName: nil, bundle: nil)

        switch type {
        case .json:
            tabBarItem.image = UIImage(systemName: "list.bullet")
            tabBarItem.title = "JSON"
        case .ARTable:
            tabBarItem.image = UIImage(systemName: "arkit")
            tabBarItem.title = "AR"
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        delegate?.viewWillAppearOf(type: type, vc: self)
        // take care of navigationItem in our container:
        for c in children {
            if let r = c.navigationItem.rightBarButtonItem {
                navigationItem.rightBarButtonItem = r
            }
            if let t = c.title {
                title = t
            }
            if let l = c.navigationItem.leftBarButtonItem {
                navigationItem.leftBarButtonItem = l
            }
        }
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        delegate?.viewWillDisappearOf(type: type, vc: self)
    }
}
