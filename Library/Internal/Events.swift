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
    @NSManaged var creator: PFUser
    @NSManaged var name: String
    @NSManaged var about: String
    @NSManaged var address: String
    @NSManaged var location: PFGeoPoint
    @NSManaged var startTime: NSDate
    @NSManaged var endTime: NSDate
    @NSManaged var privacy: Bool
    @NSManaged var invitees: [String]?
    @NSManaged var backgroundImage: PFFile?
    var actualImage: UIImage?
     
    
    var timeTillEvent: NSTimeInterval {
        get {
            return NSDate().timeIntervalSinceDate(startTime)
        }
        set {
            self.startTime = NSDate(timeIntervalSinceNow: newValue)
        }
    }
    override init(){
        super.init()
        println("Initialized empty event")
    }
    init(name: String, about: String, startTime: NSDate, endTime: NSDate, address: String,
        invitees: [String],
        privacy: Bool, backgroundImage: UIImage) {
        super.init(className: "Events")
        self.creator = PFUser.currentUser()!
        self.name = name
        self.about = about
        
        self.startTime = startTime
        self.endTime = endTime
        
        self.address = address
        self.invitees = invitees
            
        self.privacy = privacy
        
        self.backgroundImage = PFFile(name: "\(self.creator.username)_\(self.objectId).jpg", data:UIImageJPEGRepresentation(backgroundImage,0.7))
        

    }
//    func downloadBgImg(){
//        self.backgroundImage?.getDataInBackgroundWithBlock { (data: NSData?, error: NSError?) -> Void in
//            if(!(error != nil)){
//                if let data: AnyObject = data, image = UIImage(data: data as! NSData) {
//                    self.actualImage = image
//                    println("\(self.backgroundImage?.url)")
//                }
//            }
//            else{
//                self.actualImage = appDel.placeHolderBg
//            }
//        }
//    }
    func getBgImg() -> UIImage?{
        var imgData = self.backgroundImage?.getData()
        if(!(imgData != nil)){
            return appDel.placeHolderBg
        }
        return UIImage(data: imgData!)
    }
//    func getBgImg() -> UIImage?
//    {
//        downloadBgImg()
//        return self.actualImage
//    }


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
//        query.cachePolicy = PFCachePolicy.CacheElseNetwork
        //2
        query.includeKey("creator")
        //3
        query.orderByAscending("startDate")
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
extension PFUser{
    var fullName:String {
        
        get { return (self["fullName"] != nil ? (rawValue: self["fullName"] as? String) : nil)! }
        
        set { return self["fullName"] = newValue }
        
    }
    func getProfilePic() -> UIImage?{
        var imgData = self["profileImage"]?.getData()
            if(!(imgData != nil)){
                return appDel.placeHolderBg
            }
        return UIImage(data: imgData!)
    }
    func query() -> PFQuery? {
        //1
        let query = PFQuery(className: Events.parseClassName())
        //        query.cachePolicy = PFCachePolicy.CacheElseNetwork
        //2
        query.includeKey("username")
        //3
        query.orderByDescending("username")
        return query
    }
}
