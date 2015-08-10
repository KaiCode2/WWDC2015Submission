//
//  FooterCell.swift
//  Kai Aldag
//
//  Created by Kai Aldag on 2015-04-24.
//  Copyright (c) 2015 Kai Aldag. All rights reserved.
//

import UIKit

class FooterCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var shimmeringView: ShimmeringView! {
        didSet {
            if let shimmeringView = shimmeringView {
                textLabel?.removeFromSuperview()
                textLabel = UILabel(frame: shimmeringView.bounds)
                textLabel.textAlignment = .Center
                textLabel.font = UIFont(name: "AvenirNext-Medium", size: 17)
                textLabel.textColor = UIColor.blackColor()
                shimmeringView.shimmeringAnimationOpacity = 0.2
                shimmeringView.contentView = textLabel
            }
        }
    }
    
    var textLabel: UILabel!
    
    var text: String! {
        didSet {
            textLabel?.text = text
            shimmeringView?.shimmering = true
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
        textLabel.text = nil
    }
}