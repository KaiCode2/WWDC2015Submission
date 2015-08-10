//
//  AboutMeViewController.swift
//  Kai Aldag
//
//  Created by Kai Aldag on 2015-04-11.
//  Copyright (c) 2015 Kai Aldag. All rights reserved.
//

import UIKit

@objc protocol ContentViewControllerDelegate {
    func scrollViewDidScroll()
}

class ContentViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var imageViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var blurredImageViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var touchRightConstraint: NSLayoutConstraint!
    @IBOutlet weak var touchImageView: UIImageView!

    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            collectionView?.registerClass(ContentHeader.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "Header")
            collectionView?.registerClass(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "EmptyHeader")
        }
    }

    @IBOutlet weak var imageView: UIImageView! {
        didSet { updateHeroImage() }
    }
    
    @IBOutlet weak var blurredImageView: UIImageView! {
        didSet { updateHeroImage() }
    }
    
    var presenter: ContentPresenter! {
        didSet { updateHeroImage() }
    }
    
    weak var delegate: ContentViewControllerDelegate?
    
    static var guidedTourDisplayed: dispatch_once_t = 0
    
    var lastPage = false
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        touchImageView?.alpha = 0
        touchImageView?.removeFromSuperview()
        touchImageView = nil
    }
    
    // MARK: Convenience Methods
    
    func updateHeroImage() {
        if let presenter = presenter {
            imageView?.image = presenter.header.heroImage
            blurredImageView?.image = presenter.blurredImage
        }
    }
    
    // MARK: UICollectionViewDataSource
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return presenter.numberOfSections
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter.numberOfItemsInSection(section)
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            if indexPath.item == 0 {
                let cell = collectionView.dequeueReusableCellWithReuseIdentifier("UICollectionViewCell", forIndexPath: indexPath) as! UICollectionViewCell
                cell.backgroundColor = UIColor.clearColor()
                return cell
            } else {
                let cell = collectionView.dequeueReusableCellWithReuseIdentifier("TitleCell", forIndexPath: indexPath) as! TitleCell
                cell.titleLabel.text = presenter.header.title
                return cell
            }
        }
        
        let content = presenter.contentForItemAtIndexPath(indexPath)!
        switch content {
        case .Paragraph(let paragraph):
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("ParagraphCell", forIndexPath: indexPath) as! ParagraphCell
            cell.textLabel.text = paragraph
            return cell
            
        case .Image(let image, let text, let parallaxEnabled):
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("ImageCell", forIndexPath: indexPath) as! ImageCell
            cell.imageView.image = image
            cell.text = text
            cell.parallaxEnabled = parallaxEnabled
            return cell
            
        case .Quote(let quote):
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("QuoteCell", forIndexPath: indexPath) as! QuoteCell
            cell.textLabel.text = "\(quote)"
            return cell
            
        case .Shimmering(let text, let direction, let image):
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("FooterCell", forIndexPath: indexPath) as! FooterCell
            cell.text = text
            cell.shimmeringView.shimmeringDirection = direction
            cell.imageView.image = image
            return cell
            
        default: break
        }
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("UICollectionViewCell", forIndexPath: indexPath) as! UICollectionViewCell
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        if let section = presenter.sectionAtIndexPath(indexPath) {
            let view = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: "Header", forIndexPath: indexPath) as! ContentHeader
            view.textLabel.text = section.title
            return view
        }
        
        let view = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: "EmptyHeader", forIndexPath: indexPath) as! UICollectionReusableView
        return view
    }
    
    // MARK: UICollectionViewDelegateFlowLayout
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if section > 0 {
            return CGSize(width: view.bounds.width, height: 44)
        }
        
        return CGSizeZero
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        if indexPath.section == 0 {
            return CGSize(width: view.bounds.width, height: view.bounds.height / 2)
        }
        
        let content = presenter.contentForItemAtIndexPath(indexPath)!
        
        let margin: CGFloat = 24
        switch content {
        case .Paragraph(let paragraph):
            // Calculate the size for paragraph cells
            let attributes = [NSFontAttributeName: UIFont(name: "AvenirNext-Regular", size: 17)!]
            let estimateHeight = (paragraph as NSString).boundingRectWithSize(CGSize(width: view.bounds.width - margin * 2, height: CGFloat.max), options: .UsesLineFragmentOrigin | .UsesFontLeading , attributes: attributes, context: nil).height + margin
            return CGSize(width: view.bounds.width, height: ceil(estimateHeight))
            
        case .Image(let image, _, _):
            let height = view.bounds.width * image.size.height / image.size.width
            return CGSize(width: view.bounds.width, height: height)
            
        case .Quote(let quote):
            // Calculate the size for quotes cells
            let attributes = [NSFontAttributeName: UIFont(name: "Cochin-Italic", size: 21)!]
            let estimateHeight = (quote as NSString).boundingRectWithSize(CGSize(width: view.bounds.width - margin * 2, height: CGFloat.max), options: .UsesLineFragmentOrigin | .UsesFontLeading , attributes: attributes, context: nil).height + margin
            return CGSize(width: view.bounds.width, height: ceil(estimateHeight))
            
        case .Shimmering(_, _, _):
            return CGSize(width: view.bounds.width, height: 50)
            
        default: break
        }
        
        return CGSize(width: view.bounds.width, height: 100)
    }
        
    // MARK: UICollectionViewDelegate
    
    func collectionView(collectionView: UICollectionView, willDisplayCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        if let cell = cell as? ParagraphCell {
            cell.animateCell()
        } else if let cell = cell as? ImageCell {
            cell.animateCell()
        }
    }
    
    // MARK: UIScrollViewDelegate
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        delegate?.scrollViewDidScroll()
        
        let heroImageOffscreen = scrollView.contentOffset.y > UIScreen.mainScreen().bounds.height
        view.backgroundColor = heroImageOffscreen ? UIColor(white: 220/255.0, alpha: 1) : UIColor.whiteColor()
        
        if !heroImageOffscreen {
            let factor: CGFloat = 350.0
            let ratio = (UIScreen.mainScreen().bounds.height - scrollView.contentOffset.y) / UIScreen.mainScreen().bounds.height
            imageViewBottomConstraint.constant = -(ratio * factor - factor)
            blurredImageViewBottomConstraint.constant = -(ratio * factor - factor)
            view.layoutIfNeeded()
            
            if imageView.alpha == 0 || blurredImageView.alpha == 0 {
                UIView.animateWithDuration(0.1) {
                    self.imageView.alpha = ratio * 2
                    self.blurredImageView.alpha = 3/2 - ratio * 3/2
                }
            } else {
                imageView.alpha = ratio * 2
                blurredImageView.alpha = 3/2 - ratio * 3/2
            }
        } else {
            if imageView.alpha != 0 && blurredImageView.alpha != 0 {
                UIView.animateWithDuration(0.25) {
                    self.imageView.alpha = 0
                    self.blurredImageView.alpha = 0
                }
            }
        }
        
        for cell in collectionView.visibleCells() {
            if let cell = cell as? ImageCell where cell.parallaxEnabled {
                cell.imageView.frame.origin.y = (scrollView.contentOffset.y - cell.frame.origin.y) * 0.12
            }
        }
        
        if ceil(scrollView.contentOffset.y) >= ceil(abs(scrollView.contentSize.height - UIScreen.mainScreen().bounds.height)) {
            dispatch_once(&ContentViewController.guidedTourDisplayed) {
                if let touchImageView = self.touchImageView, image = touchImageView.image {
                    let initialPosition = !self.lastPage ? self.touchRightConstraint.constant : self.view.bounds.width - 30 - image.size.width
                    let finalPosition = !self.lastPage ? self.view.bounds.width - 30 - image.size.width : self.touchRightConstraint.constant
                    self.touchRightConstraint.constant = initialPosition
                    self.view.layoutIfNeeded()
                    
                    UIView.animateWithDuration(2, delay: 2, usingSpringWithDamping: 0.9, initialSpringVelocity: 1, options: .Repeat, animations: { () -> Void in
                        touchImageView.alpha = 1
                        self.touchRightConstraint.constant = finalPosition
                        self.view.layoutIfNeeded()
                    }, completion: { _ in
                        touchImageView.alpha = 0
                    })
                }
            }
        }
    }
}
