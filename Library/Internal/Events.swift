//
//  Events.swift
//  The Mouve
//
//  Created by Samuel Ojogbo on 8/18/15.
//  Copyright (c) 2015 Samuel Ojogbo. All rights reserved.
//

import UIKit
import Parse

class Events: PFObject {
    @NSManaged var author: PFUser
    @NSManaged var name: String
    @NSManaged var about: String
    @NSManaged var address: String
    @NSManaged var location: PFGeoPoint
    @NSManaged var startTime: NSDate
    @NSManaged var endTime: NSDate
    @NSManaged var privacy: Bool
    @NSManaged var invitees: [String]
    @NSManaged var backgroundImage: PFFile
    
    
    var timeTillEvent: NSTimeInterval {
        get {
            return NSDate().timeIntervalSinceDate(startTime)
        }
        set {
            self.startTime = NSDate(timeIntervalSinceNow: newValue)
        }
    }
    override init(){
        super.init(className: "Events")
        println("Initialized empty event")
    }
    init(name: String, about: String, startTime: NSDate, endTime: NSDate, address: String,
        invitees: [String],
        privacy: Bool, backgroundImage: UIImage) {
        super.init(className: "Events")
        self.name = name
        self.about = about
        
        self.startTime = startTime
        self.endTime = endTime
        
        self.address = address
        self.invitees = invitees
            
        self.privacy = privacy
        
        self.backgroundImage = PFFile(data:UIImageJPEGRepresentation(backgroundImage,1.0))
        

    }
//    init(parseObject: PFObject) {
//        self.name = parseObject["name"] as! String
//        
//        self.about = parseObject["about"] as! String
//        self.address = parseObject["address"] as! String
//        
//        if let data = parseObject["backgroundImage"] as? NSData {
//            self.backgroundImage = UIImage(data: data, scale: 1)!
//        } else {
//            self.backgroundImage = UIImage()
//        }
//        self.privacy = parseObject["privacy"] as! Bool
//        self.location = parseObject["location"] as? CLLocation
//        self.startTime = parseObject["start time"] as! NSDate
//        self.endTime = parseObject["end time"] as! NSDate
//        
//        self.invitees = parseObject["invitees"] as! [String]//["lol", "dsa", "dsaetd"]
//        
//        super.init(className: "Events")
//    }
    override class func query() -> PFQuery? {
        //1
        let query = PFQuery(className: Events.parseClassName())
        //2
        query.includeKey("author")
        //3
        query.orderByDescending("createdAt")
        return query
    }
    
}
extension Events: PFSubclassing {
    // Table view delegate methods here
    //1
    class func parseClassName() -> String {
        return "Events"
    }
    
    //2
    override class func initialize() {
        var onceToken: dispatch_once_t = 0
        dispatch_once(&onceToken) {
            self.registerSubclass()
        }
    }
}
