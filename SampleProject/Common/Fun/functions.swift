//
//  functions.swift
//  SampleProject
//
//  Created by Eugene Smolyakov on 28/02/2020.
//  Copyright © 2020 ES. All rights reserved.
//


import UIKit

func delay(_ delay:Double, closure:@escaping ()->()) {
    let when = DispatchTime.now() + delay
    DispatchQueue.main.asyncAfter(deadline: when, execute: closure)
}

func runOnMainThread(_ closure: @escaping ()->()) {
    if Thread.isMainThread {
        closure()
    } else {
        DispatchQueue.main.async {
            closure()
        }
    }
}

func formErrorMessageFrom(_ error: NSError) -> String {
    var descr = error.localizedDescription
    if let infos = error.userInfo[Const.err.fields.data] as? [NSDictionary] {
        for info in infos {
            for (k, _) in info {
                if let f = k as? String {
                    (descr, _) = appendErrorMessagesFrom(info, error: descr, field: f)
                }
            }
        }
    }
    return descr
}

func appendErrorMessagesFrom(_ dict: NSDictionary,
                             error: String,
                             field: String) -> (String, Bool) {
    let v = localizedDescriptionFrom(dict: dict, field: field)
    if v.count > 0 {
        return (error + "\n" + v, true)
    }
    return (error, false)
}

func localizedDescriptionFrom(dict: NSDictionary, field: String) -> String {
    if let d = dict[field] as? String {
        return d
    } else if let d = dict[field] as? [String] {
        return d.joined(separator: "\n")
    } else if let dd = dict[field] as? [NSDictionary] {
        var out = ""
        for d in dd {
            let e = localizedDescriptionFrom(dict: d)
            if out.count > 0 {
                out += "\n"
            }
            out.append(contentsOf: e)
        }
        return out
    } else if let d = dict[field] as? NSDictionary {
        return localizedDescriptionFrom(dict: d)
    }
    return ""
}

func localizedDescriptionFrom(dict: NSDictionary) -> String {
    if let locale = NSLocale.current.languageCode {
        if let localized = dict[locale.lowercased()] as? String {
            return localized
        } else {
            return defaultDescriptionFrom(dict: dict)
        }
    }
    return ""
}

func defaultDescriptionFrom(dict: NSDictionary) -> String {
    if let en = dict["en"] as? String { // a default value
        return en
    }
    return ""
}

func randomColor() -> UIColor {
    return UIColor(red: rand(), green: rand(), blue: rand(), alpha: 1.0)
}

private func rand() -> CGFloat {
    return CGFloat(arc4random()) / CGFloat(UInt32.max)
}
