//
//  MouveModel.swift
//  The Mouve
//
//  Created by Andrew Breckenridge on 8/3/15.
//  Copyright (c) 2015 Andrew Breckenridge. All rights reserved.
//

import Foundation
import CoreLocation

class MouveModel {
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
}

class MouveRecords: DefaultRecords {
    
}
