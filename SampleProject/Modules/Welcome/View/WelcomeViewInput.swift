//
//  WelcomeViewInput.swift
//  SampleProject
//
//  Created by Eugene Smolyakov on 28/02/2020.
//  Copyright © 2020 JendBy. All rights reserved.
//

import UIKit

protocol WelcomeViewInput: class, Presentable {
    func scrollToIndex(index: Int)
    func changeGradientButtonText(text: String)
    func changeBottomButtonText(text: String)
    func createTelephoneView()
    func changeAboutText(text: String, fontSize:CGFloat)
    func createFirstView()
    func firstAppear()
}
