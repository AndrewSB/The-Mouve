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
    @IBOutlet weak var feedTableView: UITableView!
    
    let labelData = ["you went to this event!", "you've been invited to espresso lessons", "chelsea liked your photo", "noah is attending surf lessons", "taylor sent you a PM"]
    let imageData = ["andrew-pic", "yoojin-pic", "chelsea-pic", "noah-pic", "taylor-pic"]

    override func viewDidLoad() {
        super.viewDidLoad()
        tableViewDidLoad()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        LocalMessage.post(type.hashValue == 2 ? .ActivityFeedPageOne : .ActivityFeedPageTwo)
    }
}

extension ActivityTableViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableViewDidLoad() {
        self.feedTableView.delegate = self
        self.feedTableView.dataSource = self
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cellID") as! ActivityTableViewCell
        
        cell.attributedLabel.text = labelData[indexPath.row]
        cell.profileImageView.image = UIImage(named: imageData[indexPath.row])
        
        cell.type = self.type
        if type == .Newsfeed {
            (cell.calendarButton as? GreyGreenButton)?.type = .Activity
        }
        
        return cell
    }

    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView(frame: .zeroRect)
    }
}