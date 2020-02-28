//
//  DissolveTransition.swift
//  SampleProject
//
//  Created by Eugene Smolyakov on 28/02/2020.
//  Copyright © 2020 JendBy. All rights reserved.
//

import UIKit

final class DissolveTransition: NSObject, UIViewControllerAnimatedTransitioning {
    let kAniTime: TimeInterval = 0.5

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return kAniTime
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromVC = transitionContext.viewController(forKey: .from),
            let toVC = transitionContext.viewController(forKey: .to),
            let snapshot = fromVC.view.snapshotView(afterScreenUpdates: false) else {
                transitionContext.completeTransition(false)
                return
        }
        let containerView = transitionContext.containerView
        containerView.addSubview(toVC.view)
        containerView.addSubview(snapshot)
        UIView.animate(withDuration: kAniTime,
                       delay: 0.0,
                       options: [.curveEaseIn],
                       animations: {
                        let s: CGFloat = 10
                        snapshot.transform = CGAffineTransform(scaleX: s, y: s)
                        snapshot.alpha = 0
        }, completion: { _ in
            snapshot.removeFromSuperview()
            transitionContext.completeTransition(true)
        })
    }
}
