//
//  TableOfContentCell.swift
//  Kai Aldag
//
//  Created by Kai Aldag on 2015-04-18.
//  Copyright (c) 2015 Kai Aldag. All rights reserved.
//

import UIKit

class TableOfContentCell: UICollectionViewCell {
    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var heroImageView: UIImageView!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        textLabel.text = nil
        heroImageView.image = nil
    }
}
