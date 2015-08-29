
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
//    var isBlurred:Bool = false
    
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
            loadImages(event)
            
            
            
//            profileImageView.image = Toucan(image: event.creator.getProfilePic()!).resize(CGSize(width: self.profileImageView.bounds.width, height: self.profileImageView.bounds.height), fitMode: Toucan.Resize.FitMode.Crop).maskWithEllipse(borderWidth: 1.5, borderColor: UIColor.whiteColor()).image
//
//            
//            backgroundImageView.image = Toucan(image: event.getBgImg()!).resize(CGSize(width: self.backgroundImageView.bounds.width, height: (self.backgroundImageView.bounds.height)), fitMode: Toucan.Resize.FitMode.Crop).image
//            backgroundImageView.clipsToBounds = true
            ParseUtility.getEventBgImg(event){(imgObj, error) in
                var currImg: UIImage?
                if((imgObj) != nil){
                    currImg = imgObj
                }
                else{
                    currImg = appDel.placeHolderBg
                }
                self.backgroundImageView.image = Toucan(image: currImg!.applyLightEffect()!).resize(CGSize(width: self.backgroundImageView.bounds.width, height: (self.backgroundImageView.bounds.height)), fitMode: Toucan.Resize.FitMode.Crop).image
                self.backgroundImageView.clipsToBounds = true
            }
            ParseUtility.getProfileImg(event.creator){(imageObj, error) in
                if((imageObj) != nil){
                    self.profileImageView.image = imageObj
                }
                else{
                    self.profileImageView.image = appDel.placeHolderBg
                    appDel.placeHolderBg
                    println(error)
                }
                self.profileImageView.image = Toucan(image: self.profileImageView!.image!).resize(CGSize(width: self.profileImageView.bounds.width, height: self.profileImageView.bounds.height), fitMode: Toucan.Resize.FitMode.Crop).maskWithEllipse(borderWidth: 1.5, borderColor: UIColor.whiteColor()).image
                self.profileImageView.userInteractionEnabled = true
                var tapGestureRecognizer = UITapGestureRecognizer(target:self, action:Selector("profileImageWasTapped:"))
                self.profileImageView.addGestureRecognizer(tapGestureRecognizer)
            }

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
    func loadImages(event: Events){
    
        ParseUtility.getEventBgImg(event){(imgObj, error) in
            if let currImg = imgObj{
                self.backgroundImageView.image = Toucan(image: currImg.applyLightEffect()!).resize(CGSize(width: self.backgroundImageView.bounds.width, height: (self.backgroundImageView.bounds.height)), fitMode: Toucan.Resize.FitMode.Crop).image
                self.backgroundImageView.clipsToBounds = true
                ParseUtility.getProfileImg(event.creator){(imgObj, error) in
                    if let currImg = imgObj{
                        self.profileImageView.image = Toucan(image: currImg).resize(CGSize(width: self.profileImageView.bounds.width, height: self.profileImageView.bounds.height), fitMode: Toucan.Resize.FitMode.Crop).maskWithEllipse(borderWidth: 1.5, borderColor: UIColor.whiteColor()).image
                        self.profileImageView.userInteractionEnabled = true
                        var tapGestureRecognizer = UITapGestureRecognizer(target:self, action:Selector("profileImageWasTapped:"))
                        self.profileImageView.addGestureRecognizer(tapGestureRecognizer)
//                        Unhide once everything is ready
                        self.hidden = false
                        self.delegate?.didFinishLoadingCell(self)
                        
                    }
                }
            }
            else{
                println(error)
                
            }
            
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
//        Hide at first all cells
        self.hidden = true
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