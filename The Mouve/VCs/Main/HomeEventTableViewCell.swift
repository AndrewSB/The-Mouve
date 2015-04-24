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
  
    @IBOutlet weak var bottomSpacerView: UIView!
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        NSBundle.mainBundle().loadNibNamed("HomeFeedCell", owner: self, options: nil)
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        profileImageView.layer.cornerRadius = (profileImageView.frame.width / CGFloat(2))
        profileImageView.layer.borderColor = UIColor.whiteColor().CGColor
        profileImageView.layer.borderWidth = 2

        let newBackgroundImageView = UIImageView(frame: self.frame)
        newBackgroundImageView.image = UIImage(named: "list-background")
        newBackgroundImageView.layer.opacity = 0.3
        
        self.backgroundView = newBackgroundImageView
    }
}
