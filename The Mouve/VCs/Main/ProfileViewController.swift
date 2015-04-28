//
//  ProfileViewController.swift
//  The Mouve
//
//  Created by Andrew Breckenridge on 4/28/15.
//  Copyright (c) 2015 Andrew Breckenridge. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    let offset_HeaderStop:CGFloat = 40.0 // At this offset the Header stops its transformations
    let offset_B_LabelHeader:CGFloat = 95.0 // At this offset the Black label reaches the Header
    let distance_W_LabelHeader:CGFloat = 35.0 // The distance between the bottom of the Header and the top of the White Label

    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var headerLabel: UILabel!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let imageView = UIImageView(frame: headerView.frame)
        imageView.image = UIImage(named: "noah-pic")
        imageView.contentMode = .ScaleAspectFill
        
        
        view.insertSubview(imageView, atIndex: 0)
        
        
    }
}
