//
//  ProfileViewController.swift
//  The Mouve
//
//  Created by Andrew Breckenridge on 4/28/15.
//  Copyright (c) 2015 Andrew Breckenridge. All rights reserved.
//

import UIKit
import Toucan

class ProfileViewController: UIViewController, UITableViewDelegate {
    let offset_HeaderStop:CGFloat = 180 // At this offset the Header stops its transformations
    let offset_B_LabelHeader:CGFloat = 120 // At this offset the Black label reaches the Header
    let distance_W_LabelHeader:CGFloat = 180 // The distance between the bottom of the Header and the top of the White Label
    
    
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var headerLabel: UILabel!
    var headerImageView: UIImageView!
    var blurredHeaderImageView: UIImageView!
    
    @IBOutlet weak var mouveButton: UIButton!
    @IBOutlet weak var followersButton: UIButton!
    @IBOutlet weak var followingButton: UIButton!
    
    @IBOutlet weak var profileTableView: UITableView!
    
    @IBOutlet weak var avatarImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    var scrollView: UIScrollView!
    
    @IBOutlet weak var dumbLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        profileTableView.dataSource = self
        profileTableView.delegate = self
        
        avatarImage.layer.cornerRadius = avatarImage.frame.width/2
        
        nameLabel.text! = RealmStore.sharedInstance.currentUser.username
        dumbLabel.text! = "@" + RealmStore.sharedInstance.currentUser.username
        
        for button in [mouveButton, followersButton, followingButton] {
            
            if button.titleLabel!.text! == "Mouves"{
            button.titleLabel!.textAlignment = .Center
            button.setTitle("\(RealmStore.sharedInstance.currentUser.myMouves.count)\n\(button.titleLabel!.text!)", forState: UIControlState.Normal)
            }
            
            else if button.titleLabel!.text! == "Followers"{
                button.titleLabel!.textAlignment = .Center
                button.setTitle("\(RealmStore.sharedInstance.followersList.count)\n\(button.titleLabel!.text!)", forState: UIControlState.Normal)
            }
            
            else {
                button.titleLabel!.textAlignment = .Center
                button.setTitle("\(RealmStore.sharedInstance.followingList.count)\n\(button.titleLabel!.text!)", forState: UIControlState.Normal)
            }
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        //Header
//        headerImageView = UIImageView(frame: headerView.bounds)
//        headerImageView!.image = UIImage(named: "yoojin-full-pic")
//        headerImageView!.contentMode = .ScaleAspectFill
//        headerView.insertSubview(headerImageView, belowSubview: headerLabel)
        
        //Blurred header
        
        let blurredImage = Toucan(image: UIImage(named: "yoojin-full-pic")!).resize(headerView.frame.size, fitMode: .Crop)
        
        
        blurredHeaderImageView = UIImageView(frame: headerView.bounds)
        blurredHeaderImageView.image = blurredImage.image

        blurredHeaderImageView!.contentMode = UIViewContentMode.ScaleAspectFill
        blurredHeaderImageView!.alpha = 1.0
        headerView.insertSubview(blurredHeaderImageView, belowSubview: dumbLabel)
        
        let blurView = UIVisualEffectView(effect: UIBlurEffect(style: .Dark))
        blurView.frame = blurredHeaderImageView.frame
        
        blurredHeaderImageView.addSubview(blurView)
        
        headerView.clipsToBounds = true
        
        dumbLabel.bringSubviewToFront(headerView)
    }
}

extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return fakeEvents.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cellID") as! HomeEventTableViewCell
        
        cell.event = fakeEvents[indexPath.section]
        
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 130
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? 0 : 4
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        var offset = scrollView.contentOffset.y
        var avatarTransform = CATransform3DIdentity
        var headerTransform = CATransform3DIdentity
        
        println(offset)
        
        
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
            
//            let labelTransform = CATransform3DMakeTranslation(0, max(-distance_W_LabelHeader, offset_B_LabelHeader - offset), 0)
//            headerLabel.layer.transform = labelTransform
            
            //  ------------ Blur
            
            blurredHeaderImageView?.alpha = max (1.0, (offset - offset_B_LabelHeader)/distance_W_LabelHeader)
            
            // Avatar -----------
            
            let avatarScaleFactor = (min(offset_HeaderStop, offset)) / avatarImage.bounds.height / 1.4 // Slow down the animation
            let avatarSizeVariation = ((avatarImage.bounds.height * (1.0 + avatarScaleFactor)) - avatarImage.bounds.height) / 2.0
            avatarTransform = CATransform3DTranslate(avatarTransform, 0, avatarSizeVariation, 0)
            avatarTransform = CATransform3DScale(avatarTransform, 1.0 - avatarScaleFactor, 1.0 - avatarScaleFactor, 0)
            
            if offset <= offset_HeaderStop {
                
                if avatarImage.layer.zPosition < headerView.layer.zPosition{
                    headerView.layer.zPosition = 0
                }
                
            } else {
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
