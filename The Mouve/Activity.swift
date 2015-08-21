//
//  Activity.swift
//  The Mouve
//
//  Created by Hilal Habashi on 8/21/15.
//  Copyright (c) 2015 Andrew Breckenridge. All rights reserved.
//

import Foundation
import Parse
enum typeKeyEnum:String {
    case AddImage = "addimage"
    case Follow = "follow"
    case Comment = "comment"
    case Attend = "attend"
}

class Activity: PFObject {
    @NSManaged var typeKey: String
    @NSManaged var fromUser: PFUser
    @NSManaged var toUser: PFUser
    @NSManaged var content: String
    @NSManaged var event: Events
}

extension Activity: PFSubclassing{
//    setting the type key as enum
    var type:typeKeyEnum? {
        
        get { return self["typeKey"] != nil ? typeKeyEnum(rawValue: self["typeKey"] as! String) : nil }
        
        set { return self["typeKey"] = newValue?.rawValue }
        
    }
    //1
    class func parseClassName() -> String {
        return "Activty"
    }
    
    //2
    override class func initialize() {
        var onceToken: dispatch_once_t = 0
        dispatch_once(&onceToken) {
            self.registerSubclass()
        }
    }
}