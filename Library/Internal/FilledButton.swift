//
//  FilledButton.swift
//  The Mouve
//
//  Created by Andrew Breckenridge on 5/8/15.
//  Copyright (c) 2015 Andrew Breckenridge. All rights reserved.
//

import UIKit

class FilledButton: UIButton {
    convenience init(frame: CGRect, color: UIColor) {
        self.init(frame: frame)
        
        self.backgroundColor = color
        viewSetup()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        viewSetup()
    }
    
    func viewSetup() {
        self.layer.cornerRadius = 6
        self.setTitleColor(UIColor.blackColor(), forState: .Normal)
        self.titleLabel?.font = UIFont(name: "HalisGR-Light", size: 16)
    }

}
