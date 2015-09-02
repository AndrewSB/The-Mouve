//
//  ProfileViewController.swift
//  The Mouve
//
//  Created by Andrew Breckenridge on 4/28/15.
//  Copyright (c) 2015 Andrew Breckenridge. All rights reserved.
//

import UIKit
import Toucan
import CoreGraphics
import Parse
import DZNEmptyDataSet
enum ProfileType{
    case MyProfile, OtherUser
}

class ProfileViewController: UIViewController{
    let offset_HeaderStop:CGFloat = 180 // At this offset the Header stops its transformations
    let offset_B_LabelHeader:CGFloat = 120 // At this offset the Black label reaches the Header
    let distance_W_LabelHeader:CGFloat = 180 // The distance between the bottom of the Header and the top of the White Label
    var userMouves: [Events]? {
        
        didSet {
            self.tableViewDidLoad()
            profileTableView.reloadData()
            

        }
        
    }
    var user: PFUser?
    var pfType = ProfileType.MyProfile
    @IBOutlet weak var profilePicView: UIImageView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var separationLabel: UIView!
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var editProfileOrFollow: smallTextOutlinedButton!
    var headerImageView: UIImageView!
    var blurredHeaderImageView: UIImageView!
    
    @IBOutlet weak var mouveButton: UIButton!
    @IBOutlet weak var followingButton: UIButton!
    
    @IBOutlet weak var followersButton: UIButton!
    @IBOutlet weak var profileTableView: UITableView!
    
    @IBOutlet weak var avatarImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    var scrollView: UIScrollView!
    
    @IBOutlet weak var usernameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if pfType == ProfileType.MyProfile{
            print("Going with your profile since nothing was passed")
            user = appDel.currentUser!
        }
        else{
            editProfileOrFollow.setTitle("Follow", forState: UIControlState.Normal)

        }
        
        profileTableView.dataSource = self
        profileTableView.delegate = self
        self.getUserMouves()
        self.countFollowees()
        self.countFollowers()
//        avatarImage.layer.cornerRadius = avatarImage.frame.width/2
//        for button in [mouveButton, followersButton, followingButton] {
//            
//            if button.titleLabel!.text! == "Mouves"{
//            button.titleLabel!.textAlignment = .Center
//            button.setTitle("0\n\(button.titleLabel!.text!)", forState: UIControlState.Normal)
//            }
//            
//            else if button.titleLabel!.text! == "Followers"{
//                button.titleLabel!.textAlignment = .Center
//            button.setTitle("0\n\(button.titleLabel!.text!)", forState: UIControlState.Normal)
//            }
//            
//            else {
//                button.titleLabel!.textAlignment = .Center
//            button.setTitle("0\n\(button.titleLabel!.text!)", forState: UIControlState.Normal)
//            }
//        }

        nameLabel.text! = "\(user!.fullName)"
        usernameLabel.text! = "@" + user!.username!
        ParseUtility.getProfileImg(user!){(image, error) -> () in
                    let blurredImage = Toucan(image: image!.applyDarkEffect()).resize(self.headerView.frame.size, fitMode: .Crop).image
                    
                    
                    self.blurredHeaderImageView = UIImageView(frame: self.headerView.bounds)
                    self.blurredHeaderImageView.image = blurredImage
                    self.headerView.insertSubview(self.blurredHeaderImageView, belowSubview: self.usernameLabel)
                    self.usernameLabel.bringSubviewToFront(self.headerView)
                    self.profilePicView.image = Toucan(image: image!).resize(CGSize(width: self.profilePicView.bounds.width, height: self.profilePicView.bounds.height), fitMode: Toucan.Resize.FitMode.Crop).maskWithEllipse(3, borderColor: UIColor.seaFoamGreen()).image
        }
    }
    
    @IBAction func editProfileOrFollowButtonWasHit(sender: AnyObject) {
        
        if (user != appDel.currentUser){
            if (self.editProfileOrFollow.selected) {
                // Unattend
                self.editProfileOrFollow.selected = false;
                ParseUtility.unfollowUserEventually(self.user!)
                }
             else {
                // Attend
                self.editProfileOrFollow.selected = true;
                ParseUtility.followUserInBackground (self.user!){(success: Bool, error: NSError?) -> () in
                    if((error) != nil){
                        print("Cannot follow \(self.user!.username)")
                    }
                    else{
                        print("Following \(self.user!.username) successfully")
                    }
                }
            }
        }
        else {
            
        }
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.Default
        
        

    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
//        let navigationBarAppearance = UINavigationBar.appearance()
//        navigationBarAppearance.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
//        navigationBarAppearance.shadowImage = UIImage()
//        navigationBarAppearance.translucent = true

        
//        nameLabel.text! = "\(user!.fullName)"
//        usernameLabel.text! = "@" + user!.username!
//        let userImageFile = user?["profileImage"] as? PFFile
//        if(userImageFile != nil){
//            userImageFile!.getDataInBackgroundWithBlock({
//                (imageData: NSData?, error: NSError?) -> Void in
//                if (error == nil) {
//                    let image = UIImage(data:imageData!)
////                    self.avatarImage.image = image
//                    let blurredImage = Toucan(image: image!).resize(self.headerView.frame.size, fitMode: .Crop).image
//                    
//                    
//                    self.blurredHeaderImageView = UIImageView(frame: self.headerView.bounds)
//                    self.blurredHeaderImageView.image = blurredImage
//
//                    self.blurredHeaderImageView!.contentMode = UIViewContentMode.ScaleAspectFill
//                    self.blurredHeaderImageView!.alpha = 1.0
//                    self.headerView.insertSubview(self.blurredHeaderImageView, belowSubview: self.usernameLabel)
//                    
//                    let blurView = UIVisualEffectView(effect: UIBlurEffect(style: .Dark))
//                    blurView.frame = self.blurredHeaderImageView.frame
//                    
//                    self.blurredHeaderImageView.addSubview(blurView)
//                    
////                    self.headerView.clipsToBounds = true
//                    
//                    self.usernameLabel.bringSubviewToFront(self.headerView)
//                    self.profilePicView.image = Toucan(image: image!).resize(CGSize(width: self.profilePicView.bounds.width, height: self.profilePicView.bounds.height), fitMode: Toucan.Resize.FitMode.Crop).image
//                    
//                    self.profilePicView.layer.cornerRadius = self.profilePicView.frame.height / 2
//                    self.profilePicView.clipsToBounds = true
//
//                }
//                
//            })
//        }
//        self.edgesForExtendedLayout = UIRectEdge.None
        //Header
//        headerImageView = UIImageView(frame: headerView.bounds)
//        headerImageView!.image = avatarImage.image
//        headerImageView!.contentMode = .ScaleAspectFill
//        headerView.insertSubview(headerImageView, belowSubview: headerLabel)
        
        //Blurred header
        

        
    }

    func getUserMouves(){
        let mouvesAttended = NSMutableArray()
// Step 1: Query made events and find objects
        let mouvesFromUserQuery = Events.query()
        mouvesFromUserQuery!.whereKey("creator", equalTo: self.user!)
        mouvesFromUserQuery!.findObjectsInBackgroundWithBlock { (results: [AnyObject]?, error: NSError?) -> Void in
            if ((results) != nil) {
                mouvesAttended.addObjectsFromArray(results!)
// Step 2: Query attended events, find objects , and add objects to previous array
                let attendingQuery = Activity.query()
                attendingQuery!.whereKey("typeKey", equalTo: typeKeyEnum.Attend.rawValue)
                attendingQuery!.whereKey("fromUser", equalTo: self.user!)
                attendingQuery!.whereKeyExists("onMouve")
                attendingQuery!.findObjectsInBackgroundWithBlock{ (results: [AnyObject]?, error: NSError?) -> Void in
                    if ((results) != nil) {
                        for act in results as! [Activity]{
                            mouvesAttended.addObject(act.onMouve)
                        }
// Step 3: Sort attended events and fill up data into global variable
                        let startTimeSorter = NSSortDescriptor(key: "startTime", ascending:true )
                        self.userMouves = mouvesAttended.sortedArrayUsingDescriptors([startTimeSorter]) as? [Events]
                        self.mouveButton.setTitle("\(self.userMouves!.count)\nMouves", forState: UIControlState.Normal)
                    }
                }
            }
        }
    }
    func countFollowers(){
        let query = Activity.query()
        query!.whereKey("typeKey", equalTo:typeKeyEnum.Follow.rawValue)
        query!.whereKey("toUser", equalTo:user!)
        query!.countObjectsInBackgroundWithBlock(){(count: Int32, error: NSError?) -> Void in
            if ((error) == nil) {
                self.followersButton.setTitle("\(count)\nFollowers", forState: UIControlState.Normal)
            }

        }
    }
    func countFollowees(){
        let query = Activity.query()
        query!.whereKey("typeKey", equalTo:typeKeyEnum.Follow.rawValue)
        query!.whereKey("fromUser", equalTo:user!)
        query!.countObjectsInBackgroundWithBlock(){(count: Int32, error: NSError?) -> Void in
            if ((error) == nil) {
                self.followingButton.setTitle("\(count)\nFollowing", forState: UIControlState.Normal)
            }
        }
    }
}

extension ProfileViewController : DZNEmptyDataSetSource,DZNEmptyDataSetDelegate {
    func emptyDataSetDidTapButton(scrollView: UIScrollView!) {
        print("trying to add mouve")
        performSegueWithIdentifier("addMouve", sender: self)
    }
    func titleForEmptyDataSet(scrollView: UIScrollView!) -> NSAttributedString! {
        let text = (self.pfType == .MyProfile ? "Are you new?" : "Hmm...")
            return NSAttributedString(string:text)

    }
    
    func descriptionForEmptyDataSet(scrollView: UIScrollView!) -> NSAttributedString! {
        let text = (self.pfType == .MyProfile ? "Create more mouves now!" : "It seems like @\(user?.username) isn't a part of any public events")
        
        return NSAttributedString(string: text, attributes: [
            NSForegroundColorAttributeName: UIColor.grayColor()
            ])
    }
    
    func imageForEmptyDataSet(scrollView: UIScrollView!) -> UIImage! {
        return UIImage(named: "mouve-icon")
    }
}


extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return userMouves == nil ? 0 : userMouves!.count
    }
    
    func tableViewDidLoad() {
        self.profileTableView.delegate = self
        self.profileTableView.dataSource = self
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cellID") as! HomeEventTableViewCell
//        cell.parentVC = self
        cell.event = self.userMouves![indexPath.section]
        
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
        let offset = scrollView.contentOffset.y
        var avatarTransform = CATransform3DIdentity
        var headerTransform = CATransform3DIdentity
        var nameLabelTransform = CATransform3DIdentity
        var separationLabelTansform = CATransform3DIdentity
        
        print(offset)
        
        
        if offset < 0 { // PULL DOWN
            
            let headerScaleFactor:CGFloat = -(offset) / headerView.bounds.height
            let headerSizevariation = ((headerView.bounds.height * (1.0 + headerScaleFactor)) - headerView.bounds.height)/2.0
            headerTransform = CATransform3DTranslate(headerTransform, 0, headerSizevariation, 0)
            headerTransform = CATransform3DScale(headerTransform, 1.0 + headerScaleFactor, 1.0 + headerScaleFactor, 0)
            nameLabelTransform = CATransform3DMakeScale(1.0, 1.0, 0)

            separationLabelTansform = CATransform3DTranslate(separationLabelTansform, 1.0, headerSizevariation, 0)
            separationLabelTansform = CATransform3DScale(separationLabelTansform, 1.5 + headerScaleFactor, 1.5 + headerScaleFactor, 0)
            
            separationLabel.layer.transform = separationLabelTansform

            headerView.layer.transform = headerTransform
            nameLabel.layer.transform = nameLabelTransform
            
            

        }
            
        else { // PUSH UP
            
            // Header -----------
            
            headerTransform = CATransform3DTranslate(headerTransform, 0, max(-offset_HeaderStop, -offset), 0)
            
            //  ------------ Label
            
//            let nameScaleFactor = (min(offset_B_LabelHeader, offset)) / nameLabel.bounds.height / 1.4
//            let nameSizeVariation = ((nameLabel.bounds.height * (1.0 + nameScaleFactor)) - nameLabel.bounds.height) / 2.0
//            nameLabelTransform = CATransform3DMakeTranslation(0, 0, 0)
//            headerLabel.layer.transform = nameLabelTransform
            

            
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

                    // Makes the Fullname appear
                    nameLabelTransform = CATransform3DMakeScale(1.0, 1.0, 0)
                    nameLabel.layer.transform = nameLabelTransform

                }
                
            } else {
                if avatarImage.layer.zPosition >= headerView.layer.zPosition{
                    headerView.layer.zPosition = 2

                    
                    // Makes the Fullname disappear
                    nameLabelTransform = CATransform3DMakeScale(0, 0, 0)
                    nameLabel.layer.transform = nameLabelTransform
                    
//                    separationLabel.layer.transform = nameLabelTransform
                    

                }
            }
        }
        
        // Apply Transformations
        headerView.layer.transform = headerTransform
        separationLabel.layer.transform = headerTransform
        
        avatarImage.layer.transform = avatarTransform

        
    }
}
