//
//  SceneFeedViewController.swift
//  The Mouve
//
//  Created by Andrew Breckenridge on 4/8/15.
//  Copyright (c) 2015 Andrew Breckenridge. All rights reserved.
//

import UIKit
import CoreLocation

import Parse
import Bolts

class SceneFeedViewController: UIViewController {

    @IBOutlet weak var feedTableView: UITableView!
    
    var type: SceneType!
    var feedData: [Event]? {
        didSet {
            feedTableView.reloadData()
        }
    }
    
    convenience init(type: SceneType) {
        self.init()
        self.type = type
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        println("didLoad \(self.type)")
        LocalMessage.observe(.NewLocationRegistered, classFunction: "newLocation", inClass: self)
        
        feedTableView.delegate = self
        feedTableView.dataSource = self
        
        let feedQuery = PFQuery(className: "Events")
        feedQuery.limit = 20
        
        switch type! {
        case .Explore:
            println("lol")
        case .Scene:
            println("nah")
        default:
            assert(true == false, "Type wasnt scene or explore")
        }
        
        feedQuery.findObjectsInBackgroundWithBlock { (results: [AnyObject]?, error: NSError?) -> Void in
            var serverData = [Event]()
//            println(results)
            
            if let results = results {
                for result in results {
                    serverData.append(Event(parseObject: result as! PFObject))
                }
            }
            
            self.feedData = serverData
        }
        
        
        feedTableView.contentInset = UIEdgeInsets(top: 44+22, left: 0, bottom: 44, right: 0)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        LocalMessage.post(type.hashValue == 0 ? .HomeFeedPageOne : .HomeFeedPageTwo)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        super.prepareForSegue(segue, sender: sender)
        
        if let des = segue.destinationViewController as? DetailViewController {
            des.event = sender as! Event
        }
    }
    
    func newLocation() {
        println("now somewhere else")
    }
    
    @IBAction func unwindToTutorialVC(segue: UIStoryboardSegue) {}
}



extension SceneFeedViewController: UITableViewDelegate, UITableViewDataSource {
    
    // MARK: UITableViewDataSource
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return feedData == nil ? 0 : feedData!.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        feedTableView.contentInset = UIEdgeInsets(top: 44+22, left: 0, bottom: 44, right: 0)
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cellID") as! HomeEventTableViewCell
        
        cell.event = feedData![indexPath.section]
        
        return cell
    }
    
    
    //MARK: UITableViewDelegate
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        performSegueWithIdentifier("segueToDetail", sender: feedData![indexPath.section])
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
}