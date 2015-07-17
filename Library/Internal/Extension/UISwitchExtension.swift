//
//  UISwitchExtension.swift
//  The Mouve
//
//  Created by Samuel Ifeanyi Ojogbo Jr. on 7/17/15.
//  Copyright (c) 2015 Andrew Breckenridge. All rights reserved.
//

import Foundation

extension UISwitch{
    convenience init(value: Bool){
        self.init()
        self.on = value
        self.tintColor = UIColor.lightSeaFoamGreen()
        self.onTintColor = UIColor.lightSeaFoamGreen()
        self.thumbTintColor = UIColor.seaFoamGreen()
        
    }
}
