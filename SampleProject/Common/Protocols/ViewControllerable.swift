//
//  ViewControllerable.swift
//  SampleProject
//
//  Created by Eugene Smolyakov on 28/02/2020.
//  Copyright © 2020 ES. All rights reserved.
//


import UIKit

protocol ViewControllerable: class {
    static var storyBoardName: String { get }
}

extension ViewControllerable where Self: UIViewController {
    static func create() -> Self {
        let storyboard = self.storyboard()
        let className = NSStringFromClass(Self.self)
        let finalClassName = className.components(separatedBy: ".").last!
        
        let viewControllerId = finalClassName
        let viewController = storyboard.instantiateViewController(withIdentifier: viewControllerId)
        
        return viewController as! Self
    }
    
    static func storyboard() -> UIStoryboard {
        return UIStoryboard(name: storyBoardName, bundle: nil)
    }
}
