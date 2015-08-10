//
//  ContainerViewController.swift
//  Kai Aldag
//
//  Created by Kai Aldag on 2015-04-18.
//  Copyright (c) 2015 Kai Aldag. All rights reserved.
//

import UIKit

class ContainerViewController: UIViewController, UIPageViewControllerDataSource, TableOfContentTransitionDelegate, ContentViewControllerDelegate {
    var pageViewController: UIPageViewController?
    var currentViewController: ContentViewController?
    var initialViewControllerIndex: Int = 0
    
    @IBOutlet weak var touchTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var touchImageView: UIImageView!
    static var guidedTourDisplayed: dispatch_once_t = 0

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        dispatch_once(&ContainerViewController.guidedTourDisplayed) {
            UIView.animateWithDuration(2.5, delay: 2, usingSpringWithDamping: 0.9, initialSpringVelocity: 1, options: .Repeat, animations: { () -> Void in
                self.touchImageView?.alpha = 1
                self.touchTopConstraint.constant = 64
                self.view.layoutIfNeeded()
            }, completion: { _ in
                self.touchImageView?.alpha = 0
            })
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let pageViewController = segue.destinationViewController as? UIPageViewController {
            self.pageViewController = pageViewController
            pageViewController.dataSource = self
            
            let initialContentViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("ContentViewController") as! ContentViewController
            initialContentViewController.presenter = TableOfContent.presenters[initialViewControllerIndex]
            initialContentViewController.delegate = self
            initialContentViewController.lastPage = initialViewControllerIndex == count(TableOfContent.presenters) - 1
            currentViewController = initialContentViewController
            pageViewController.setViewControllers([initialContentViewController], direction: .Forward, animated: false, completion: nil)
        }
    }
    
    // MARK: UIPageViewControllerDataSource
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        let currentViewController = viewController as! ContentViewController
        let currentPresenterTitle = currentViewController.presenter.header.title
        let presenterTitles = TableOfContent.presenters.map { $0.header.title }
        
        if let index = find(presenterTitles, currentPresenterTitle) where index - 1 >= 0 && index - 1 < count(TableOfContent.presenters) {
            let previousViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("ContentViewController") as! ContentViewController
            previousViewController.presenter = TableOfContent.presenters[index - 1]
            previousViewController.delegate = self
            previousViewController.lastPage = initialViewControllerIndex == count(TableOfContent.presenters) - 1
            self.currentViewController = previousViewController
            return previousViewController
        }
        
        return nil
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        let currentViewController = viewController as! ContentViewController
        let currentPresenterTitle = currentViewController.presenter.header.title
        let presenterTitles = TableOfContent.presenters.map { $0.header.title }
        
        if let index = find(presenterTitles, currentPresenterTitle) where index + 1 >= 0 && index + 1 < count(TableOfContent.presenters) {
            let nextViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("ContentViewController") as! ContentViewController
            nextViewController.presenter = TableOfContent.presenters[index + 1]
            nextViewController.delegate = self
            nextViewController.lastPage = initialViewControllerIndex == count(TableOfContent.presenters) - 1
            self.currentViewController = nextViewController
            return nextViewController
        }
        
        return nil
    }
    
    // MARK: ContentViewControllerDelegate
    
    func scrollViewDidScroll() {
        touchImageView?.alpha = 0
        touchImageView?.removeFromSuperview()
        touchImageView = nil
    }
    
    // MARK: Status Bar
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    // MARK: -
    
    @IBAction func backButtonTapped(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: TableOfContentTransitionDelegate
    
    var transitionImage: UIImage? {
        return currentViewController?.imageView.image
    }
    
    var transitionImageRect: CGRect {
        return UIScreen.mainScreen().bounds
    }
}