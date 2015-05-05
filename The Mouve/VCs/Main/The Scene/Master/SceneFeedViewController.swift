//
//  SceneFeedViewController.swift
//  The Mouve
//
//  Created by Andrew Breckenridge on 4/8/15.
//  Copyright (c) 2015 Andrew Breckenridge. All rights reserved.
//

import UIKit

let data = ["people", "will", "go"]
let otherData = ["out", "to", "shit"]

class SceneFeedViewController: UIViewController {
    var type: SceneType!
    @IBOutlet weak var feedTableView: UITableView!
    
    convenience init(type: SceneType) {
        self.init()
        self.type = type
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        feedTableView.delegate = self
        feedTableView.dataSource = self
        
        feedTableView.contentInset = UIEdgeInsets(top: 44+22, left: 0, bottom: 44, right: 0)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        LocalMessage.post(type.hashValue == 0 ? .HomeFeedPageTwo : .HomeFeedPageOne)
    }
}

extension SceneFeedViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 20
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cellID") as! HomeEventTableViewCell
        
        
        return cell
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? 0 : 4
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    
    @IBAction func unwindToHomeFeed(segue: UIStoryboardSegue) {}
}