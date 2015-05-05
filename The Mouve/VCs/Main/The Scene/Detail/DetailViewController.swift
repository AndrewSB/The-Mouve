//
//  DetailViewController.swift
//  The Mouve
//
//  Created by Andrew Breckenridge on 4/15/15.
//  Copyright (c) 2015 Andrew Breckenridge. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

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

        self.navigationController?.navigationBarHidden = true
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

extension DetailViewController {
    @IBAction func backButtonWasHit(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
}
