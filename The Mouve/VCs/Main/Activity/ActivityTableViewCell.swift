//
//  ActivityTableViewCell.swift
//  The Mouve
//
//  Created by Andrew Breckenridge on 5/5/15.
//  Copyright (c) 2015 Andrew Breckenridge. All rights reserved.
//

import UIKit
import Toucan

class ActivityTableViewCell: UITableViewCell {
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var calendarButton: UIButton!
    @IBOutlet weak var eventBgImageView: UIImageView!
    @IBOutlet weak var attributedLabel: TTTAttributedLabel!
    var activity: Activity?
    
    var type: SceneType? {
        didSet {
            println("didset to \(type!.rawValue)")
            
            if type == .Invites {
                dispatch_async(dispatch_get_main_queue(), {
//                    self.calendarButton = GreyGreenButton(frame: self.calendarButton.frame)
                    
                })
                
            } else { //type is Activity
                self.calendarButton.hidden = true
                dispatch_async(dispatch_get_main_queue(), {
                    self.calendarButton.userInteractionEnabled = false
                    switch self.activity!.typeKey{
                        case typeKeyEnum.AddImage.rawValue:
                            self.attributedLabel.text = "\(self.activity?.fromUser) have added an image on your event!"
                        case typeKeyEnum.Comment.rawValue:
                            self.attributedLabel.text = "\(self.activity!.stringContent)"
                        case typeKeyEnum.Follow.rawValue:
                            self.attributedLabel.text = "@\(self.activity!.fromUser.username!) follows you!"
                        case typeKeyEnum.Attend.rawValue:
                            self.attributedLabel.text = "@\(self.activity!.fromUser.username!) is attending '\(self.activity!.onMouve.name)'"
                        default:
                            self.attributedLabel.text = "unknown activity type"
                    }
                    self.loadImages(self.activity!)
                })
            }
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        profileImageView.layer.cornerRadius = profileImageView.frame.height / 2
        profileImageView.clipsToBounds = true
    }
    func loadImages(activity: Activity){
        ParseUtility.getProfileImg(activity.fromUser){(img: UIImage?,error: NSError?) in
            if((error) != nil){
                println("sorry")
            }
            else{
                activity.profilePic = img
                ParseUtility.getEventBgImg(activity.onMouve){(img: UIImage?,error: NSError?) in
                    if((error) != nil){
                        println("sorry")
                    }
                    else{
                        activity.eventBg = img
                        self.eventBgImageView.image = Toucan(image: self.activity!.eventBg!).resize(CGSize(width: self.profileImageView.bounds.width+10, height: self.profileImageView.bounds.height+10), fitMode: Toucan.Resize.FitMode.Crop).image
                        self.profileImageView.image = self.activity!.profilePic
                        self.profileImageView.layer.cornerRadius = self.profileImageView.frame.height / 2
                        self.profileImageView.clipsToBounds = true
                        self.hidden = false
                    }
                }
            }
        }
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func calendarButtonWasHit(sender: AnyObject) {
        println("youre going")
    }
}
