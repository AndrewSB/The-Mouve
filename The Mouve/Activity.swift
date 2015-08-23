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
    case Invite = "invite"
}

class Activity: PFObject {
    @NSManaged var typeKey: String
    @NSManaged var fromUser: PFUser
    @NSManaged var toUser: PFUser
    @NSManaged var stringContent: String
    @NSManaged var mediaFile: PFFile
    @NSManaged var onMouve: Events
    
    override init(){
        super.init()
        println("Initialized empty event")
    }
    init(type: typeKeyEnum, targetUser: PFUser, stringContent: String, mediaFile: UIImage, targetMouve: Events) {
            super.init(className: "Activity")
            self.fromUser = PFUser.currentUser()!
            self.toUser = targetUser
            self.stringContent = stringContent
            self.onMouve = targetMouve
        
            self.mediaFile = PFFile(name: "\(self.fromUser.username)_\(self.onMouve.objectId)_\(self.objectId).jpg", data:UIImageJPEGRepresentation(mediaFile, 0.7))
            
            
    }
    override class func query() -> PFQuery? {
        //1
        let query = PFQuery(className: Activity.parseClassName())
        //        query.cachePolicy = PFCachePolicy.CacheElseNetwork
        //2
        query.includeKey("fromUser")
        query.includeKey("onMouve")
        //3
        query.orderByAscending("createdAt")
        return query
    }
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