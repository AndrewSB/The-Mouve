//
//  DetailViewControllerViewExtension.swift
//  The Mouve
//
//  Created by Andrew Breckenridge on 5/5/15.
//  Copyright (c) 2015 Andrew Breckenridge. All rights reserved.
//

import UIKit
import Toucan

extension DetailViewController { // View code and actions
    func styleHeader() {
        headerImageView = UIImageView(frame: headerView.bounds)
        headerImageView!.image = UIImage(named: "list-background")
        headerImageView!.contentMode = .ScaleAspectFill
        headerView.addSubview(headerImageView!)
        
        //Blurred header
//        let blurredImage = Toucan(image: UIImage(named: "andrew-pic")!).resize(headerView.frame.size, fitMode: .Crop)
//        
//        blurredHeaderImageView = UIImageView(frame: headerView.bounds)
//        blurredHeaderImageView!.image = blurredImage.image
//        
//        blurredHeaderImageView!.contentMode = UIViewContentMode.ScaleAspectFill
//        blurredHeaderImageView!.alpha = 0.5
//        headerView.addSubview(blurredHeaderImageView!)
        
        headerView.clipsToBounds = true
        
        backButton.bringSubviewToFront(view)
    }
    
    func styleViewProgrammatically() {
        tableViewHeaderView.frame.size.height = addPostButton.frame.origin.y + addPostButton.frame.height
        
        [calendarButton, shareButton, bookmarkButton].map({
            $0.type = .Detail
        })
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        let offset_HeaderStop:CGFloat = 400 // At this offset the Header stops its transformations
        let offset_B_LabelHeader:CGFloat = 400 // At this offset the Black label reaches the Header
        let distance_W_LabelHeader:CGFloat = 400 // The distance between the bottom of the Header and the top of the White Label
        
        var offset = scrollView.contentOffset.y
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
            
            //  ------------ Blur
//            blurredHeaderImageView?.alpha = min (1.0, (offset - offset_B_LabelHeader)/distance_W_LabelHeader)
        }
        
        // Apply Transformations
        headerView.layer.transform = headerTransform
    }
    
    
    @IBAction func calendarButtonWasHit(sender: AnyObject) {
        calendarButton.completed!.toggle()
    }
    
    @IBAction func bookmarkButtonWasHit(sender: AnyObject) {
        bookmarkButton.completed!.toggle()
    }
    
    @IBAction func shareButtonWasHit(sender: AnyObject) {
        shareButton.completed!.toggle()
    }
    
    
    @IBAction func backButtonWasHit(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
}
