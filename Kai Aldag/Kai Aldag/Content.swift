//
//  Content.swift
//  Kai Aldag
//
//  Created by Kai Aldag on 2015-04-14.
//  Copyright (c) 2015 Kai Aldag. All rights reserved.
//

import UIKit

enum Content {
    case Paragraph(String)
    case Image(UIImage, String?, Bool)
    case Quote(String)
    case Shimmering(String, ShimmerDirection, UIImage)
}