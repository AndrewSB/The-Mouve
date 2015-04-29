//
//  ViewController.swift
//  Profile
//
//  Created by Andrew Breckenridge on 4/28/15.
//  Copyright (c) 2015 Andrew Breckenridge. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate {
    let offset_HeaderStop:CGFloat = 100 // At this offset the Header stops its transformations
    let offset_B_LabelHeader:CGFloat = 95.0 // At this offset the Black label reaches the Header
    let distance_W_LabelHeader:CGFloat = 35.0 // The distance between the bottom of the Header and the top of the White Label

    
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
        profileTableView.delegate = self
        
        avatarImage.layer.cornerRadius = avatarImage.frame.width/2
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
        headerView.insertSubview(blurredHeaderImageView, belowSubview: headerLabel)
        
        headerView.clipsToBounds = true
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        var offset = scrollView.contentOffset.y
        var avatarTransform = CATransform3DIdentity
        var headerTransform = CATransform3DIdentity
        
        
        if offset < 0 { // PULL DOWN
            
            let headerScaleFactor:CGFloat = -(offset) / headerView.bounds.height
            let headerSizevariation = ((headerView.bounds.height * (1.0 + headerScaleFactor)) - headerView.bounds.height)/2.0
            headerTransform = CATransform3DTranslate(headerTransform, 0, headerSizevariation, 0)
            headerTransform = CATransform3DScale(headerTransform, 1.0 + headerScaleFactor, 1.0 + headerScaleFactor, 0)
            
            headerView.layer.transform = headerTransform
        }
        
        else { // PULL UP
            
            // Header -----------
            
            headerTransform = CATransform3DTranslate(headerTransform, 0, max(-offset_HeaderStop, -offset), 0)
            
            //  ------------ Label
            
            let labelTransform = CATransform3DMakeTranslation(0, max(-distance_W_LabelHeader, offset_B_LabelHeader - offset), 0)
            headerLabel.layer.transform = labelTransform
            
            //  ------------ Blur
            
            blurredHeaderImageView?.alpha = min (1.0, (offset - offset_B_LabelHeader)/distance_W_LabelHeader)
            
            // Avatar -----------
            
            let avatarScaleFactor = (min(offset_HeaderStop, offset)) / avatarImage.bounds.height / 1.4 // Slow down the animation
            let avatarSizeVariation = ((avatarImage.bounds.height * (1.0 + avatarScaleFactor)) - avatarImage.bounds.height) / 2.0
            avatarTransform = CATransform3DTranslate(avatarTransform, 0, avatarSizeVariation, 0)
            avatarTransform = CATransform3DScale(avatarTransform, 1.0 - avatarScaleFactor, 1.0 - avatarScaleFactor, 0)
            
            if offset <= offset_HeaderStop {
                
                if avatarImage.layer.zPosition < headerView.layer.zPosition{
                    headerView.layer.zPosition = 0
                }
                
            }else {
                if avatarImage.layer.zPosition >= headerView.layer.zPosition{
                    headerView.layer.zPosition = 2
                }
            }
        }
        
        // Apply Transformations
        
        headerView.layer.transform = headerTransform
        avatarImage.layer.transform = avatarTransform

    }
    
}

