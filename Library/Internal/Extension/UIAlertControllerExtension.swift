//
//  UIAlertControllerExtension.swift
//  The Mouve
//
//  Created by Andrew Breckenridge on 5/4/15.
//  Copyright (c) 2015 Andrew Breckenridge. All rights reserved.
//

import UIKit

extension UIAlertController {
    convenience init(title: String, message: String) {
        self.init(title: title, message: message, preferredStyle: .Alert)
        self.addAction(UIAlertAction(title: "Ok", style: .Cancel, handler: nil))
    }
}