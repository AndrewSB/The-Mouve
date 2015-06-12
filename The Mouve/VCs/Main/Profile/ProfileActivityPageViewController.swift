//
//  ActivityPageViewController.swift
//  The Mouve
//
//  Created by Sam Ojogbo on 6/05/15.
//  Copyright (c) 2015 Sam Ojogbo. All rights reserved.
//

import UIKit

class ProfileActivityPageViewController: UIPageViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        pageViewControllerDidLoad()
        
        LocalMessage.observe(.ActivityTitlePageOne, classFunction: "pageOne", inClass: self)
        LocalMessage.observe(.ActivityTitlePageTwo, classFunction: "pageTwo", inClass: self)
    }
    
    func pageOne() {
        if (self.viewControllers[0] as! ProfileActivityTableViewController).type == SceneType.Following {
            self.setViewControllers([activityVCWithType(.Followers)], direction: .Reverse, animated: true, completion: nil)
        }
    }

    func pageTwo() {
        
        if (self.viewControllers[0] as! ProfileActivityTableViewController).type == SceneType.Followers {
            self.setViewControllers([activityVCWithType(.Following)], direction: .Forward, animated: true, completion: nil)
        }

    }

}

extension ProfileActivityPageViewController: UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    func pageViewControllerDidLoad() {
        self.setViewControllers([activityVCWithType(.Followers)], direction: .Forward, animated: true, completion: nil)
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        return (viewController as! ProfileActivityTableViewController).type == .Following ? nil : activityVCWithType(.Followers)
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        return (viewController as! SceneFeedViewController).type == .Followers ? activityVCWithType(.Following) : nil
    }
    
    func activityVCWithType(type: SceneType) -> ProfileActivityTableViewController {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("activityTableVC") as! ProfileActivityTableViewController
        vc.type = type
        
        return vc
    }
}