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
    var length: NSTimeInterval
    
    var about: String
    
    var addressString: String
    var address: CLLocationCoordinate2D?
    
    var invitees: [String]
    
    
    var timeTillEvent: NSTimeInterval {
        get {
            return NSDate().timeIntervalSinceDate(time)
        }
        set {
            self.time = NSDate(timeIntervalSinceNow: newValue)
        }
    }
    
    init(name: String, about: String, time: NSDate, length: NSTimeInterval, addressString: String, invitees: [String]) {
        self.name = name
        self.about = about
        
        self.time = time
        self.length = length
        
        self.addressString = addressString
        self.invitees = invitees
        
        super.init(parseObject: PFObject(className: "Event"))
    }
}
