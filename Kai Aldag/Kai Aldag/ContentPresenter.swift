//
//  ContentPresenter.swift
//  Kai Aldag
//
//  Created by Kai Aldag on 2015-04-14.
//  Copyright (c) 2015 Kai Aldag. All rights reserved.
//

import UIKit

struct ContentPresenter {
    let header: Header
    let blurredImage: UIImage?
    let sections: [Section]
    
    init(header: Header, sections: [Section]) {
        self.header = header
        blurredImage = header.heroImage.applyBlur(radius: 12, tintColor: UIColor(white: 1, alpha: 0.3), saturationDeltaFactor: 1)
        self.sections = sections
    }
    
    var numberOfSections: Int {
        return count(sections) + 1  // +1 for header content
    }
    
    func numberOfItemsInSection(section: Int) -> Int {
        if section == 0 {
            return 2
        }
        
        return count(sections[section - 1].content) // -1 for header content
    }
    
    func sectionAtIndexPath(indexPath: NSIndexPath) -> Section! {
        if indexPath.section == 0 {
            return nil  // header section does not have content
        }
        
        return sections[indexPath.section - 1]
    }
    
    func contentForItemAtIndexPath(indexPath: NSIndexPath) -> Content! {
        if indexPath.section == 0 {
            return nil  // header section does not have content
        }
        
        return sections[indexPath.section - 1].content[indexPath.item]   // -1 for header content
    }
}