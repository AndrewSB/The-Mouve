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
    let defaultRange = 0...9
    let additionalRangeSize = 10
    var type: SceneType!{
        didSet{
            
        }
    }
    var feedComponent: FeedComponent<Events, SceneFeedViewController>!


    convenience init(type: SceneType) {
        self.init()
        self.type = type
        LocalMessage.observe(.NewLocationRegistered, classFunction: "newLocation", inClass: appDel)
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
        LocalMessage.post(type.hashValue == 0 ? .HomeFeedPageOne : .HomeFeedPageTwo)

        feedComponent = FeedComponent(target: self)
    }
    
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        feedComponent.loadInitialIfRequired()
        feedTableView.contentInset = UIEdgeInsets(top: 44+22, left: 0, bottom: 44, right: 0)
    }
    
}
extension SceneFeedViewController: HomeEventTVCDelegate {
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
    func didTapProfileImage(cell: HomeEventTableViewCell) {
        print("Jumping to \(cell.event!.creator.username!)'s profile")
        performSegueWithIdentifier("segueToProfile", sender: cell.event.creator)
    }
    func didTapAttendEvent(cell: HomeEventTableViewCell) {
        if (cell.goingButton.selected) {
            // Unattend
            cell.goingButton.selected = false;
            ParseUtility.unattendMouveInBackground(cell.event){(success: Bool, error: NSError?) -> () in
                if((error) != nil){
                    print("Cannot unattend event")
                }
                else{
                    print("Unattended  successfully")
                }
            }
        } else {
            // Attend
            cell.goingButton.selected = true;
            ParseUtility.attendMouveInBackground(cell.event){(success: Bool, error: NSError?) -> () in
                if((error) != nil){
                    print("Cannot attend \(cell.event!.name)")
                }
                else{
                    print("Attending \(cell.event!.name) successfully")
                }
            }
        }
    }
    func didTapShareEvent(cell: HomeEventTableViewCell) {
        
    }
    func didFinishLoadingCell(cell: HomeEventTableViewCell) {
        //        self.loadingSpinnerView.removeFromSuperview()
    }
    override func viewWillDisappear(animated: Bool) {
        appDel.pendingOperations.filtrationQueue.cancelAllOperations()
        appDel.pendingOperations.filtrationsInProgress.removeAll(keepCapacity: false)
        appDel.pendingOperations.downloadQueue.cancelAllOperations()
        appDel.pendingOperations.downloadsInProgress.removeAll(keepCapacity: false)

    }
}
extension SceneFeedViewController : DZNEmptyDataSetSource,DZNEmptyDataSetDelegate {
    func emptyDataSetDidTapButton(scrollView: UIScrollView!) {
        print("trying to add mouve")
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
extension SceneFeedViewController: UITableViewDataSource{
    // MARK: UITableViewDataSource
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.feedComponent.content.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cellID") as! HomeEventTableViewCell
        cell.event = feedComponent.content[indexPath.row]
//        if (!tableView.dragging && !tableView.decelerating) {
//            cell.processEvent()
//        }
        return cell
    }
    func loadImagesForOnscreenRows() {
        if (self.feedComponent.content.count > 0) {
            let visiblePaths = self.feedTableView.indexPathsForVisibleRows
            for i in visiblePaths! {
                self.loadImageForCellAtIndexPath(i)
            }
        }
    }
    
    func loadImageForCellAtIndexPath(indexPath: NSIndexPath) {
    let cell = self.feedTableView.cellForRowAtIndexPath(indexPath) as! HomeEventTableViewCell
        cell.processEvent()
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
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        self.loadImagesForOnscreenRows()
    }
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if(!decelerate){
            self.loadImagesForOnscreenRows()
        }
    }
}