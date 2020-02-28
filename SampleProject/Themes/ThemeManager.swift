//
//  ThemeManager.swift
//  SampleProject
//
//  Created by Eugene Smolyakov on 28/02/2020.
//  Copyright © 2020 ES. All rights reserved.
//


import UIKit

let kThemeChangedNotification = "kThemeChangedNotification"

protocol ThemeManagerProtocol: class {
    func getCurrentTheme() -> Theme
}

protocol ThemebleRouting: class {
    func change(theme: Theme)
}

final class ThemeManager: ThemeManagerProtocol {
    init() {
        let sz: CGFloat = 12
        self.theme = Theme(
            tintColor: #colorLiteral(red: 0.1569, green: 0.451, blue: 0.6471, alpha: 1) /* #2873a5 */,
            warnColor: #colorLiteral(red: 1, green: 0.1765, blue: 0.3333, alpha: 1) /* #ff2d55 */,
            inactiveColor: #colorLiteral(red: 0.7804, green: 0.7804, blue: 0.8, alpha: 1) /* #c7c7cc */,
            mainTextColor: UIColor.black,
            secondaryTextColor: #colorLiteral(red: 0.5569, green: 0.5569, blue: 0.5765, alpha: 1) /* #8e8e93 */,
            separatorColor: #colorLiteral(red: 0.8196, green: 0.8196, blue: 0.8392, alpha: 1) /* #d1d1d6 */,
            commentsBackColor: #colorLiteral(red: 0.9725, green: 0.9725, blue: 0.9725, alpha: 1) /* #f8f8f8 */,
            emptyBackColor: UIColor.white,
            secondaryBackColor: #colorLiteral(red: 0.9725, green: 0.9725, blue: 0.9725, alpha: 1) /* #f8f8f8 */,
            mainBackColor: UIColor.white,
            subscribeColor: #colorLiteral(red: 0.2784, green: 0.7373, blue: 0.3686, alpha: 1) /* #47bc5e */,
            borderColor: #colorLiteral(red: 0.9373, green: 0.9373, blue: 0.9569, alpha: 1) /* #efeff4 */,
            allowedColor: #colorLiteral(red: 0.2314, green: 0.7765, blue: 0.3804, alpha: 1) /* #3bc661 */,
            prettyTintColor: #colorLiteral(red: 0.7804, green: 0.5059, blue: 0.7529, alpha: 1) /* #c781c0 */,
            selectionColor: #colorLiteral(red: 0.9686, green: 0.7765, blue: 0, alpha: 1) /* #f7c600 */,
            
            zwhite: #colorLiteral(red: 0.9215686275, green: 0.9215686275, blue: 0.9215686275, alpha: 1), /* #ebebeb */
            ztangerine: #colorLiteral(red: 1, green: 0.5882352941, blue: 0, alpha: 1), /* #FF9600 */
            zcool_grey: #colorLiteral(red: 0.5568627451, green: 0.5725490196, blue: 0.5921568627, alpha: 1), /* #8E9297 */
            zsunflower_yellow: #colorLiteral(red: 1, green: 0.8941176471, blue: 0, alpha: 1), /* #FFE400 */
            zwhite_two: #colorLiteral(red: 0.8392156863, green: 0.8392156863, blue: 0.8392156863, alpha: 1), /* #D6D6D6 */
            zazure: #colorLiteral(red: 0.003921568627, green: 0.6156862745, blue: 0.9960784314, alpha: 1), /* #019DFE */
            zgunmetal: #colorLiteral(red: 0.337254902, green: 0.3490196078, blue: 0.3607843137, alpha: 1), /* #56595C */
            zdoger_blue: #colorLiteral(red: 0.2588235294, green: 0.5254901961, blue: 0.9607843137, alpha: 1), /* #4286F5 */
            ztomato: #colorLiteral(red: 0.9176470588, green: 0.3137254902, blue: 0.2039215686, alpha: 1), /* #EA5034 */
            zalgae: #colorLiteral(red: 0.3607843137, green: 0.7176470588, blue: 0.4784313725, alpha: 1), /* #5CB77A */
            zsilver: #colorLiteral(red: 0.7882352941, green: 0.7921568627, blue: 0.8, alpha: 1), /* #C9CACC */
            zblack: #colorLiteral(red: 0.1294117647, green: 0.1294117647, blue: 0.1294117647, alpha: 1), /* #212121 */
            zbright_aqua: #colorLiteral(red: 0, green: 0.9764705882, blue: 0.9019607843, alpha: 1), /* #00F9E6 */
            zwarm_grey: #colorLiteral(red: 0.4392156863, green: 0.4392156863, blue: 0.4392156863, alpha: 1), /* #707070 */
            zbrownish_gray: #colorLiteral(red: 0.3607843137, green: 0.3607843137, blue: 0.3607843137, alpha: 1), /* #5C5C5C */
            zgreyish: #colorLiteral(red: 0.7176470588, green: 0.7176470588, blue: 0.7176470588, alpha: 1), /* #B7B7B7 */
            
            regularFont: UIFont.systemFont(ofSize: sz, weight: .regular),
            boldFont: UIFont.systemFont(ofSize: sz, weight: .bold),
            mediumFont: UIFont.systemFont(ofSize: sz, weight: .medium),
            semiboldFont: UIFont.systemFont(ofSize: sz, weight: .semibold),
            titleFont: UIFont.systemFont(ofSize: sz, weight: .heavy),
            buttonFont: UIFont.systemFont(ofSize: sz, weight: .regular),
            
            sz: ThemeSizes(header0: 49,
                           header1: 46,
                           header2: 34,
                           header3: 30,
                           middle0: 19,
                           middle1: 17,
                           middle2: 16,
                           middle3: 15,
                           middle4: 14,
                           small0: 13,
                           small1: 12,
                           small2: 11,
                           small3: 10))
    }

    // MARK: ThemeManagerProtocol

    func getCurrentTheme() -> Theme {
        if let t = theme {
            return t
        }
        fatalError("Theme isn't set in Theme Manager!")
    }

    // MARK: Private

    private var theme: Theme?
}

extension ThemeManager: ThemebleRouting {
    func change(theme: Theme) {
        self.theme = theme
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: kThemeChangedNotification),
                                        object: nil,
                                        userInfo: nil)
    }
}
