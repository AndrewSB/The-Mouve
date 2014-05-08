//
//  OutlinedButton.swift
//  The Mouve
//
//  Created by Andrew Breckenridge on 5/8/15.
//  Copyright (c) 2015 Andrew Breckenridge. All rights reserved.
//

import UIKit

class OutlinedButton: UIButton {
    convenience init(frame: CGRect, color: UIColor) {
        self.init(frame: frame)
        
        self.layer.cornerRadius = 6
        self.layer.borderColor = color.CGColor
        self.layer.borderWidth = 4
        
        self.backgroundColor = UIColor.clearColor()
        
        self.titleLabel?.textColor = color
        self.titleLabel?.font = UIFont(name: "HalisGR-Regular", size: 16)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
