//
//  UIFont+SF.swift
//  SampleProject
//
//  Created by Eugene Smolyakov on 28/02/2020.
//  Copyright © 2020 ES. All rights reserved.
//


import UIKit

enum FontWeight: String {
    case regular
    case semibold
    case bold
    case black
    case medium
    case light
    case thin
    case ultralight
    
    var fontName: String {
        return "sf-ui-display-\(self.rawValue)"
    }
    
    var alternativeFontName: String {
        return "SFUIDisplay-\(self.rawValue.capitalized)"
    }
}

extension UIFont.Weight {
    public var name: String? {
        switch self {
        case UIFont.Weight.black        : return "Black"
        case UIFont.Weight.bold         : return "Bold"
        case UIFont.Weight.heavy        : return "Heavy"
        case UIFont.Weight.light        : return "Light"
        case UIFont.Weight.medium       : return "Medium"
        case UIFont.Weight.regular      : return "Regular"
        case UIFont.Weight.semibold     : return "Semibold"
        case UIFont.Weight.thin         : return "Thin"
        case UIFont.Weight.ultraLight   : return "Ultralight"
        default                         : return nil
        }
    }
}

extension UIFont {
    static func sf(_ weight: FontWeight, size: CGFloat) -> UIFont {
        let font1 = UIFont(name: weight.fontName, size: size)
        let font2 = UIFont(name: weight.alternativeFontName, size: size)
        return  font1 ?? font2 ?? UIFont.systemFont(ofSize: size, weight: .regular)
    }
    
    static func sfPro(_ weight: UIFont.Weight, size: CGFloat) -> UIFont {
        let defaultFont = UIFont.systemFont(ofSize: size, weight: weight)
        guard let name = weight.name, let font = UIFont(name: "SFProDisplay-\(name)", size: size) else { return defaultFont }
        return font
    }
    
    func multiplySize(by: CGFloat) -> UIFont {
        let currentSize = self.pointSize
        return self.withSize(currentSize * by)
    }
}
