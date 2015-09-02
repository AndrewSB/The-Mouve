//
//  Events.swift
//  The Mouve
//
//  Created by Samuel Ojogbo on 8/18/15.
//  Copyright (c) 2015 Samuel Ojogbo. All rights reserved.
//

import UIKit
import Parse
import Toucan

enum MouveRecordState {
    case New, DownloadedAll, FilteredAll, Failed
}
class PendingOperations {
    lazy var downloadsInProgress = [NSIndexPath:NSOperation]()
    lazy var downloadQueue:NSOperationQueue = {
        var queue = NSOperationQueue()
        queue.name = "Download queue"
//        queue.maxConcurrentOperationCount = 1
        return queue
        }()
    
    lazy var filtrationsInProgress = [NSIndexPath:NSOperation]()
    lazy var filtrationQueue:NSOperationQueue = {
        var queue = NSOperationQueue()
        queue.name = "Image Filtration queue"
////        Change to hire number to improve perf
//        queue.maxConcurrentOperationCount = 1
        return queue
        }()
}

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
    var localBgImg:UIImage?
    var creatorPfImg:UIImage?
    var state: MouveRecordState
    var invitedUsers =  [PFUser]()
    
    
    var timeTillEvent: NSTimeInterval {
        get {
            return NSDate().timeIntervalSinceDate(startTime)
        }
        set {
            self.startTime = NSDate(timeIntervalSinceNow: newValue)
        }
    }
    override init(){
        self.state = .New
        self.localBgImg = UIImage(named: "mouve-icon")
        self.creatorPfImg = UIImage(named: "mouve-icon")
        super.init()

    }
    init(name: String, about: String, startTime: NSDate, endTime: NSDate, address: String,
        invitees: [String],
        privacy: Bool, backgroundImage: UIImage) {
        self.state = .New
        super.init(className: "Events")
        self.creator = PFUser.currentUser()!
        self.name = name
        self.about = about
        
        self.startTime = startTime
        self.endTime = endTime
        
        self.address = address
        self.invitees = invitees
            
        self.privacy = privacy
        
        self.backgroundImage = PFFile(name: "\(self.creator.username)_\(self.objectId).jpg", data:UIImageJPEGRepresentation(backgroundImage,0.7)!)
        

    }

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

class ImageDownloader: NSOperation {
    //1
    let eventRecord: Events
    
    //2
    init(eventRecord: Events) {
        self.eventRecord = eventRecord
    }
    
    //3
    override func main() {
        //4
        if self.cancelled {
            return
        }
        //5

        ParseUtility.getEventBgImg(self.eventRecord){(img: UIImage?,error: NSError?) in
            if(((error) != nil) || (img == nil)){
                self.eventRecord.localBgImg = appDel.placeHolderBg!
            }
            else if self.cancelled {
                return
            }
            else{
                self.eventRecord.localBgImg = img!
                print("Download BG for \(self.eventRecord.name)")
            }
            ParseUtility.getProfileImg(self.eventRecord.creator){(img: UIImage?,error: NSError?) in
                if(((error) != nil) || (img == nil)){
                    self.eventRecord.localBgImg = appDel.placeHolderBg!
                }
                else if self.cancelled{
                    return
                }
                else{
                    print("Download Prof Pic for \(self.eventRecord.name)")
                    self.eventRecord.creatorPfImg = img!
                }
                return
            }
            

        }


    }
}


class ImageFiltration: NSOperation {
    let cell: HomeEventTableViewCell
    
    init(cell: HomeEventTableViewCell) {
        self.cell = cell
        print("Filteration started on \(self.cell.event.name)")
    }
    
    //3
    func filterPfImage(onCompletion:(img: UIImage) -> ()){
                onCompletion(img: Toucan(image: self.cell.event.creatorPfImg!).resize(CGSize(width: self.cell.profileImageView.bounds.width, height: self.cell.profileImageView.bounds.height), fitMode: Toucan.Resize.FitMode.Crop).maskWithEllipse(1.5, borderColor: UIColor.whiteColor()).image)
    }
    func filterBgImage(onCompletion:(img: UIImage) -> ()){
                onCompletion(img: Toucan(image: self.cell.event.localBgImg!.applyLightEffect()!).resize(CGSize(width: self.cell.backgroundImageView.bounds.width, height: self.cell.backgroundImageView.bounds.height), fitMode: Toucan.Resize.FitMode.Crop).image)
    }
    override func main() {
        filterBgImage(){(bgImg: UIImage) -> () in
            self.cell.backgroundImageView.image = bgImg
            self.filterPfImage(){(pfImg: UIImage) -> () in
                self.cell.profileImageView.image = pfImg
                return
            }
        }

    }
}
extension PFUser{
    var fullName:String {
        
        get { return (self["fullName"] != nil ? (rawValue: self["fullName"] as? String) : nil)! }
        
        set { return self["fullName"] = newValue }
        
    }
    var profileImage: PFFile?{
        get { return (self["profileImage"] != nil ? (rawValue: self["profileImage"] as? PFFile) : nil)! }
        
        set { return self["profileImage"] = newValue }
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
