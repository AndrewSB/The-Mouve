
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
            
            let places = ["Beach-Chillin", "Coffee-Hour", "Espresso-Lesson", "Fire-Works", "Food-Festival", "Football-Game", "San-Francisco-Visit", "State-Fair", "Study-Sesh", "Surf-Lesson"]
//            loadImages(event)
            self.profileImageView.userInteractionEnabled = true
            var tapGestureRecognizer = UITapGestureRecognizer(target:self, action:Selector("profileImageWasTapped:"))
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

    func processEvent(event: Events!){
    
        
        self.event = event
        dataFillingOp = NSBlockOperation(){
            let downloadImages: NSOperation = ImageDownloader(eventRecord: self.event)
            appDel.pendingOperations.downloadQueue.addOperation(downloadImages)
            let resizeImagesToCell: NSOperation = ImageFiltration(cell: self)
            downloadImages.completionBlock = {
                NSOperationQueue.mainQueue().addOperation(resizeImagesToCell)
            }
        }
        appDel.pendingOperations.filtrationQueue.addOperation(dataFillingOp)
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