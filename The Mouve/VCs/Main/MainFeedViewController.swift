//
//  MainFeedViewController.swift
//  The Mouve
//
//  Created by Andrew Breckenridge on 4/8/15.
//  Copyright (c) 2015 Andrew Breckenridge. All rights reserved.
//

import UIKit

class MainFeedViewController: UIViewController {
    @IBOutlet weak var homeTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        homeTableView.delegate = self
        homeTableView.dataSource = self
        
        let feedScrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: view.bounds.width * 2, height: view.bounds.height - 22 - 40 - 20))
        
        homeTableView.removeFromSuperview()
        feedScrollView.addSubview(homeTableView)
        
        homeTableView.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height - 22 - 44 - 20)
        
        let exploreTableView = UITableView(frame: homeTableView.frame, style: homeTableView.style)
        exploreTableView.frame.origin = CGPoint(x: view.bounds.width, y: 22 + 44 + 20)
        
        feedScrollView.addSubview(exploreTableView)
        view.addSubview(feedScrollView)
        
        feedScrollView.frame.origin = CGPoint(x: 0, y: 5)
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
        let cell = tableView.dequeueReusableCellWithIdentifier("cellID") as! HomeEventTableViewCell
        
        if indexPath.row == 4 {
            cell.bottomSpacerView.frame = CGRect.nullRect
        }
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        performSegueWithIdentifier("segueToDetail", sender: self)
    }
}
