//
//  ViewController.swift
//  Profile
//
//  Created by Andrew Breckenridge on 4/28/15.
//  Copyright (c) 2015 Andrew Breckenridge. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIScrollViewDelegate {
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var headerLabel: UILabel!
    var headerImageView: UIImageView!
    var blurredHeaderImageView: UIImageView!
    
    @IBOutlet weak var profileTableView: UITableView!

    @IBOutlet weak var avatarImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView = profileTableView.subviews[0] as! UIScrollView
        scrollView.delegate = self
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        //Header
        headerImageView = UIImageView(frame: headerView.bounds)
        headerImageView!.image = UIImage(named: "header_bg")
        headerImageView!.contentMode = .ScaleAspectFill
        headerView.insertSubview(headerImageView, belowSubview: headerLabel)
        
        //Blurred header
        
        blurredHeaderImageView = UIImageView(frame: headerView.bounds)
        blurredHeaderImageView!.image = UIImage(named: "header_bg")?.blurredImageWithRadius(10, iterations: 20, tintColor: UIColor.clearColor())
        blurredHeaderImageView!.contentMode = UIViewContentMode.ScaleAspectFill
        blurredHeaderImageView!.alpha = 0.0
        headerView.insertSubview(headerBlurImageView, belowSubview: headerLabel)
        
        header.clipsToBounds = true
    }
    
}

