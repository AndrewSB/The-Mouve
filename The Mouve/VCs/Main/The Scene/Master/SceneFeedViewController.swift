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
    var clickedOnType: String!
    var feedData = [Events]()
    let pendingOperations = PendingOperations()
    var feedComponent: FeedComponent<Events, SceneFeedViewController>!


    convenience init(type: SceneType) {
        self.init()
        self.type = type

    }
    func loadInRange(sceneType: SceneType,range: Range<Int>, completionBlock: ([Events]?) -> Void) {
        // 1
        ParseUtility.queryFeed(self.type,range: range){(result: [AnyObject]?, error: NSError?) -> Void in
            let feedData = result as? [Events] ?? []
            // 3
            completionBlock(feedData)
        }
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

            appDel.location.startUpdatingLocation()



//            feedQuery?.findObjectsInBackgroundWithBlock { (results: [AnyObject]?, error: NSError?) -> Void in
//                if error != nil {
//                    let alert = UIAlertView(title:"Oops!",message:error!.localizedDescription, delegate:nil, cancelButtonTitle:"OK")
//                    alert.show()
//                }
//                else if let loadedData  = results as? [Events] {
//                    self.feedData = loadedData
//                }
//                if self.feedData.count == 0 {
//                    self.feedTableView.emptyDataSetSource = self;
//                    self.feedTableView.emptyDataSetDelegate = self;
//                }
//                self.feedTableView.reloadData()
//
//            }
        

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
//    @IBAction func unwindToVC(segue: UIStoryboardSegue) {
//    }
//    func newLocation() {
//        println("now somewhere else")
//    }
    
//    @IBAction func unwindToTutorialVC(segue: UIStoryboardSegue) {}
}
//public protocol FeedComponentTarget: class {
//    typealias ContentType
//    
//    var defaultRange: Range<Int> { get }
//    var additionalRangeSize: Int { get }
//    var feedTableView: UITableView! { get }
//    func loadInRange(sceneType: SceneType, range: Range<Int>, completionBlock: ([ContentType]?) -> Void)
//}

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
                var currCell = (self.feedTableView.cellForRowAtIndexPath(indexPath) as! HomeEventTableViewCell)
//                currCell.backgroundImageView.image = currCell.event.localBgImg
//                currCell.hidden = false
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
extension SceneFeedViewController{
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        //1
        suspendAllOperations()
    }
    
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        // 2
        if !decelerate {
            loadImagesForOnscreenCells()
            resumeAllOperations()
        }
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        // 3
        loadImagesForOnscreenCells()
        resumeAllOperations()
    }
    func suspendAllOperations () {
        pendingOperations.downloadQueue.suspended = true
        pendingOperations.filtrationQueue.suspended = true
    }
    
    func resumeAllOperations () {
        pendingOperations.downloadQueue.suspended = false
        pendingOperations.filtrationQueue.suspended = false
    }
    
    func loadImagesForOnscreenCells () {
        //1
        if let pathsArray = feedTableView.indexPathsForVisibleRows() {
            //2
            var allPendingOperations = Set(pendingOperations.downloadsInProgress.keys.array)
            allPendingOperations.unionInPlace(pendingOperations.filtrationsInProgress.keys.array)
            
            //3
            var toBeCancelled = allPendingOperations
            let visiblePaths = Set(pathsArray as! [NSIndexPath])
            toBeCancelled.subtractInPlace(visiblePaths)
            
            //4
            var toBeStarted = visiblePaths
            toBeStarted.subtractInPlace(allPendingOperations)
            
            // 5
            for indexPath in toBeCancelled {
                if let pendingDownload = pendingOperations.downloadsInProgress[indexPath] {
                    pendingDownload.cancel()
                }
                pendingOperations.downloadsInProgress.removeValueForKey(indexPath)
                if let pendingFiltration = pendingOperations.filtrationsInProgress[indexPath] {
                    pendingFiltration.cancel()
                }
                pendingOperations.filtrationsInProgress.removeValueForKey(indexPath)
            }
            
            // 6
            for indexPath in toBeStarted {
                let indexPath = indexPath as NSIndexPath
                startOperationsForPhotoRecord(feedTableView.cellForRowAtIndexPath(indexPath) as! HomeEventTableViewCell, indexPath: indexPath)
            }
        }
    }
}
