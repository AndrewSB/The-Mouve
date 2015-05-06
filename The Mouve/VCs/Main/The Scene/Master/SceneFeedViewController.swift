//
//  SceneFeedViewController.swift
//  The Mouve
//
//  Created by Andrew Breckenridge on 4/8/15.
//  Copyright (c) 2015 Andrew Breckenridge. All rights reserved.
//

import UIKit

let data = [Event(name: "Beach Chillin", about: "Bring your swim suits! We will be chilling at the Lincoln Park Beach", time: NSDate(), length: 0, addressString: "Lincoln Beach", invitees: [43,43,43,43,43,43,4,3,4,343,43,34].map({"\($0)"}), backgroundImage: UIImage(named: "Beach-Chillin")!), Event(name: "Coffee Hour", about: "Let’s grab cup of coffee and discuss about fun things!", time: NSDate(), length: 3, addressString: "Cafe Kopi", invitees: [43,43,43,43,43,43,4,3,4,343,43,34].map({"\($0)"}), backgroundImage: UIImage(named: "Coffee-Hour")!)]

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
        return data.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cellID") as! HomeEventTableViewCell
        
        cell.event = data[indexPath.section]
        
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
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        super.prepareForSegue(segue, sender: self)
        
        if let des = segue.destinationViewController as? DetailViewController {
            des.event = data[0]
        }
    }
}