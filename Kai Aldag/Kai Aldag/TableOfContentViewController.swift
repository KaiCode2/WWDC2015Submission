//
//  TableOfContentViewController.swift
//  Kai Aldag
//
//  Created by Kai Aldag on 2015-04-18.
//  Copyright (c) 2015 Kai Aldag. All rights reserved.
//

import UIKit

class TableOfContentViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UIViewControllerTransitioningDelegate, TableOfContentTransitionDelegate {
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var backdropImageView: UIImageView!
    var backdropImage: UIImage!
    var currentCell: TableOfContentCell?
    var cellRect = CGRectZero
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 20
        layout.minimumLineSpacing = 20
        layout.scrollDirection = .Horizontal
        layout.itemSize = CGSize(width: view.bounds.width / 1.5, height: view.bounds.height / 1.5)
        collectionView.setCollectionViewLayout(layout, animated: false)
        var contentInset = collectionView.contentInset
        contentInset.left = (view.bounds.width - layout.itemSize.width) / 2
        contentInset.right = (view.bounds.width - layout.itemSize.width) / 2
        collectionView.contentInset = contentInset
        backdropImageView.image = backdropImage
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let contentViewController = segue.destinationViewController as? ContainerViewController, cell = sender as? UICollectionViewCell, indexPath = collectionView.indexPathForCell(cell) {
            contentViewController.initialViewControllerIndex = indexPath.item
            contentViewController.transitioningDelegate = self
        }
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    // MARK: Collection View Data Source
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return count(TableOfContent.presenters)
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("TableOfContentCell", forIndexPath: indexPath) as! TableOfContentCell
        cell.textLabel.text = TableOfContent.presenters[indexPath.item].header.title
        cell.heroImageView.image = TableOfContent.presenters[indexPath.item].header.heroImage
        return cell
    }
    
    // MARK: Collection View Delegate
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        for cell in collectionView.visibleCells() as! [TableOfContentCell] {
            cell.heroImageView.frame.origin.x = (scrollView.contentOffset.x - cell.frame.origin.x) * 0.06
        }
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if let cell = collectionView.cellForItemAtIndexPath(indexPath) as? TableOfContentCell {
            currentCell = cell
            cellRect = collectionView.convertRect(cell.frame, toCoordinateSpace: view)
            UIView.animateWithDuration(0.25, animations: { () -> Void in
                cell.heroImageView.frame.origin.x = 0
            })
            performSegueWithIdentifier("showContent", sender: cell)
        }
    }
    
    // MARK: Transition
    
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return TableOfContentTransition(presentation: true)
    }
    
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return TableOfContentTransition(presentation: false)
    }
    
    func presentationControllerForPresentedViewController(presented: UIViewController, presentingViewController presenting: UIViewController!, sourceViewController source: UIViewController) -> UIPresentationController? {
        return TableOfContentTransitionPresentationController(presentedViewController: presentedViewController, presentingViewController: presentedViewController)
    }
    
    // MARK: TableOfContentTransitionDelegate
    
    var transitionImage: UIImage? {
        return currentCell?.heroImageView.image
    }
    
    var transitionImageRect: CGRect {
        return cellRect
    }
    
    func transitionAnimationWillBegin() {
        currentCell?.alpha = 0
    }
    
    func transitionAnimationDidEnd() {
        currentCell?.alpha = 1
    }
}