//
//  TabBarViewController.swift
//  SampleProject
//
//  Created by Eugene Smolyakov on 29/02/2020.
//  Copyright © 2020 JendBy. All rights reserved.
//

import UIKit

enum TabType {
    case table
    case about
}

final class TabBarViewController: UITabBarController {
    var output: TabBarViewOutput!

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
extension TabBarViewController: Themeble {
    func apply(theme: Theme) {
        view.tintColor = theme.tintColor
    }
}

// MARK: - TabBarerViewInput
extension TabBarViewController: TabBarViewInput {
    func setupInitialState(selected: Int) {
        let vcsTypes: [TabType] = [.table, .about]
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
extension TabBarViewController: TabUnloadedVCDelegate {
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
