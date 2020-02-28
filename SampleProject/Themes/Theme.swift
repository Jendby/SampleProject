//
//  Theme.swift
//  SampleProject
//
//  Created by Eugene Smolyakov on 28/02/2020.
//  Copyright © 2020 ES. All rights reserved.
//


import UIKit

protocol Themeble: class {
    func apply(theme: Theme)
}

struct ThemeSizes {
    let header0: CGFloat
    let header1: CGFloat
    let header2: CGFloat
    let header3: CGFloat

    let middle0: CGFloat
    let middle1: CGFloat
    let middle2: CGFloat
    let middle3: CGFloat
    let middle4: CGFloat

    let small0: CGFloat
    let small1: CGFloat
    let small2: CGFloat
    let small3: CGFloat
}

struct Theme {
    // colors
    let tintColor: UIColor
    let warnColor: UIColor
    let inactiveColor: UIColor
    let mainTextColor: UIColor
    let secondaryTextColor: UIColor
    let separatorColor: UIColor
    let commentsBackColor: UIColor
    let emptyBackColor: UIColor
    let secondaryBackColor: UIColor
    let mainBackColor: UIColor
    let subscribeColor: UIColor
    let borderColor: UIColor
    let allowedColor: UIColor
    let prettyTintColor: UIColor
    let selectionColor: UIColor
    
    //colors from zeplin
    let zwhite: UIColor
    let ztangerine: UIColor
    let zcool_grey: UIColor
    let zsunflower_yellow: UIColor
    let zwhite_two: UIColor
    let zazure: UIColor
    let zgunmetal: UIColor
    let zdoger_blue: UIColor
    let ztomato: UIColor
    let zalgae: UIColor
    let zsilver: UIColor
    let zblack: UIColor
    let zbright_aqua: UIColor
    let zwarm_grey: UIColor
    let zbrownish_gray: UIColor
    let zgreyish: UIColor
    
    // fonts
    let regularFont: UIFont
    let boldFont: UIFont
    let mediumFont: UIFont
    let semiboldFont: UIFont
    // Navigation Bar
    let titleFont: UIFont
    let buttonFont: UIFont
    // sizes, used in labels, edit fields etc
    let sz: ThemeSizes

    var navButtonAttributes: [NSAttributedString.Key: Any] {
        return [.font: self.buttonFont, .foregroundColor: self.tintColor]
    }
}
