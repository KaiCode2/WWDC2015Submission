//
//  ParagraphCell.swift
//  Kai Aldag
//
//  Created by Kai Aldag on 2015-04-11.
//  Copyright (c) 2015 Kai Aldag. All rights reserved.
//

import UIKit

class ParagraphCell: UICollectionViewCell {
    @IBOutlet weak var textLabel: UILabel!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        textLabel.text = nil
        textLabel.alpha = 0
    }
    
    func animateCell() {
        UIView.animateWithDuration(1.2, animations: { () -> Void in
            self.textLabel.alpha = 1
        })
    }
}
