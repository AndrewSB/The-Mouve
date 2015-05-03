//
//  ActivityTableViewCell.swift
//  The Mouve
//
//  Created by Andrew Breckenridge on 4/28/15.
//  Copyright (c) 2015 Andrew Breckenridge. All rights reserved.
//

import UIKit

class ActivityTableViewCell: UITableViewCell {
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var attributedLabel: TTTAttributedLabel!
    @IBOutlet weak var calendarTickButton: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
