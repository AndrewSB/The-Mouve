//
//  CGGeometeryExtension.swift
//  The Mouve
//
//  Created by Andrew Breckenridge on 4/8/15.
//  Copyright (c) 2015 Andrew Breckenridge. All rights reserved.
//

import Foundation
import UIKit

enum TopBottom {
    case Top
    case Bottom
}

extension CGRect {
    static func CreateRectInCenterOfView(view: UIView, offset: CGFloat, height: CGFloat, width: CGFloat) -> CGRect {

        let rect = CGRectMake((view.frame.width / 2) - width/2, (view.frame.height) - height, width, height)
        
        return rect
    }
}