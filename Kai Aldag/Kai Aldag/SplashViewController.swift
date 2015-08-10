//
//  SplashViewController.swift
//  Kai Aldag
//
//  Created by Kai Aldag on 2015-04-18.
//  Copyright (c) 2015 Kai Aldag. All rights reserved.
//

import UIKit

class SplashViewController: UIViewController, UIViewControllerTransitioningDelegate {
    var backdropImage: UIImage!
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(1 * Double(NSEC_PER_SEC)))
        dispatch_after(delayTime, dispatch_get_main_queue()) {
            self.performSegueWithIdentifier("showTableOfContent", sender: self)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let tableOfContentViewController = segue.destinationViewController as? TableOfContentViewController {
            UIGraphicsBeginImageContextWithOptions(view.bounds.size, true, UIScreen.mainScreen().scale)
            view.drawViewHierarchyInRect(view.bounds, afterScreenUpdates: false)
            backdropImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            backdropImage = backdropImage.applyDarkEffect()
            tableOfContentViewController.backdropImage = backdropImage
            tableOfContentViewController.transitioningDelegate = self
        }
    }
    
    // MARK: Transition
    
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return SplashTransition()
    }
}