//
//  GreyGreenButton.swift
//  The Mouve
//
//  Created by Andrew Breckenridge on 5/5/15.
//  Copyright (c) 2015 Andrew Breckenridge. All rights reserved.
//

import UIKit

class GreyGreenButton: UIButton {
    var completed: Bool? {
        didSet {
            if completed! {
                layer.borderColor = UIColor.seaFoamGreen().CGColor
                tintColor = UIColor.whiteColor()
            } else {
                layer.borderColor = UIColor.lightGrayColor().CGColor
                tintColor = UIColor.lightGrayColor()
            }
        }
    }
    
    override func awakeFromNib() {
        if completed == nil {
            completed = false
        }
        
        super.awakeFromNib()
        layer.cornerRadius = frame.height / 2
        layer.borderWidth = 1
        
        if let completed = completed where completed {
            layer.borderColor = UIColor.seaFoamGreen().CGColor
            tintColor = UIColor.whiteColor()
        } else {
            layer.borderColor = UIColor.lightGrayColor().CGColor
            tintColor = UIColor.lightGrayColor()
        }
    }
}
