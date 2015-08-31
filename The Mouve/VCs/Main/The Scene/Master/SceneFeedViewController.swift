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
    var feedData = [Events]()
    let pendingOperations = PendingOperations()


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
//            dispatch_async(dispatch_get_main_queue(), {
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

            feedQuery!.limit = 20
            feedQuery?.findObjectsInBackgroundWithBlock { (results: [AnyObject]?, error: NSError?) -> Void in
                if error != nil {
                    let alert = UIAlertView(title:"Oops!",message:error!.localizedDescription, delegate:nil, cancelButtonTitle:"OK")
                    alert.show()
                }
                else if let loadedData  = results as? [Events] {
                    self.feedData = loadedData
                }
                if self.feedData.count == 0 {
                    self.feedTableView.emptyDataSetSource = self;
                    self.feedTableView.emptyDataSetDelegate = self;
                }
                self.feedTableView.reloadData()

            }
        

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
            des.pfType = ((des.user == appDel.currentUser) ? ProfileType.MyProfile : ProfileType.OtherUser)
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
//Defining operations that we would like to perform on the SceneFeedViewController in background
extension SceneFeedViewController{
    func startOperationsForPhotoRecord(cell: HomeEventTableViewCell, indexPath: NSIndexPath){
        switch (cell.event.state) {
        case .New:
            startDownloadForRecord(cell.event, indexPath: indexPath)
        case .DownloadedAll:
            startFiltrationForRecord(cell, indexPath: indexPath)
        default:
            NSLog("do nothing")
        }
    }
    func startDownloadForRecord(mouveDetails: Events, indexPath: NSIndexPath){
        //1
        if let downloadOperation = pendingOperations.downloadsInProgress[indexPath] {
            return
        }
        
        //2
        let downloader = ImageDownloader(eventRecord: mouveDetails)
        //3
        downloader.completionBlock = {
            if downloader.cancelled {
                return
            }
            dispatch_async(dispatch_get_main_queue(), {
                self.pendingOperations.downloadsInProgress.removeValueForKey(indexPath)
                self.feedTableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Fade)
            })
        }
        //4
        pendingOperations.downloadsInProgress[indexPath] = downloader
        //5
        pendingOperations.downloadQueue.addOperation(downloader)
        
        
        
    }
    
    func startFiltrationForRecord(cellDetails: HomeEventTableViewCell, indexPath: NSIndexPath){
        if let filterOperation = pendingOperations.filtrationsInProgress[indexPath]{
            return
        }
        
        let filterer = ImageFiltration(cell: cellDetails)
        filterer.completionBlock = {
            if filterer.cancelled {
                return
            }
            dispatch_async(dispatch_get_main_queue(), {
                self.pendingOperations.filtrationsInProgress.removeValueForKey(indexPath)
                self.feedTableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Fade)
            })
        }
        pendingOperations.filtrationsInProgress[indexPath] = filterer
        pendingOperations.filtrationQueue.addOperation(filterer)
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
        return feedData.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        feedTableView.contentInset = UIEdgeInsets(top: 44+22, left: 0, bottom: 44, right: 0)
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cellID") as! HomeEventTableViewCell
        let mouveDetails = feedData[indexPath.section]
        cell.event = mouveDetails

        cell.delegate = self
        //4

        switch (cell.event.state){
            case .FilteredAll:
                cell.backgroundImageView?.image = cell.event.localBgImg
                cell.profileImageView?.image = cell.event.creatorPfImg
                cell.hidden = false
                
                println("Displaying \(cell.event.name)")
            case .Failed:
                cell.nameLabel.text = "Failed to load"
                cell.hidden = false
            case .New, .DownloadedAll:

                if (!tableView.dragging && !tableView.decelerating) {
                    cell.hidden = true
                    self.startOperationsForPhotoRecord(cell,indexPath:indexPath)
                }
            
        }
        
        return cell
    }

    
    
    //MARK: UITableViewDelegate
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        performSegueWithIdentifier("segueToDetail", sender: feedData[indexPath.section])
        
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
