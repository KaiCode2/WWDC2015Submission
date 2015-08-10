//
//  SplashTransition.swift
//  Kai Aldag
//
//  Created by Kai Aldag on 2015-04-18.
//  Copyright (c) 2015 Kai Aldag. All rights reserved.
//

import UIKit

class SplashTransition: NSObject, UIViewControllerAnimatedTransitioning {
    let transitionDuration: NSTimeInterval = 0.75
    let durationScale = 0.65
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning) -> NSTimeInterval {
        return transitionDuration
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        let fromView = transitionContext.viewForKey(UITransitionContextFromViewKey)
        let toView = transitionContext.viewForKey(UITransitionContextToViewKey)
        
        if let toView = toView {
            transitionContext.containerView().addSubview(toView)
        }
        
        let animatingView = toView
        let toAnimatingView = fromView
        let initialAlpha: CGFloat = 0
        let finalAlpha: CGFloat = 1
        let duration: NSTimeInterval = transitionDuration(transitionContext)
        
        animatingView?.alpha = initialAlpha
        UIView.animateWithDuration(duration, animations: {
            animatingView?.alpha = finalAlpha
            }, completion: { _ in
                transitionContext.completeTransition(true)
        })
    }
}