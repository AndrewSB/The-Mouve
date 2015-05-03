//
//  BaseParseObject.swift
//  The Mouve
//
//  Created by Andrew Breckenridge on 4/28/15.
//  Copyright (c) 2015 Andrew Breckenridge. All rights reserved.
//

import UIKit
import Parse

class BaseParseObject: NSObject {
    var className: String
    var objectID: String
    var createdAt: NSDate
    var updatedAt: NSDate

    var timeSinceCreation: NSTimeInterval {
        get {
            return createdAt.timeIntervalSinceNow
        }
    }
    
    init(parseObject: PFObject) {
        self.objectID = parseObject.objectId!
        self.createdAt = parseObject.createdAt!
        self.updatedAt = parseObject.updatedAt!
        self.className = parseObject.parseClassName
    }
}
