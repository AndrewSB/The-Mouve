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
    var event: Event!
    
    let tableViewImages = [UIImage(named: "chelsea-pic"), UIImage(named: "noah-pic"), UIImage(named: "taylor-pic"), UIImage(named: "chelsea-pic"), UIImage(named: "chelsea-pic")]
    let tableViewData = ["@troy posted a picture from the event on facebook and twitter.", "@noah There is still lots of food left!", "@tay posted a picture from the event on facebook and twitter.", "@chelsea this party is bumpin’"]
    
    
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
        collectionViewDidLoad()
        
        addNavControllerLikePan()
        
        headerImageView?.image = event.backgroundImage
        blurredHeaderImageView?.image = event.backgroundImage
        eventNameLabel.text = event.name
        descriptionLabel.text = event.about
        
        addressButton.titleLabel?.text = event.address
        inviteButton.titleLabel?.text = "\(event.invitees.count) Invited"
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

extension DetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableViewDidLoad() {
        self.postTableView.delegate = self
        self.postTableView.dataSource = self
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cellID") as! DetailPostTableViewCell
        
        cell.attributedLabel.text = tableViewData[indexPath.row]
        cell.profileImageView.image = tableViewImages[indexPath.row]
        
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 44
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableViewData.count
    }
}

extension DetailViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionViewDidLoad() {
        photoCollectionView.delegate = self
        photoCollectionView.dataSource = self
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cellID", forIndexPath: indexPath) as! UICollectionViewCell
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
}