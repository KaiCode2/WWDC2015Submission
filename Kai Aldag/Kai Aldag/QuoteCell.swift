//
//  QuoteCell.swift
//  Kai Aldag
//
//  Created by Kai Aldag on 2015-04-21.
//  Copyright (c) 2015 Kai Aldag. All rights reserved.
//

import UIKit

class QuoteCell: UICollectionViewCell {
    @IBOutlet weak var textLabel: UILabel!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        textLabel.text = nil
    }
}
