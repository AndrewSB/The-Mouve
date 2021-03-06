//
//  Event.swift
//  The Mouve
//
//  Created by Andrew Breckenridge on 4/28/15.
//  Copyright (c) 2015 Andrew Breckenridge. All rights reserved.
//

import UIKit
import Parse

class Event {
    var name: String
    
    var time: NSDate
    var length: NSTimeInterval
    
    var about: String
    
    var address: String
    var location: CLLocation?
    
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
    }
    
    init(parseObject: PFObject) {
        self.name = parseObject["name"] as! String
        
        self.about = parseObject["about"] as! String
        self.address = parseObject["address"] as! String
        
        if let data = parseObject["backgroundImage"] as? NSData {
            self.backgroundImage = UIImage(data: data, scale: 1)!
        } else {
            self.backgroundImage = UIImage()
        }
        
        self.location = parseObject["location"] as? CLLocation
        self.time = parseObject["time"] as! NSDate
        self.length = 100
        
        self.invitees = ["lol", "dsa", "dsaetd"]//parseObject["invitees"] as! [String]
    }
}
