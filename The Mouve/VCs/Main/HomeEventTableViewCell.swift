//
//  HomeEventTableViewCell.swift
//  The Mouve
//
//  Created by Andrew Breckenridge on 4/8/15.
//  Copyright (c) 2015 Andrew Breckenridge. All rights reserved.
//

import UIKit

class HomeEventTableViewCell: UITableViewCell {
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
        
        let blurEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .Dark))
        blurEffectView.frame = backgroundImageView.frame
//        blurEffectView.alpha = 0.85
        
        backgroundImageView.addSubview(blurEffectView)
    
    }
    
    
    @IBAction func goingButtonWasHit(sender: AnyObject) {
    }
    
    
    @IBAction func shareButtonWasHit(sender: AnyObject) {
    }
}
