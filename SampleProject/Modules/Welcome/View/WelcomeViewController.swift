//
//  WelcomeViewController.swift
//  SampleProject
//
//  Created by Eugene Smolyakov on 28/02/2020.
//  Copyright © 2020 JendBy. All rights reserved.
//

import UIKit

final class WelcomeViewController: BaseViewController {
    var output: WelcomeViewOutput!
    
    private var centr: CGFloat = 0
    private var firstInit = true
    
    @IBOutlet weak var grButtonTopCnst: NSLayoutConstraint!
    @IBOutlet weak var gradientButtonwidth: NSLayoutConstraint!
    
    @IBOutlet weak var numberWidth: NSLayoutConstraint!
    @IBOutlet weak var numberTopCnstr: NSLayoutConstraint!
    
    @IBOutlet weak var iconHgt: NSLayoutConstraint!
    @IBOutlet weak var iconWdth: NSLayoutConstraint!
    @IBOutlet weak var leadIconConstr: NSLayoutConstraint!
    @IBOutlet weak var topIconCnstr: NSLayoutConstraint!
    
    @IBOutlet weak var icon: UIView!
    @IBOutlet weak var telephoneNumber: UITextField!
    @IBOutlet weak var about: UILabel!
    @IBOutlet weak var bottomButton: UIButton!
    @IBOutlet weak var gradientButton: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    // MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        icon.layer.cornerRadius = 15
        icon.layer.masksToBounds = true
        icon.backgroundColor = #colorLiteral(red: 0.2196078449, green: 0.007843137719, blue: 0.8549019694, alpha: 1)
        
        telephoneNumber.layer.cornerRadius = const.btnCornerRadius
        telephoneNumber.layer.masksToBounds = true
        telephoneNumber.backgroundColor = .white
        
        centr = self.view.frame.size.height / 2 - const.btnHeight
        addDismissKeyboard()
        
        let colors:[UIColor] = [#colorLiteral(red: 0.7254902124, green: 0.4784313738, blue: 0.09803921729, alpha: 1),#colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)]
        self.scrollView.frame = self.view.frame
        self.scrollView.frame = CGRect(x:0, y:0,
                                       width:self.view.frame.width,
                                       height:self.view.frame.height)
        let scrollViewWidth:CGFloat = self.scrollView.frame.width
        let scrollViewHeight:CGFloat = self.scrollView.frame.height
        for index in 0..<colors.count {
            let imageView = UIView(frame:
                CGRect(x: CGFloat(index) * scrollViewWidth, y:0,
                       width:scrollViewWidth,
                       height:scrollViewHeight))
            imageView.backgroundColor = colors[index]
            self.scrollView.addSubview(imageView)
        }
        self.scrollView.contentSize =
            CGSize(width:self.scrollView.frame.width * CGFloat(colors.count),
                   height: self.scrollView.frame.height)
        updateScrollViewContent(index: 0, animated: false)
        
        // MARK: gradientButton
        gradientButton.layer.cornerRadius = const.btnCornerRadius
        gradientLayer = CAGradientLayer()
        gradientLayer.contentsGravity = .center
        gradientLayer.frame = gradientButton.bounds
        gradientButton.layer.insertSublayer(gradientLayer, at: 0)
        gradientButton.addTarget(self, action: #selector(gradButtonTapped), for: .touchUpInside)
        gradientButton.layer.masksToBounds = true
        createAnimation()
        
        bottomButton.addTarget(self, action: #selector(bottomButTapped), for: .touchUpInside)
        
        output.viewIsReady()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if firstInit {
            output.firstAppear()
            firstInit = false
        }
    }
    
    //MARK: CA VAR
    private var anumationGroup: CAAnimationGroup!
    private var gradientLayer: CAGradientLayer! {
        didSet {
            gradientLayer.startPoint = CGPoint(x: -1, y: 0.5)
            gradientLayer.endPoint = CGPoint(x: 3, y: 0.5)
            let startColor = #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1).cgColor
            let endColor = #colorLiteral(red: 0.5843137503, green: 0.8235294223, blue: 0.4196078479, alpha: 1).cgColor
            gradientLayer.colors = [endColor,startColor,endColor,startColor,endColor]
        }
    }
    //MARK: FUNC
    @objc func gradButtonTapped() {
        output.gradientBtnTapped()
        view.endEditing(true)
    }
    
    @objc func bottomButTapped() {
        output.bottomBtnTapped()
    }
    
    private func updateScrollViewContent(index: Int, animated: Bool = true) {
        let sz = scrollView.bounds.size
        let cx = sz.width
        let cy = sz.height
        let rect = CGRect(x: CGFloat(index) * cx, y: 0,
                          width: cx, height: cy)
        scrollView.scrollRectToVisible(rect, animated: animated)
    }
    
    private func createAnimation(){
        let theAnimation = CABasicAnimation(keyPath: #keyPath(CAGradientLayer.startPoint))
        theAnimation.fromValue = CGPoint(x: -1, y: 0.5)
        theAnimation.toValue = CGPoint(x: -3, y: 0.5)
        
        let theAnimation2 = CABasicAnimation(keyPath: #keyPath(CAGradientLayer.endPoint))
        theAnimation2.fromValue = CGPoint(x: 3, y: 0.5)
        theAnimation2.toValue = CGPoint(x: 1, y: 0.5)
        
        anumationGroup = CAAnimationGroup()
        anumationGroup.animations = [theAnimation,theAnimation2]
        anumationGroup.isRemovedOnCompletion = false
        anumationGroup.duration = 3.0
        //        anumationGroup.autoreverses = true
        anumationGroup.repeatCount = Float.infinity
        gradientLayer.add(anumationGroup, forKey: "group")
    }
    
    private func gradientTapped() {
        UIView.animate(withDuration: const.animationDuration) {
            self.gradientLayer.frame.size.height = const.btnHeight
            self.grButtonTopCnst.constant = self.centr
            self.gradientButtonwidth.constant = const.btnHeight
            self.gradientButton.layer.cornerRadius = const.btnHeight / 2
            self.view.layoutIfNeeded()
        }
    }
    
    private func gradiendEndAnimate(endpoint:CGFloat) {
        UIView.animate(withDuration: const.animationDuration,
                       animations: {
                        self.gradientLayer.frame.size.width = 320
                        self.gradientLayer.frame.size.height = const.btnHeight
                        self.gradientButton.layer.cornerRadius = const.btnCornerRadius
                        self.grButtonTopCnst.constant = endpoint
                        self.gradientButtonwidth.constant = const.btnWidth
                        self.view.layoutIfNeeded()
        }) { (bool) in
            self.gradientLayer.frame = self.gradientButton.bounds
        }
    }
    private func logoAnimate() {
        UIView.animate(withDuration: const.animationDuration,
                       animations: {
                        self.iconHgt.constant = 70
                        self.iconWdth.constant = 70
                        self.leadIconConstr.constant -= 5
                        self.topIconCnstr.constant -= 5
                        self.view.layoutIfNeeded()
        }) { (bool) in
            UIView.animate(withDuration: const.animationDuration) {
                self.iconHgt.constant = 60
                self.iconWdth.constant = 60
                self.leadIconConstr.constant += 5
                self.topIconCnstr.constant += 5
                self.view.layoutIfNeeded()
            }
        }
    }
    //MARK: - Themble
    override func apply(theme: Theme) {
        super.apply(theme: theme)
        about.font = theme.boldFont.withSize(theme.sz.header3)
        about.textColor = UIColor.white
        gradientButton.setTitleColor(UIColor.white, for: .normal)
        gradientButton.titleLabel?.font = theme.regularFont.withSize(theme.sz.middle0)
        bottomButton.setTitleColor(UIColor.white, for: .normal)
        bottomButton.titleLabel?.font = theme.regularFont.withSize(theme.sz.middle0)
    }
}
// MARK: - const
private struct const {
    static let btnHeight:CGFloat = 60
    static let btnWidth:CGFloat = 270
    static let btnCornerRadius:CGFloat = 30
    static let animationDuration:TimeInterval = 0.2
    static let spacingItems:CGFloat = 25
    static let spacingAboutText:CGFloat = 35
}

// MARK: - WelcomeViewInput
extension WelcomeViewController: WelcomeViewInput {
    func scrollToIndex(index: Int) {
        updateScrollViewContent(index: index)
    }
    
    func changeGradientButtonText(text: String) {
        gradientButton.setTitle(text, for: .normal)
    }
    
    func changeBottomButtonText(text: String) {
        bottomButton.setTitle(text, for: .normal)
    }
    
    func createTelephoneView() {
        logoAnimate()
        gradientTapped()
        UIView.animate(withDuration: const.animationDuration,
                       animations: {
                        self.bottomButton.alpha = 0
                        self.view.layoutIfNeeded()
        }) { (bool) in
            self.bottomButton.isHidden = true
            self.numberTopCnstr.constant = self.centr
            self.numberWidth.constant = const.btnHeight
            self.telephoneNumber.layer.cornerRadius = const.btnCornerRadius
            self.telephoneNumber.isHidden = false
            self.telephoneNumber.alpha = 0
            self.view.layoutIfNeeded()
            self.gradiendEndAnimate(endpoint: self.about.frame.maxY + const.spacingAboutText + const.btnHeight + const.spacingItems)
            UIView.animate(withDuration: const.animationDuration,
                           animations: {
                            self.telephoneNumber.alpha = 1
                            self.telephoneNumber.placeholder = "+7(999)999-99-99"
                            self.telephoneNumber.layer.cornerRadius = const.btnCornerRadius
                            self.numberWidth.constant = const.btnWidth
                            self.numberTopCnstr.constant = self.about.frame.maxY + const.spacingAboutText
                            self.view.layoutIfNeeded()
            }) { (bool) in
            }
        }
    }
    
    func changeAboutText(text: String, fontSize: CGFloat) {
        UIView.animate(withDuration: 0.1, animations: { () -> Void in
            self.about.transform = .init(scaleX: 1.25, y: 1.25)
            self.about.alpha = 0
        }) { (finished: Bool) -> Void in
            self.about.text = text
            self.about.font = self.about.font.withSize(fontSize)
            UIView.animate(withDuration: const.animationDuration,
                           animations: { () -> Void in
                self.about.transform = .identity
                self.about.alpha = 1
            })
        }
    }
    
    func createFirstView() {
        grButtonTopCnst.constant = centr
        gradientButtonwidth.constant = const.btnHeight
        gradientButton.layer.cornerRadius = const.btnCornerRadius
        
        about.text = "This is a start screen with a little animation.".localized
        about.alpha = 0
    }
    
    func firstAppear() {
        logoAnimate()
        gradiendEndAnimate(endpoint: about.frame.maxY + const.spacingAboutText)
    }
}

extension WelcomeViewController: ViewControllerable {
    static var storyBoardName: String {
        return "Welcome"
    }
}
