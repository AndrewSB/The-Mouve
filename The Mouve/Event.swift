//
//  Event.swift
//  The Mouve
//
//  Created by Andrew Breckenridge on 4/28/15.
//  Copyright (c) 2015 Andrew Breckenridge. All rights reserved.
//

import UIKit
import Parse

class Event: BaseObject {
    var name: String
    
    var time: NSDate
    var length: NSTimeInterval
    
    var about: String
    
    var address: String
    var location: CLLocationCoordinate2D?
    
    var invitees: [String]
    
    var backgroundImage: UIImage
    
    
    var timeTillEvent: NSTimeInterval {
        get {
            return NSDate().timeIntervalSinceDate(time)
        }
        set {
            self.time = NSDate(timeIntervalSinceNow: newValue)
        }
    }
    
    init(name: String, about: String, time: NSDate, length: NSTimeInterval, address: String, invitees: [String], backgroundImage: UIImage) {
        self.name = name
        self.about = about
        
        self.time = time
        self.length = length
        
        self.address = address
        self.invitees = invitees
        
        self.backgroundImage = backgroundImage
        
        super.init(className: "User")
    }
}
