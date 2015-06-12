//
//  UnderlinedTextField.swift
//  The Mouve
//
//  Created by Andrew Breckenridge on 5/4/15.
//  Copyright (c) 2015 Andrew Breckenridge. All rights reserved.
//

import UIKit

class UnderlinedTextField: UITextField {
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let f = self.frame
        
        let underlineView = UIView(frame: CGRect(x: 0, y: f.height-2, width: f.width, height: 2))
        underlineView.backgroundColor = tintColor
        self.addSubview(underlineView)
    }
}
