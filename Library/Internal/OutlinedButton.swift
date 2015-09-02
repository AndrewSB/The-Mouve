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
        
        self.layer.borderColor = color.CGColor
        viewSetup()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.layer.borderColor = self.titleLabel!.textColor.CGColor
        viewSetup()
    }
    
    func viewSetup() {
        self.layer.cornerRadius = 6
        self.layer.borderWidth = 1
        
        self.backgroundColor = UIColor.clearColor()
        
//        self.titleLabel?.frame = CGRect(view: self, height: self.frame.height - 5, width: self.frame.width - 10)
        
        self.titleLabel?.font = UIFont(name: "HalisGR-Light", size: 16)
        self.setTitleColor(UIColor(CGColor: self.layer.borderColor!), forState: .Normal)
    }
}

class smallTextOutlinedButton: UIButton {
    convenience init(frame: CGRect, color: UIColor) {
        self.init(frame: frame)
        
        self.layer.borderColor = color.CGColor
        viewSetup()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.layer.borderColor = self.titleLabel!.textColor.CGColor
        viewSetup()
    }
    
    func viewSetup() {
        self.layer.cornerRadius = 5
        self.layer.borderWidth = 1
        
        self.backgroundColor = UIColor.clearColor()
        
        //        self.titleLabel?.frame = CGRect(view: self, height: self.frame.height - 5, width: self.frame.width - 10)
        
        self.titleLabel?.font = UIFont(name: "HalisGR-Light", size: 14)
        self.setTitleColor(UIColor(CGColor: self.layer.borderColor!), forState: .Normal)
    }
}
