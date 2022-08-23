//
//  JMDismissTransitionAnimated.swift
//  ZJMKit
//
//  Created by JunMing on 2020/12/30.
//  Copyright © 2022 JunMing. All rights reserved.
//

import UIKit

class JMDismissTransitionAnimated: NSObject, UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.3
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let fromViewController = transitionContext.viewController(forKey: .from)
        let toViewController = transitionContext.viewController(forKey: .to)
        let containerView = transitionContext.containerView
        
        var fromView = transitionContext.view(forKey: UITransitionContextViewKey.from)
        var toView = transitionContext.view(forKey: UITransitionContextViewKey.to)
        if (fromView == nil) && (toView == nil) {
            fromView = fromViewController?.view
            toView = toViewController?.view
        }
        let isDismiss = fromViewController?.presentingViewController == toViewController
        let fromFrame = transitionContext.initialFrame(for: fromViewController!)
        let toFrame = transitionContext.finalFrame(for: toViewController!)
        
        if isDismiss {
            fromView?.frame = fromFrame
            toView?.frame = toFrame.offsetBy(dx: toFrame.size.width*0.3 * -1, dy: 0)
        }
        
        if isDismiss {
            containerView.insertSubview(toView!, belowSubview: fromView!)
        }
        
        let transitionDuration = self.transitionDuration(using: transitionContext)
        UIView.animate(withDuration: transitionDuration) {
            if isDismiss {
                toView?.frame = toFrame
                fromView?.frame = fromFrame.offsetBy(dx: fromFrame.size.width, dy: 0)
            }
        } completion: { (finish) in
            let wasCancel = transitionContext.transitionWasCancelled
            if wasCancel {
                toView?.removeFromSuperview()
            }
            transitionContext.completeTransition(!wasCancel)
        }
    }
}
