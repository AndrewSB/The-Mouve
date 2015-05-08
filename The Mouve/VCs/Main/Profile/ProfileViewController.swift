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
    
    let data = [Event(name: "Beach Chillin", about: "Bring your swim suits! We will be chilling at the Lincoln Park Beach", time: NSDate(), length: 0, addressString: "Lincoln Beach", invitees: [43,43,43,43,43,43,4,3,4,343,43,34].map({"\($0)"}), backgroundImage: UIImage(named: "Beach-Chillin")!), Event(name: "Coffee Hour", about: "Let’s grab cup of coffee and discuss about fun things!", time: NSDate(), length: 3, addressString: "Cafe Kopi", invitees: [43,43,43,43,43,43,4,3,4,343,43,34].map({"\($0)"}), backgroundImage: UIImage(named: "Coffee-Hour")!), Event(name: "Espresso Lesson", about: "We will teach you how to brew coffee! It is $5 per person. Cash Only!", time: NSDate(), length: 4, addressString: "1005 W Gregory Dr.", invitees: ["dsad","dsad","dsad","dsad","dsad","dsad","dsad","dsad","dsad","dsad",], backgroundImage: UIImage(named: "Espresso-Lesson")!), Event(name: "Fireworks", about: "$8 entry fee. Come and have fun with fire!", time: NSDate(), length: 3, addressString: "Navy pier", invitees: [43,43,43,43,43,43,4,3,4,343,43,34].map({"\($0)"}), backgroundImage: UIImage(named: "Fire-Works")!), Event(name: "Food Festival", about: " Do you like food trucks? There will be a lots of them here! Come and eat our foods!", time: NSDate(), length: 3, addressString: "Green street", invitees: [43,43,43,43,43,43,4,3,4,343,43,34].map({"\($0)"}), backgroundImage: UIImage(named: "Food-Festival")!), Event(name: "Football game", about: "Bears and Bangles game. Come and support our team!", time: NSDate(), length: 3, addressString: "Memorial stadium", invitees: [43,43,43,43,43,43,4,3,4,343,43,34].map({"\($0)"}), backgroundImage: UIImage(named: "Football-Game")!), Event(name: "Internapalooza", about: " $8 entry fee. Bring your friends and family to celebrate our anniversary!", time: NSDate(), length: 3, addressString: "Siebel Center", invitees: [43,43,43,43,43,43,4,3,4,343,43,34].map({"\($0)"}), backgroundImage: UIImage(named: "Football-Game")!), Event(name: "Internapalooza", about: "hang out with people that are intending at san francisco over the summer! ", time: NSDate(), length: 3, addressString: "Siebel Center", invitees: [43,43,43,43,43,43,4,3,4,343,43,34].map({"\($0)"}), backgroundImage: UIImage(named: "San-Francisco-Visit")!), Event(name: "State Fair", about: "$5 entry fee.", time: NSDate(), length: 3, addressString: "Siebel Center", invitees: [43,43,43,43,43,43,4,3,4,343,43,34].map({"\($0)"}), backgroundImage: UIImage(named: "State-Fair")!), Event(name: "Surfing Lesson", about: "$30 fee per person. It will be 4 hours long at the beach.", time: NSDate(), length: 3, addressString: "Navy Pier", invitees: [43,43,43,43,43,43,4,3,4,343,43,34].map({"\($0)"}), backgroundImage: UIImage(named: "Surf-Lesson")!)]
    
    
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
        
        for button in [mouveButton, followersButton, followingButton] {
            button.titleLabel!.textAlignment = .Center
            button.setTitle("271\n\(button.titleLabel!.text!)", forState: UIControlState.Normal)
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
        return data.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cellID") as! HomeEventTableViewCell
        
        cell.event = data[indexPath.section]
        
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
