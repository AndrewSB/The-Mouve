
//
//  HomeEventTableViewCell.swift
//  The Mouve
//
//  Created by Andrew Breckenridge on 4/8/15.
//  Copyright (c) 2015 Andrew Breckenridge. All rights reserved.
//

import Foundation
import UIKit
import Toucan
import Parse
class HomeEventTableViewCell: UITableViewCell {
    var dataFillingOp: NSOperation!
    var isDone = false
    var event: Events! {
        didSet {
            nameLabel.text = event.name
            descriptionLabel.text = event.about

            
            var todayOrNot:String
            if (event.startTime.isToday() == true){
                todayOrNot = "Today"
            }
            else{
                todayOrNot = "Tomorrow"
            }
            
            dateAndTimeLabel.text = "\(todayOrNot) | \(event.startTime.toShortTimeString()) - \(event.endTime.toShortTimeString())"

            distanceLabel.text = (String(format: "%.2f",event.location.distanceInMilesTo(PFGeoPoint(location: UserDefaults.lastLocation))))+" Miles Away"
            
            _ = ["Beach-Chillin", "Coffee-Hour", "Espresso-Lesson", "Fire-Works", "Food-Festival", "Football-Game", "San-Francisco-Visit", "State-Fair", "Study-Sesh", "Surf-Lesson"]
//            loadImages(event)
            self.profileImageView.userInteractionEnabled = true
            let tapGestureRecognizer = UITapGestureRecognizer(target:self, action:Selector("profileImageWasTapped:"))
            self.profileImageView.addGestureRecognizer(tapGestureRecognizer)
        }
    }

    
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var dateAndTimeLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
  
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var profileImageButton: UIButton!
    
    @IBOutlet weak var goingButton: UIButton!
    @IBOutlet weak var shareButton: UIButton!
    
    @IBOutlet weak var backgroundImageView: UIImageView!
    var delegate: HomeEventTVCDelegate?
    @IBAction func buttonTapped(sender: AnyObject) {

    }
    override func awakeFromNib() {
        super.awakeFromNib()
//        Hide at first all cells
    }

//    func processEvent(indexPath: NSIndexPath){
    func processEvent(){
    
        
//        if(!self.isDone){
            dataFillingOp = NSBlockOperation(){
    //            if((appDel.pendingOperations.downloadsInProgress[indexPath]) != nil){
    //                return
    //            }
                let downloadImages: NSOperation = ImageDownloader(eventRecord: self.event)
                let resizeImagesToCell: NSOperation = ImageFiltration(cell: self)
                downloadImages.qualityOfService = NSQualityOfService.Utility
    //            appDel.pendingOperations.downloadsInProgress[indexPath] = downloadImages
                downloadImages.completionBlock = {
    //                appDel.pendingOperations.downloadsInProgress.removeValueForKey(indexPath)
                    
                    NSOperationQueue.mainQueue().addOperation(resizeImagesToCell)
                    
                }
                resizeImagesToCell.completionBlock = {
    //                appDel.pendingOperations.filtrationsInProgress.removeValueForKey(indexPath)
//                    self.isDone = true
                }
//                NSOperationQueue.mainQueue().addOperation(downloadImages)
                appDel.pendingOperations.downloadQueue.addOperation(downloadImages)
    //            NSOperationQueue.mainQueue().addOperations([downloadImages,resizeImagesToCell], waitUntilFinished: false)
            }
//        }
//        else{
//            dataFillingOp = NSBlockOperation(){
//                let resizeImagesToCell: NSOperation = ImageFiltration(cell: self)
//                NSOperationQueue.mainQueue().addOperation(resizeImagesToCell)
//            }
//        }
        appDel.pendingOperations.filtrationQueue.addOperation(self.dataFillingOp)
    }
    func cancelProcess(){
        self.dataFillingOp.cancel()
    }
    @IBAction func profileImageWasTapped(recognizer: UITapGestureRecognizer){
        delegate?.didTapProfileImage(self)
    }
    @IBAction func goingButtonWasHit(sender: AnyObject) {
        delegate?.didTapAttendEvent(self)
    }
    
    
    @IBAction func shareButtonWasHit(sender: AnyObject) {
    }
}



protocol HomeEventTVCDelegate {
    func didTapProfileImage(cell: HomeEventTableViewCell)
    func didTapAttendEvent(cell: HomeEventTableViewCell)
    func didTapShareEvent(cell: HomeEventTableViewCell)
    func didFinishLoadingCell(cell: HomeEventTableViewCell)
}