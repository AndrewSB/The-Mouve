//
//  BaseObject.swift
//  The Mouve
//
//  Created by Andrew Breckenridge on 5/3/15.
//  Copyright (c) 2015 Andrew Breckenridge. All rights reserved.
//

import UIKit

class BaseObject: NSObject {
    var className: String
    
    init(className: String) {
        self.className = className
    }
}
