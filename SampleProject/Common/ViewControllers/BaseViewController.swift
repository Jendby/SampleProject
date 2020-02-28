//
//  BaseViewController.swift
//  SampleProject
//
//  Created by Eugene Smolyakov on 28/02/2020.
//  Copyright © 2020 ES. All rights reserved.
//


import UIKit

class BaseViewController: UIViewController, Themeble {
    open override func viewDidLoad() {
        super.viewDidLoad()
        let themeManager: ThemeManagerProtocol = ServicesAssembler.inject()
        let currentTheme = themeManager.getCurrentTheme()
        apply(theme: currentTheme)
    }

    // MARK: - Helpers
    internal func viewWithClearBack() -> UIView {
        let header = UIView()
        header.backgroundColor = UIColor.clear
        return header
    }

    // MARK: Themeble
    func apply(theme: Theme) {
        self.navigationItem.leftBarButtonItem?.tintColor = theme.tintColor
        UINavigationBar.appearance().tintColor = theme.tintColor
        UINavigationBar.appearance().titleTextAttributes =
            [.font: theme.semiboldFont.withSize(theme.sz.middle1),
             .foregroundColor: theme.mainTextColor]
        self.theme = theme
    }

    func addDismissKeyboard() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        self.view.addGestureRecognizer(tap)
    }

    @objc private func dismissKeyboard() {
        self.view.endEditing(true)
    }

    // MARK: Private/internal
    internal var theme: Theme!
}
