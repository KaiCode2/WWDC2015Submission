//
//  ImageCell.swift
//  Kai Aldag
//
//  Created by Kai Aldag on 2015-04-16.
//  Copyright (c) 2015 Kai Aldag. All rights reserved.
//

import UIKit

class ImageCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var gradientView: UIImageView!
    
    @IBOutlet weak var textLabel: UILabel!
    
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    var parallaxEnabled = false {
        didSet {
            topConstraint?.constant = parallaxEnabled ? -25 : 0
            bottomConstraint?.constant = parallaxEnabled ? -25 : 0
            backgroundColor = parallaxEnabled ? UIColor.blackColor() : UIColor.whiteColor()
            layoutIfNeeded()
        }
    }
    
    var text: String? {
        didSet {
            if let text = text where count(text) > 0 {
                textLabel?.text = text
                gradientView.hidden = false
            } else {
                textLabel?.text = nil
                gradientView.hidden = true
            }
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.alpha = 0
        textLabel?.text = nil
        gradientView.hidden = true
    }
    
    func animateCell() {
        UIView.animateWithDuration(1.2, animations: { () -> Void in
            self.imageView.alpha = 1
        })
    }
}
