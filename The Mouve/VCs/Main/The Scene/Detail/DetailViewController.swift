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
    @IBOutlet weak var headerView: UIView!
    var headerImageView: UIImageView?
    var blurredHeaderImageView: UIImageView?
    
    @IBOutlet weak var calendarButton: UIButton!
    @IBOutlet weak var bookmarkButton: UIButton!
    @IBOutlet weak var shareButton: UIButton!
    
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
    }
    
    func styleViewProgrammatically() {
        for button in [calendarButton, bookmarkButton, shareButton] {
            button.layer.cornerRadius = button.frame.height
            button.layer.borderColor = UIColor.grayColor().CGColor
            button.layer.borderWidth = 1
        }
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
