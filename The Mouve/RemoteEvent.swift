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

extension PFObject {
    convenience init(event: Event) {
//    class func ObjectWithEvent(event: Event) -> PFObject {
        self.init(className: "Events")
        
        self["name"] = event.name
        self["about"] = event.about
        self["address"] = event.address
        self["backgroundImage"] = PFFile(name: "bg.jpg", data: UIImageJPEGRepresentation(event.backgroundImage, 0.6), contentType: "jpg")
        self["location"] = PFGeoPoint(location: event.location!)
        self["time"] = event.time
    }
}

//class RemoteEvent: PFObject {
//    var name: String
//    
//    var time: NSDate
//    var length: NSTimeInterval
//    
//    var about: String
//    
//    var address: String
//    var location: CLLocation?
//    
//    var invitees: [String]
//    
//    var backgroundImage: UIImage
//    
//    
//    var timeTillEvent: NSTimeInterval {
//        get {
//            return NSDate().timeIntervalSinceDate(time)
//        }
//        set {
//            self.time = NSDate(timeIntervalSinceNow: newValue)
//        }
//    }
//    
//    init(name: String, about: String, time: NSDate, length: NSTimeInterval, address: String, invitees: [String], backgroundImage: UIImage) {
//        self.name = name
//        self.about = about
//        
//        self.time = time
//        self.length = length
//        
//        self.address = address
//        self.invitees = invitees
//        
//        self.backgroundImage = backgroundImage
//        
//        super.init(className: "Event")
//    }
//    
//    convenience init(event: Event) {
//        self.init(name: event.name, about: event.about, time: event.time, length: event.length, address: event.address, invitees: event.invitees, backgroundImage: event.backgroundImage)
//        
//        self.location = event.location
//    }
//
//}
