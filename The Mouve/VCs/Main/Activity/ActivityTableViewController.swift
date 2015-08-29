//
//  ActivityTableViewController.swift
//  The Mouve
//
//  Created by Andrew Breckenridge on 4/25/15.
//  Copyright (c) 2015 Andrew Breckenridge. All rights reserved.
//

import UIKit

class ActivityTableViewController: UIViewController {
    var type: SceneType!
    var feedData: [Activity]?{
        didSet {
            self.tableViewDidLoad()
            self.feedTableView.reloadData()
        }
    }

    @IBOutlet weak var feedTableView: UITableView!
    
    let labelData = ["you went to this event!", "you've been invited to espresso lessons", "chelsea liked your photo", "noah is attending surf lessons", "taylor sent you a PM"]
    let imageData = ["andrew-pic", "yoojin-pic", "chelsea-pic", "noah-pic", "taylor-pic"]

    override func viewDidLoad() {
        super.viewDidLoad()

        feedTableView.delegate = self
        feedTableView.dataSource = self
        let feedQuery = Activity.query()
        switch type! {

            case .Newsfeed:
                //            println("lol")
                feedQuery?.whereKey("toUser", equalTo: appDel.currentUser!)
                
            case .Invites:
    //            Any invites that where created at least 24 hours ago
                feedQuery?.whereKey("createdAt", greaterThanOrEqualTo: NSDate().yesterday().yesterday())
                feedQuery?.whereKey("typeKey", equalTo: typeKeyEnum.Invite.rawValue)
                feedQuery?.whereKey("toUser", equalTo: appDel.currentUser!)
            default:
                println("No option passed")
        }
        feedQuery?.findObjectsInBackgroundWithBlock(){(data: [AnyObject]?,error: NSError?) in
            if((error) != nil){
                println("Cannot create table")
            }
            else if let results = data as? [Activity]{
                self.feedData = results
            }
            else{
                println("Feed is empty move on")
            }

        }
        

    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        LocalMessage.post(type.hashValue == 1 ? .ActivityFeedPageOne : .ActivityFeedPageTwo)
    }
}

extension ActivityTableViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableViewDidLoad() {
        self.feedTableView.delegate = self
        self.feedTableView.dataSource = self
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return feedData == nil ? 0 : feedData!.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cellID") as! ActivityTableViewCell
        cell.type = self.type
        cell.activity = feedData?[indexPath.row]
        cell.hidden = true
//        cell.attributedLabel.text = labelData[indexPath.row]
//        cell.profileImageView.image = UIImage(named: imageData[indexPath.row])
        
        return cell
    }

    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView(frame: .zeroRect)
    }
}