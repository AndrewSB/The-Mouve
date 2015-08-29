//
//  SceneFeedViewController.swift
//  The Mouve
//
//  Created by Andrew Breckenridge on 4/8/15.
//  Copyright (c) 2015 Andrew Breckenridge. All rights reserved.
//

import UIKit
import CoreLocation
import Toucan
import Parse
import Bolts
import DZNEmptyDataSet

class SceneFeedViewController: UIViewController{

    @IBOutlet weak var feedTableView: UITableView!
    
    var loadingSpinnerView: UIView!
    var type: SceneType!
    var clickedOnType: String!
    var feedData: [Events]? {
        didSet {
            self.feedTableView.reloadData()
            
        }
    }


    convenience init(type: SceneType) {
        self.init()
        self.type = type

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //uncomment starts here

        LocalMessage.post(type.hashValue == 0 ? .HomeFeedPageOne : .HomeFeedPageTwo)
        LocalMessage.observe(.NewLocationRegistered, classFunction: "newLocation", inClass: self)
        
        feedTableView.delegate = self
        feedTableView.dataSource = self
//        self.loadingSpinnerView = addLoadingView()
//        self.view.addSubview(loadingSpinnerView)

            
            //        let feedQuery = PFQuery(className: "Events")
            dispatch_async(dispatch_get_main_queue(), {
            var feedQuery: PFQuery?
            appDel.location.startUpdatingLocation()
            switch self.type! {
            case .Explore:
                //            println("lol")
                feedQuery = Events.query()
                feedQuery?.whereKey("location", nearGeoPoint: PFGeoPoint(location: UserDefaults.lastLocation), withinMiles: 5.0)
                
            case .Scene:
                
    //            First query the people we follow
    //            Then query all the mouves made by them
                let followingQuery = PFQuery(className: Activity.parseClassName())
                followingQuery.whereKey("typeKey", equalTo: typeKeyEnum.Follow.rawValue)
                followingQuery.whereKey("fromUser", equalTo: appDel.currentUser!)
                
                // Using the activities from the query above, we find all of the photos taken by
                // the friends the current user is following
                let followingMouvesQuery = PFQuery(className: Events.parseClassName())
                followingMouvesQuery.whereKey("creator", matchesKey: "toUser", inQuery: followingQuery)
                followingMouvesQuery.whereKeyExists("name")
                
                // We create a second query for the current user's mouves
                let mouvesFromCurrentUserQuery = PFQuery(className: Events.parseClassName())
                mouvesFromCurrentUserQuery.whereKey("creator", equalTo: appDel.currentUser!)
                followingMouvesQuery.whereKeyExists("name")
                
                // We create a final compound query that will find all of the photos that were
                // taken by the user's friends or by the user
                feedQuery = PFQuery.orQueryWithSubqueries([mouvesFromCurrentUserQuery, followingMouvesQuery])
                feedQuery!.includeKey("creator")
                feedQuery!.orderByAscending("startTime")
                
                
                
            default:
                assert(true == false, "Type wasnt scene or explore")
            }
            

    //        feedQuery!.limit = 20
            feedQuery?.findObjectsInBackgroundWithBlock { (results: [AnyObject]?, error: NSError?) -> Void in
    //            var serverData = [Events]()
                //            println(results)
                
                if let loadedData  = results as? [Events] {
                    self.feedData = loadedData
                }
                if self.feedData?.count == 0 {
                    self.feedTableView.emptyDataSetSource = self;
                    self.feedTableView.emptyDataSetDelegate = self;
                    self.feedTableView.reloadEmptyDataSet()
                }
                
            }
        
        self.feedTableView.contentInset = UIEdgeInsets(top: 44+22, left: 0, bottom: 44, right: 0)
        })
    }
    
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        super.prepareForSegue(segue, sender: sender)
        if let des = segue.destinationViewController as? DetailViewController {
            des.event = sender as? Events
            des.hidesBottomBarWhenPushed = true;
        }
        if let des = segue.destinationViewController as? ProfileViewController {
            des.user = sender as? PFUser
            des.hidesBottomBarWhenPushed = true;
            
        }
        if let des = segue.destinationViewController as? AddMouveViewController {
            des.hidesBottomBarWhenPushed = true;
        }
        
    }
    @IBAction func unwindToVC(segue: UIStoryboardSegue) {
    }
    func newLocation() {
        println("now somewhere else")
    }
    
    @IBAction func unwindToTutorialVC(segue: UIStoryboardSegue) {}
}

extension SceneFeedViewController : DZNEmptyDataSetSource,DZNEmptyDataSetDelegate {
    func emptyDataSetDidTapButton(scrollView: UIScrollView!) {
        println("trying to add mouve")
        performSegueWithIdentifier("addMouve", sender: self)
    }
    func titleForEmptyDataSet(scrollView: UIScrollView!) -> NSAttributedString! {
        return NSAttributedString(string: " \(type.rawValue) mode?")
    }
    
    func descriptionForEmptyDataSet(scrollView: UIScrollView!) -> NSAttributedString! {
        let text = "FUCK IT SKIP IT"
        
        return NSAttributedString(string: text, attributes: [
            NSForegroundColorAttributeName: UIColor.grayColor()
            ])
    }
    
    func imageForEmptyDataSet(scrollView: UIScrollView!) -> UIImage! {
        return UIImage(named: "mouve-icon")
    }
}

extension SceneFeedViewController: UITableViewDelegate, UITableViewDataSource, HomeEventTVCDelegate {

    func didTapProfileImage(cell: HomeEventTableViewCell) {
        println("Jumping to \(cell.event!.creator.username!)'s profile")
        performSegueWithIdentifier("segueToProfile", sender: cell.event.creator)
    }
    func didTapAttendEvent(cell: HomeEventTableViewCell) {
        if (cell.goingButton.selected) {
            // Unattend
            cell.goingButton.selected = false;
            ParseUtility.unattendMouveInBackground(cell.event){(success: Bool, error: NSError?) -> () in
                if((error) != nil){
                    println("Cannot unattend event")
                }
                else{
                    println("Unattended  successfully")
                }
            }
        } else {
            // Attend
            cell.goingButton.selected = true;
            ParseUtility.attendMouveInBackground(cell.event){(success: Bool, error: NSError?) -> () in
                if((error) != nil){
                    println("Cannot attend \(cell.event!.name)")
                }
                else{
                    println("Attending \(cell.event!.name) successfully")
                }
            }
        }
    }
    func didTapShareEvent(cell: HomeEventTableViewCell) {
        
    }
    func didFinishLoadingCell(cell: HomeEventTableViewCell) {
//        self.loadingSpinnerView.removeFromSuperview()
    }
    
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
        cell.delegate = self
        cell.event = feedData![indexPath.section]
        return cell
    }
    
    
    //MARK: UITableViewDelegate
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        performSegueWithIdentifier("segueToDetail", sender: feedData![indexPath.section])
        
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