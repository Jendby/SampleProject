//
//  UIViewController+Alert.swift
//  SampleProject
//
//  Created by Eugene Smolyakov on 28/02/2020.
//  Copyright © 2020 ES. All rights reserved.
//


import UIKit
import SVProgressHUD

extension UIViewController: AlertProtocol {
    func show(title: String, error: String, action: ((UIAlertAction) -> Void)?) {
        show(title: title, message: error, okTitle: Const.text.kOk, action: action)
    }

    func show(title: String, error: String) {
        show(title: title, error: error, action: nil)
    }

    func show(error: String) {
        show(title: "Error".localized, error: error, action: nil)
    }

    func handle(error: NSError) {
        show(title: "Error".localized, error: formErrorMessageFrom(error)) { _ in
            if error.code == Const.err.kNetAuth {
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: Const.notification.authErr),
                                                object: error,
                                                userInfo: nil)
            }
        }
    }

    func show(title: String, message: String) {
        show(title: title, message: message, okTitle: Const.text.kClose, action: nil)
    }

    func show(title: String, message: String, okTitle: String, action: ((UIAlertAction) -> Void)?) {
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: okTitle, style: .default, handler: action)
        ac.addAction(okAction)
        runOnMainThread { [weak self] in
            self?.present(ac, animated: true, completion: nil)
        }
    }

    func showYesNO(title: String,
                   message: String,
                   actionYes: ((UIAlertAction) -> Void)?,
                   actionNo: ((UIAlertAction) -> Void)?) {
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let yesAction = UIAlertAction(title: Const.text.kYes, style: .default, handler: actionYes)
        ac.addAction(yesAction)
        let noAction = UIAlertAction(title: Const.text.kNo, style: .default, handler: actionNo)
        ac.addAction(noAction)
        runOnMainThread { [weak self] in
            self?.present(ac, animated: true, completion: nil)
        }
    }

    func showInputDialog(title: String,
                         message: String,
                         okAction:((String) -> Void)?) {
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        ac.addTextField(configurationHandler: nil)
        let yesAction = UIAlertAction(title: Const.text.kOk,
                                      style: .default,
                                      handler: { [weak ac] (action) in
            if let act = okAction,
                let textfields = ac?.textFields {
                act(textfields.first!.text!)
            }
        })
        ac.addAction(yesAction)
        let noAction = UIAlertAction(title: Const.text.kCancel, style: .default, handler: nil)
        ac.addAction(noAction)
        runOnMainThread { [weak self] in
            self?.present(ac, animated: true, completion: nil)
        }
    }

    func show(image: UIImage,
              titles: [String],
              title: String,
              message: String,
              style: UIAlertController.Style,
              needCancel: Bool,
              okAction:((String, Int) -> Void)?) {
        let ac = UIAlertController(title: title, message: message, preferredStyle: style)
        let img = UIAlertAction(title: "", style: .default, handler: nil)
        img.setValue(image.withRenderingMode(.alwaysOriginal), forKey: "image")
        ac.addAction(img)
        for i in titles.indices {
            let m = titles[i]
            let action = UIAlertAction(title: m, style: .default, handler: { a in
                if a.title == m {
                    okAction?(m, i)
                }
            })
            ac.addAction(action)
        }
        if needCancel {
            let cancel = UIAlertAction(title: Const.text.kCancel,
                                       style: .cancel,
                                       handler: nil)
            ac.addAction(cancel)
        }
        runOnMainThread { [weak self] in
            self?.present(ac, animated: true, completion: nil)
        }
    }

    private func commonChooseFrom(titles: [String],
                                  title: String,
                                  message: String,
                                  style: UIAlertController.Style,
                                  needCancel: Bool,
                                  okAction:((String, Int) -> Void)?) {
        let ac = UIAlertController(title: title, message: message, preferredStyle: style)
        for i in titles.indices {
            let m = titles[i]
            let action = UIAlertAction(title: m, style: .default, handler: { a in
                if a.title == m {
                    okAction?(m, i)
                }
            })
            ac.addAction(action)
        }
        if needCancel {
            let cancel = UIAlertAction(title: Const.text.kCancel,
                                       style: .cancel,
                                       handler: nil)
            ac.addAction(cancel)
        }
        runOnMainThread { [weak self] in
            self?.present(ac, animated: true, completion: nil)
        }
    }

    func show(buttons: [String],
              title: String,
              message: String,
              okAction:((String, Int) -> Void)?) {
        commonChooseFrom(titles: buttons,
                         title: title,
                         message: message,
                         style: .alert,
                         needCancel: false,
                         okAction: okAction)
    }

    func chooseFrom(titles: [String],
                    title: String,
                    okAction:((String, Int) -> Void)?) {
        commonChooseFrom(titles: titles,
                         title: title,
                         message: "",
                         style: .actionSheet,
                         needCancel: true,
                         okAction: okAction)
    }

    func showBusyIndicator() {
        SVProgressHUD.show()
    }

    func hideBusyIndicator() {
        SVProgressHUD.dismiss()
    }
}
