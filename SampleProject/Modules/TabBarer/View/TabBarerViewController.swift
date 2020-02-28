//
//  TabBarerViewController.swift
//  SampleProject
//
//  Created by Eugene Smolyakov on 28/02/2020.
//  Copyright © 2020 JendBy. All rights reserved.
//

import UIKit

enum TabType {
    case first
    case second
}

final class TabBarerViewController: UITabBarController {
    var output: TabBarerViewOutput!

    // MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        let tm: ThemeManagerProtocol = ServicesAssembler.inject()
        apply(theme: tm.getCurrentTheme())
    }

    private var tabs = [TabType]()
    private var selectedTab: TabType? = nil
}

// MARK: - Themeble
extension TabBarerViewController: Themeble {
    func apply(theme: Theme) {
        view.tintColor = theme.tintColor
    }
}

// MARK: - TabBarerViewInput
extension TabBarerViewController: TabBarerViewInput {
    func setupInitialState(selected: Int) {
        let vcsTypes: [TabType] = [.first, .second]
        var vcs = [UIViewController]()
        for t in vcsTypes {
            let vc = TabUnloadedViewController(type: t)
            vc.delegate = self
            let nav = UINavigationController(rootViewController: vc)
            vcs.append(nav)
        }
        self.tabs = vcsTypes
        viewControllers = vcs
        selectedIndex = selected
    }
}

// MARK: - TabUnloadedVCDelegate
extension TabBarerViewController: TabUnloadedVCDelegate {
    func viewWillAppearOf(type: TabType, vc: UIViewController) {
        if type != selectedTab {
            selectedTab = type
            self.output.loadViewOf(type: type, vc: vc)
        }
    }

    func viewWillDisappearOf(type: TabType, vc: UIViewController) {
        if type != selectedTab {
            for v in vc.children {
                v.willMove(toParent: nil)
                v.view.removeFromSuperview()
                v.removeFromParent()
            }
        }
    }
}
