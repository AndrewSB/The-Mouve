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
    var event: Events! {
        didSet {
            nameLabel.text = event.name
            descriptionLabel.text = event.about
            
            dateAndTimeLabel.text = "\(event.startTime.toShortTimeString()) - \(event.endTime.toShortTimeString())"

            distanceLabel.text = (String(format: "%.2f",event.location.distanceInMilesTo(PFGeoPoint(location: UserDefaults.lastLocation))))+" Miles"
            
            let places = ["Beach-Chillin", "Coffee-Hour", "Espresso-Lesson", "Fire-Works", "Food-Festival", "Football-Game", "San-Francisco-Visit", "State-Fair", "Study-Sesh", "Surf-Lesson"]
            
//            event.backgroundImage = UIImage(named: places.randomElement())!
//
            
            
            backgroundImageView.image = Toucan(image: event.getBgImg()!).resize(CGSize(width: self.contentView.frame.width, height: self.contentView.frame.height), fitMode: Toucan.Resize.FitMode.Crop).image

            let blurView = UIVisualEffectView(effect: UIBlurEffect(style: .Dark))
            blurView.frame = self.contentView.frame
            backgroundImageView.addSubview(blurView)
            
            
//            let array = [UIImage(named: "yoojin-pic"),UIImage(named: "noah-pic"),UIImage(named: "chelsea-pic"),UIImage(named: "andrew-pic")]
            
//
            
            
            profileImageView.image = Toucan(image: event.creator.getProfilePic()!).resize(CGSize(width: self.profileImageView.bounds.width, height: self.profileImageView.bounds.height), fitMode: Toucan.Resize.FitMode.Crop).image
            profileImageView.layer.cornerRadius = profileImageView.frame.height / 2
            profileImageView.clipsToBounds = true
        }
    }
    
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var dateAndTimeLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
  
    @IBOutlet weak var profileImageView: UIImageView!
    
    @IBOutlet weak var goingButton: UIButton!
    @IBOutlet weak var shareButton: UIButton!
    
    @IBOutlet weak var backgroundImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        
        profileImageView.layer.cornerRadius = (profileImageView.frame.width / CGFloat(2))
        profileImageView.layer.borderColor = UIColor.whiteColor().CGColor
        profileImageView.layer.borderWidth = 1
        
//        let blurEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .Dark))
//        blurEffectView.frame = backgroundImageView.frame
//        blurEffectView.alpha = 0.85
        
       // backgroundImageView.addSubview(blurEffectView)
        
    }
    
    
    @IBAction func goingButtonWasHit(sender: AnyObject) {
    }
    
    
    @IBAction func shareButtonWasHit(sender: AnyObject) {
    }
}
