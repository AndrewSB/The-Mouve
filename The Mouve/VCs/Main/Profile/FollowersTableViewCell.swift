//
//  FollowersTableViewCell.swift
//  The Mouve
//
//  Created by Samuel Ifeanyi Ojogbo Jr. on 7/18/15.
//  Copyright (c) 2015 The Mouve. All rights reserved.
//

import Foundation
import UIKit

class FollowersTableViewCell: UITableViewCell {
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var attributedLabel: TTTAttributedLabel!
    @IBOutlet weak var followerButton: UIButton!
    
//    var type: SceneType? {
//        didSet {
//            println("didset to \(type!.rawValue)")
//            
//            if type == .Invites {
//                dispatch_async(dispatch_get_main_queue(), {
//                    self.followerButton = GreyGreenButton(frame: self.followerButton.frame)
//                })
//                
//            } else { //type is Activity
//                dispatch_async(dispatch_get_main_queue(), {
//                    self.followerButton.userInteractionEnabled = false
//                    self.followerButton.imageView!.image = UIImage(named: "sf-image")
//                })
//            }
//        }
//    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        profileImageView.layer.cornerRadius = profileImageView.frame.height / 2
        profileImageView.clipsToBounds = true
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    @IBAction func followerButtonWasHit(sender: AnyObject) {
        println("you're following")
    }
}