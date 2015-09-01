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


class SceneFeedViewController: UIViewController, FeedComponentTarget{

    @IBOutlet weak var feedTableView: UITableView!
    let defaultRange = 0...4
    let additionalRangeSize = 5
    var type: SceneType!
    var feedComponent: FeedComponent<Events, SceneFeedViewController>!


    convenience init(type: SceneType) {
        self.init()
        self.type = type

    }
    func loadInRange(sceneType: SceneType,range: Range<Int>, completionBlock: ([Events]?) -> Void) {
        // 1
        ParseUtility.queryFeed(self.type,range: range){(result: [AnyObject]?, error: NSError?) -> Void in
            let posts = result as? [Events] ?? []
            // 3
            completionBlock(posts)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //uncomment starts here

        LocalMessage.post(type.hashValue == 0 ? .HomeFeedPageOne : .HomeFeedPageTwo)
        LocalMessage.observe(.NewLocationRegistered, classFunction: "newLocation", inClass: self)
//        appDel.location.startUpdatingLocation()
        feedComponent = FeedComponent(target: self)
    }
    
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        feedComponent.loadInitialIfRequired()
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
extension SceneFeedViewController: HomeEventTVCDelegate {

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
}
extension SceneFeedViewController: UITableViewDataSource{
    // MARK: UITableViewDataSource
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        feedTableView.contentInset = UIEdgeInsets(top: 44+22, left: 0, bottom: 44, right: 0)
        return self.feedComponent.content.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cellID") as! HomeEventTableViewCell
        cell.delegate = self
        let event = feedComponent.content[indexPath.row]
        cell.processEvent(event)
        return cell
        

    }
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        
        feedComponent.targetWillDisplayEntry(indexPath.row)
    }
}
extension SceneFeedViewController:  UITableViewDelegate{
    
    
    //MARK: UITableViewDelegate
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        performSegueWithIdentifier("segueToDetail", sender: feedComponent.content[indexPath.row])
        
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
//extension SceneFeedViewController: UIScrollViewDelegate{
//    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
//        //1
//        suspendAllOperations()
//    }
//    
//    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
//        // 2
//        if !decelerate {
//            loadImagesForOnscreenCells()
//            resumeAllOperations()
//        }
//    }
//    
//    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
//        // 3
//        loadImagesForOnscreenCells()
//        resumeAllOperations()
//    }
//    func suspendAllOperations () {
//        pendingOperations.downloadQueue.suspended = true
//        pendingOperations.filtrationQueue.suspended = true
//    }
//    
//    func resumeAllOperations () {
//        pendingOperations.downloadQueue.suspended = false
//        pendingOperations.filtrationQueue.suspended = false
//    }
//    
//    func loadImagesForOnscreenCells () {
//        //1
//        if let pathsArray = feedTableView.indexPathsForVisibleRows() {
//            //2
//            var allPendingOperations = Set(pendingOperations.downloadsInProgress.keys.array)
//            allPendingOperations.unionInPlace(pendingOperations.filtrationsInProgress.keys.array)
//            
//            //3
//            var toBeCancelled = allPendingOperations
//            let visiblePaths = Set(pathsArray as! [NSIndexPath])
//            toBeCancelled.subtractInPlace(visiblePaths)
//            
//            //4
//            var toBeStarted = visiblePaths
//            toBeStarted.subtractInPlace(allPendingOperations)
//            
//            // 5
//            for indexPath in toBeCancelled {
//                if let pendingDownload = pendingOperations.downloadsInProgress[indexPath] {
//                    pendingDownload.cancel()
//                }
//                pendingOperations.downloadsInProgress.removeValueForKey(indexPath)
//                if let pendingFiltration = pendingOperations.filtrationsInProgress[indexPath] {
//                    pendingFiltration.cancel()
//                }
//                pendingOperations.filtrationsInProgress.removeValueForKey(indexPath)
//            }
//            
//            // 6
//            for indexPath in toBeStarted {
//                let indexPath = indexPath as NSIndexPath
//                startOperationsForPhotoRecord(feedTableView.cellForRowAtIndexPath(indexPath) as! HomeEventTableViewCell, indexPath: indexPath)
//            }
//        }
//    }
//}
