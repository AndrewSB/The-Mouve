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
    var isBlurred:Bool = false
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
            
//            event.backgroundImage = UIImage(named: places.randomElement())!
//
            
//            // blur Mouve background image for each cell
//            if (isBlurred == false){
////            let blurView = UIVisualEffectView(effect: UIBlurEffect(style: .Dark))
////            blurView.alpha = 0.75
////            blurView.frame = self.contentView.frame
//            // Crop and set Mouve background image for each cell
////            backgroundImageView.image = CIImage.blur(backgroundImageView.image!, radius: 30)
////            backgroundImageView.addSubview(blurView)
//                
//                isBlurred = true
//            }
            
            
//            let array = [UIImage(named: "yoojin-pic"),UIImage(named: "noah-pic"),UIImage(named: "chelsea-pic"),UIImage(named: "andrew-pic")]
            
//
            
            ParseUtility.getProfileImg(event.creator){(imageObj, error) in
                if((imageObj) != nil){
                    self.profileImageView.image = imageObj
                }
                else{
                    self.profileImageView.image = appDel.placeHolderBg
                    println(error)
                }
                self.profileImageView.image = Toucan(image: self.profileImageView!.image!).resize(CGSize(width: self.profileImageView.bounds.width, height: self.profileImageView.bounds.height), fitMode: Toucan.Resize.FitMode.Crop).image
                self.profileImageView.layer.cornerRadius = self.profileImageView.frame.height / 2
                self.profileImageView.clipsToBounds = true
                self.profileImageView.userInteractionEnabled = true
                var tapGestureRecognizer = UITapGestureRecognizer(target:self, action:Selector("profileImageWasTapped:"))
                self.profileImageView.addGestureRecognizer(tapGestureRecognizer)
            }
            ParseUtility.getEventBgImg(event!){(imgData, error) in
                if((imgData) != nil){
                    self.backgroundImageView.image = imgData

                }
                else{
                    self.backgroundImageView.image = appDel.placeHolderBg
                    println(error)
                }
                self.backgroundImageView.image = Toucan(image: self.backgroundImageView.image!).resize(CGSize(width: self.backgroundImageView.bounds.width, height: (self.backgroundImageView.bounds.height + 105)), fitMode: Toucan.Resize.FitMode.Crop).image
                self.backgroundImageView.clipsToBounds = true
                self.backgroundImageView.image = self.backgroundImageView.image?.applyLightEffect()

            }

//

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
    
    @IBAction func profileImageWasTapped(recognizer: UITapGestureRecognizer){
        println("Jumping to \(self.event!.creator.username!)'s profile")
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewControllerWithIdentifier("ProfileVC") as! ProfileViewController    //VC1 refers to destinationVC source file and "VC1" refers to destinationVC Storyboard ID
        vc.user = event!.creator
//        
//        self.window?.rootViewController?.tabBarController?.selectedViewController?.performSegueWithIdentifier("segueToProfile", sender: event!.creator)
//
//        self.window?.rootViewController?.presentViewController(vc, animated: true, completion: nil)
//        self.window?.rootViewController!.presentViewController(vc, animated: true, completion: nil)
//        println(currVc?.title)
//        currVc!.performSegueWithIdentifier("segueToProfile", sender: event!.creator)
//        self.window?.rootViewController!.performSegueWithIdentifier("segueToProfile", sender: vc.user)
        
    }
    @IBAction func goingButtonWasHit(sender: AnyObject) {
        if (self.goingButton.selected) {
            // Unattend
                    self.goingButton.selected = false;
            ParseUtility.unattendMouveInBackground(self.event){(success: Bool, error: NSError?) -> () in
                if((error) != nil){
                    println("Cannot unattend event")
                }
                else{
                    println("Unattended  successfully")
                }
            }
        } else {
            // Attend
                    self.goingButton.selected = true;
            ParseUtility.attendMouveInBackground(self.event){(success: Bool, error: NSError?) -> () in
                if((error) != nil){
                    println("Cannot attend \(self.event!.name)")
                }
                else{
                    println("Attending \(self.event!.name) successfully")
                }
            }
        }
    }
    
    
    @IBAction func shareButtonWasHit(sender: AnyObject) {
    }
}
