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

        
        return cell
    }

}