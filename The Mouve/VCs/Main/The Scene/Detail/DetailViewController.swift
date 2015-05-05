//
//  DetailViewController.swift
//  The Mouve
//
//  Created by Andrew Breckenridge on 4/15/15.
//  Copyright (c) 2015 Andrew Breckenridge. All rights reserved.
//

import UIKit
import Toucan

class DetailViewController: UIViewController {
    @IBOutlet weak var backButton: UIButton!
    
    @IBOutlet weak var headerView: UIView!
    var headerImageView: UIImageView?
    var blurredHeaderImageView: UIImageView?
    
    @IBOutlet weak var tableViewHeaderView: UIView!
    
    @IBOutlet weak var calendarButton: GreyGreenButton!
    @IBOutlet weak var bookmarkButton: GreyGreenButton!
    @IBOutlet weak var shareButton: GreyGreenButton!
    
    @IBOutlet weak var eventNameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var addressButton: UIButton!
    @IBOutlet weak var inviteButton: UIButton!
    
    @IBOutlet weak var photoCollectionView: UICollectionView!
    
    @IBOutlet weak var addPostButton: UIButton!

    @IBOutlet weak var postTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        styleHeader()
        styleViewProgrammatically()
        tableViewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBarHidden = true
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBarHidden = false
    }
}

extension DetailViewController { // View code and actions
    func styleHeader() {
        headerImageView = UIImageView(frame: headerView.bounds)
        headerImageView!.image = UIImage(named: "andrew-pic")
        headerImageView!.contentMode = .ScaleAspectFill
        headerView.addSubview(headerImageView!)
        
        //Blurred header
        let blurredImage = Toucan(image: UIImage(named: "andrew-pic")!).resize(headerView.frame.size, fitMode: .Crop)
        
        blurredHeaderImageView = UIImageView(frame: headerView.bounds)
        blurredHeaderImageView!.image = blurredImage.image
        
        blurredHeaderImageView!.contentMode = UIViewContentMode.ScaleAspectFill
        blurredHeaderImageView!.alpha = 0.0
        headerView.addSubview(blurredHeaderImageView!)
        
        headerView.clipsToBounds = true
        
        backButton.bringSubviewToFront(self.view)
    }
    
    func styleViewProgrammatically() {
        tableViewHeaderView.frame.size.height = addPostButton.frame.origin.y + addPostButton.frame.height
        
        for button in [calendarButton, bookmarkButton, shareButton] {
            button.layer.cornerRadius = button.frame.height / 2
            button.layer.borderColor = UIColor.grayColor().CGColor
            button.layer.borderWidth = 1
        }
        
        addPostButton.layer.cornerRadius = 5
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        let offset_HeaderStop:CGFloat = 85 // At this offset the Header stops its transformations
        let offset_B_LabelHeader:CGFloat = 80 // At this offset the Black label reaches the Header
        let distance_W_LabelHeader:CGFloat = 35 // The distance between the bottom of the Header and the top of the White Label
        
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
            
            blurredHeaderImageView?.alpha = min (1.0, (offset - offset_B_LabelHeader)/distance_W_LabelHeader)
        }
        
        // Apply Transformations
        headerView.layer.transform = headerTransform
    }
    
    @IBAction func backButtonWasHit(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
}

extension DetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableViewDidLoad() {
        self.postTableView.delegate = self
        self.postTableView.dataSource = self
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cellID") as! DetailPostTableViewCell
        
        cell.textLabel?.text = "sup"
        
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
}
