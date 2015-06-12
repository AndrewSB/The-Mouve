//
//  ActivityTableViewCell.swift
//  The Mouve
//
//  Created by Andrew Breckenridge on 5/5/15.
//  Copyright (c) 2015 Andrew Breckenridge. All rights reserved.
//

import UIKit

class ProfileActivityTableViewCell: UITableViewCell {
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var attributedLabel: TTTAttributedLabel!
    @IBOutlet weak var calendarButton: UIButton!
    
    var type: SceneType? {
        didSet {
            println("didset to \(type!.rawValue)")
            
            if type == .Following {
                dispatch_async(dispatch_get_main_queue(), {
                    self.calendarButton = GreyGreenButton(frame: self.calendarButton.frame)
                })
                
            } else { //type is Activity
                dispatch_async(dispatch_get_main_queue(), {
                    self.calendarButton.userInteractionEnabled = false
                    self.calendarButton.imageView!.image = UIImage(named: "sf-image")
                })
            }
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        
        profileImageView.layer.cornerRadius = profileImageView.frame.height / 2
        profileImageView.clipsToBounds = true
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func calendarButtonWasHit(sender: AnyObject) {
        println("youre going")
    }
}
