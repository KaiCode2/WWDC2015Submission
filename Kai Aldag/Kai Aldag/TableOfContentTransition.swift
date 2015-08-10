//
//  TableOfContentTransition.swift
//  Kai Aldag
//
//  Created by Kai Aldag on 2015-04-18.
//  Copyright (c) 2015 Kai Aldag. All rights reserved.
//

import UIKit

@objc protocol TableOfContentTransitionDelegate {
    var transitionImage: UIImage? { get }
    var transitionImageRect: CGRect { get }
    optional func transitionAnimationWillBegin()
    optional func transitionAnimationDidEnd()
}

class TableOfContentTransition: NSObject, UIViewControllerAnimatedTransitioning {
    var isPresentation = true
    
    init(presentation: Bool) {
        isPresentation = presentation
        super.init()
    }
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning) -> NSTimeInterval {
        return 1.5
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        isPresentation ? presentationAnimation(transitionContext) : dismissalAnimation(transitionContext)
    }
    
    // MARK: Animations
    
    func presentationAnimation(transitionContext: UIViewControllerContextTransitioning) {
        let fromView = transitionContext.viewForKey(UITransitionContextFromViewKey)
        let toView = transitionContext.viewForKey(UITransitionContextToViewKey)
        
        if let toView = toView {
            transitionContext.containerView().addSubview(toView)
        }
        
        let presentingAnimatingView = toView
        let presentedAnimatingView = fromView
        let initialAlpha: CGFloat = 0
        let finalAlpha: CGFloat = 1
        let duration: NSTimeInterval = transitionDuration(transitionContext) / 2.0
        
        presentingAnimatingView?.alpha = initialAlpha
        
        let imageView = UIImageView()
        let fromDelegate = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey) as? TableOfContentTransitionDelegate
        let toDelegate = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey) as? TableOfContentTransitionDelegate
        
        imageView.contentMode = .ScaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = fromDelegate?.transitionImage
        imageView.frame = fromDelegate?.transitionImageRect ?? UIScreen.mainScreen().bounds
        
        transitionContext.containerView().addSubview(imageView)
        fromDelegate?.transitionAnimationWillBegin?()
        
        UIView.animateWithDuration(duration, delay: 0, usingSpringWithDamping: 0.55, initialSpringVelocity: 1, options: nil, animations: { () -> Void in
            imageView.frame = toDelegate?.transitionImageRect ?? UIScreen.mainScreen().bounds
            }) { _ in
                presentingAnimatingView?.alpha = finalAlpha
                UIView.animateWithDuration(duration, animations: {
                    imageView.alpha = 0
                    }, completion: { _ in
                        imageView.removeFromSuperview()
                        fromDelegate?.transitionAnimationDidEnd?()
                        transitionContext.completeTransition(true)
                })
        }
    }
    
    func dismissalAnimation(transitionContext: UIViewControllerContextTransitioning) {
        let fromView = transitionContext.viewForKey(UITransitionContextFromViewKey)
        let toView = transitionContext.viewForKey(UITransitionContextToViewKey)
        
        let presentingAnimatingView = fromView
        let presentedAnimatingView = toView
        let initialAlpha: CGFloat = 0
        let finalAlpha: CGFloat = 1
        let duration: NSTimeInterval = transitionDuration(transitionContext) / 2.0
        
        if let toView = toView {
            transitionContext.containerView().addSubview(toView)
            toView.alpha = finalAlpha
        }

        presentingAnimatingView?.alpha = initialAlpha
        
        let imageView = UIImageView()
        let fromDelegate = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey) as? TableOfContentTransitionDelegate
        let toDelegate = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey) as? TableOfContentTransitionDelegate
        
        imageView.contentMode = .ScaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = toDelegate?.transitionImage
        imageView.frame = fromDelegate?.transitionImageRect ?? UIScreen.mainScreen().bounds
        
        transitionContext.containerView().addSubview(imageView)
        toDelegate?.transitionAnimationWillBegin?()
        
        UIView.animateWithDuration(duration, animations: {
            presentingAnimatingView?.alpha = 0
            }, completion: { _ in
                presentedAnimatingView?.alpha = 1
                UIView.animateWithDuration(duration, delay: 0, usingSpringWithDamping: 0.55, initialSpringVelocity: 1, options: nil, animations: { () -> Void in
                    imageView.frame = toDelegate?.transitionImageRect ?? UIScreen.mainScreen().bounds
                    }) { _ in
                        imageView.removeFromSuperview()
                        toDelegate?.transitionAnimationDidEnd?()
                        transitionContext.completeTransition(true)
                }
        })
    }
}