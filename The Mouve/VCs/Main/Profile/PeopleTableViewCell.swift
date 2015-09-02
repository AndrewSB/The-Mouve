//
//  FollowersTableViewCell.swift
//  The Mouve
//
//  Created by Samuel Ifeanyi Ojogbo Jr. on 7/18/15.
//  Copyright (c) 2015 The Mouve. All rights reserved.
//

import Foundation
import UIKit

class PeopleTableViewCell: UITableViewCell {

    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    @IBAction func followerButtonWasHit(sender: AnyObject) {
        print("you're following")
    }
}