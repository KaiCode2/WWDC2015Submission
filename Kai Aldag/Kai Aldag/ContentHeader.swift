//
//  ContentHeader.swift
//  Kai Aldag
//
//  Created by Kai Aldag on 2015-04-20.
//  Copyright (c) 2015 Kai Aldag. All rights reserved.
//

import UIKit

class ContentHeader: UICollectionReusableView {
    lazy var textLabel: UILabel! = {
        let blurredView = UIVisualEffectView(effect: UIBlurEffect(style: .ExtraLight))
        blurredView.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.addSubview(blurredView)
        self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("|[blurredView]|", options: nil, metrics: nil, views: ["blurredView": blurredView]))
        self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[blurredView]|", options: nil, metrics: nil, views: ["blurredView": blurredView]))
        
        let label = UILabel()
        label.setTranslatesAutoresizingMaskIntoConstraints(false)
        label.backgroundColor = UIColor.clearColor()
        label.font = UIFont(name: "AvenirNext-Medium", size: 17)
        blurredView.addSubview(label)
        blurredView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("|-24-[label]-24-|", options: nil, metrics: nil, views: ["label": label]))
        blurredView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[label]|", options: nil, metrics: nil, views: ["label": label]))
        return label
    }()
}