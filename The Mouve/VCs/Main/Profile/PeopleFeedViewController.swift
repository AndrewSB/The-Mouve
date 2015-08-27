//
//  PeopleFeedViewController.swift
//  The Mouve
//
//  Created by Samuel Ifeanyi Ojogbo Jr. on 8/27/15.
//  Copyright (c) 2015 Andrew Breckenridge. All rights reserved.
//

import Foundation
import Parse
import Bolts

class PeopleFeedViewController: UIViewController{

    
    @IBOutlet weak var followersTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
}

extension PeopleFeedViewController: UITableViewDelegate, UITableViewDataSource {
    
    // MARK: UITableViewDataSource
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 0//feedData == nil ? 0 : feedData!.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        followersTableView.contentInset = UIEdgeInsets(top: 44+22, left: 0, bottom: 44, right: 0)
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cellID") as! PeopleTableViewCell
//        cell.delegate = self
//        cell.event = feedData![indexPath.section]
        return cell
    }
    
    
    //MARK: UITableViewDelegate
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
//        performSegueWithIdentifier("segueToDetail", sender: feedData![indexPath.section])
    }
    
    //    func tableView(tableView: UITableView, accessoryButtonTappedForRowWithIndexPath indexPath: NSIndexPath) {
    //        println("segueing to profile")
    //        performSegueWithIdentifier("segueToProfile", sender: feedData![indexPath.section].creator)
    //    }
    
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