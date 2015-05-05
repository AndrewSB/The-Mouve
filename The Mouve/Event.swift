//
//  Event.swift
//  The Mouve
//
//  Created by Andrew Breckenridge on 4/28/15.
//  Copyright (c) 2015 Andrew Breckenridge. All rights reserved.
//

import UIKit
import Parse

class Event: BaseParseObject {
    var name: String
    
    var time: NSDate
//    var length: NSTimeInterval
//    
//    var about: String
//    
//    var address: CLLocationCoordinate2D
    
    
    var timeTillEvent: NSTimeInterval {
        get {
            return NSDate().timeIntervalSinceDate(time)
        }
        set {
            self.time = NSDate(timeIntervalSinceNow: newValue)
        }
    }
    
    init(name: String, time: NSDate) {
        self.name = name
        self.time = time
        
        
        super.init(parseObject: PFObject(className: "Event"))
    }
}
