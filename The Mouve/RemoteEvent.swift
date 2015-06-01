//
//  RemoteEvent.swift
//  The Mouve
//
//  Created by Andrew Breckenridge on 5/19/15.
//  Copyright (c) 2015 Andrew Breckenridge. All rights reserved.
//

import UIKit
import Parse
import CoreLocation

class RemoteEvent: PFObject {
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
        
        super.init(className: "Event")
    }
    
    convenience init(event: Event) {
        self.init(name: event.name, about: event.about, time: event.time, length: event.length, address: event.address, invitees: event.invitees, backgroundImage: event.backgroundImage)
        
        self.location = event.location
    }

}