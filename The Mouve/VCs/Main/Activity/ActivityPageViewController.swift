//
//  ActivityPageViewController.swift
//  The Mouve
//
//  Created by Andrew Breckenridge on 4/25/15.
//  Copyright (c) 2015 Andrew Breckenridge. All rights reserved.
//

import UIKit

class ActivityPageViewController: UIPageViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        pageViewControllerDidLoad()
        
        LocalMessage.observe(.ActivityTitlePageOne, classFunction: "pageOne", inClass: self)
        LocalMessage.observe(.ActivityTitlePageTwo, classFunction: "pageTwo", inClass: self)
    }
    
    func pageOne() {
        if (self.viewControllers![0] as! ActivityTableViewController).type == SceneType.Newsfeed {
            self.setViewControllers([activityVCWithType(.Invites)], direction: .Forward, animated: true, completion: nil)
        }
    }

    func pageTwo() {
        
        if (self.viewControllers![0] as! ActivityTableViewController).type == SceneType.Invites {
            self.setViewControllers([activityVCWithType(.Newsfeed)], direction: .Reverse, animated: true, completion: nil)
        }

    }

}

extension ActivityPageViewController: UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    func pageViewControllerDidLoad() {
        self.setViewControllers([activityVCWithType(.Newsfeed)], direction: .Forward, animated: true, completion: nil)
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        return (viewController as! ActivityTableViewController).type == .Invites ? nil : activityVCWithType(.Newsfeed)
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        return (viewController as! ActivityTableViewController).type == .Newsfeed ? activityVCWithType(.Invites) : nil
    }
    
    func activityVCWithType(type: SceneType) -> ActivityTableViewController {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("activityTableVC") as! ActivityTableViewController
        vc.type = type
        
        return vc
    }
}