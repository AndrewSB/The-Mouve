//
//  MainFeedViewController.swift
//  The Mouve
//
//  Created by Andrew Breckenridge on 4/8/15.
//  Copyright (c) 2015 Andrew Breckenridge. All rights reserved.
//

import UIKit

class MainFeedViewController: UIViewController {
    @IBOutlet weak var feedScrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        feedScrollView.contentSize = CGSize(width: view.frame.width, height: feedScrollView.frame.height)
        
        let homeTableView = UITableView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: feedScrollView.frame.height))
        let exploreTableView = UITableView(frame: CGRect(x: view.frame.width, y: 0, width: view.frame.width, height: feedScrollView.frame.height))
        
        homeTableView.delegate = self
        homeTableView.dataSource = self
        homeTableView.registerNib(UINib(nibName: "HomeFeedCell", bundle: nil), forCellReuseIdentifier: "cellID")
        exploreTableView.delegate = self
        exploreTableView.dataSource = self
        
        
        feedScrollView.addSubview(homeTableView)
        feedScrollView.addSubview(exploreTableView)
        view.addSubview(feedScrollView)
    }
}


extension MainFeedViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return indexPath.row == 4 ? 115 : 120
    }
  
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("cellID", forIndexPath: indexPath) as? HomeEventTableViewCell

        
        if indexPath.row == 4 {
            cell!.bottomSpacerView.frame = CGRect.nullRect
        }
        return cell!
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        performSegueWithIdentifier("segueToDetail", sender: self)
    }
}
