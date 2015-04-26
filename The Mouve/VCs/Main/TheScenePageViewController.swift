//
//  TheScenePageViewController.swift
//  The Mouve
//
//  Created by Andrew Breckenridge on 4/24/15.
//  Copyright (c) 2015 Andrew Breckenridge. All rights reserved.
//

import UIKit

class TheScenePageViewController: UIPageViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        self.dataSource = self
        
        LocalMessage.observe(.TitleHitPageOne, classFunction: "pageOne", inClass: self)
        LocalMessage.observe(.TitleHitPageTwo, classFunction: "pageTwo", inClass: self)
        
        
        self.navigationItem.titleView = SceneTitleView(type: .Explore, superVC: "HomeFeed", frame: CGRect(origin: .zeroPoint, size: CGSize(width: 165, height: 44)))

        
        let sceneFeedVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("sceneFeedVC") as! SceneFeedViewController
        
        sceneFeedVC.type = .Explore
        
        self.setViewControllers([sceneFeedVC], direction: .Forward, animated: true, completion: nil)
    }
    
    func pageOne() {
        if (self.viewControllers[0] as! SceneFeedViewController).type == SceneType.Scene {
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("sceneFeedVC") as! SceneFeedViewController
            vc.type = .Explore
        
            self.setViewControllers([vc], direction: .Reverse, animated: true, completion: nil)
        }
    }
    
    func pageTwo() {
        if (self.viewControllers[0] as! SceneFeedViewController).type == SceneType.Explore {
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("sceneFeedVC") as! SceneFeedViewController
            vc.type = .Scene
            
            self.setViewControllers([vc], direction: .Forward, animated: true, completion: nil)
        }
    }
    
    @IBAction func hamburgerButtonWasHit(sender: AnyObject) {
    }
    
    @IBAction func activityButtonWasHit(sender: AnyObject) {
    }
}

extension TheScenePageViewController: UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        let afterVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("sceneFeedVC") as! SceneFeedViewController
        
        afterVC.type = .Explore
        
        return (viewController as! SceneFeedViewController).type == SceneType.Explore ? nil : afterVC
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        let beforeVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("sceneFeedVC") as! SceneFeedViewController
        
        beforeVC.type = .Scene
        
        return (viewController as! SceneFeedViewController).type == .Explore ? beforeVC : nil
    }
    
    func pageViewController(pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [AnyObject], transitionCompleted completed: Bool) {
        println("going to \((self.viewControllers[0] as! SceneFeedViewController).type.hashValue)")
        
        if (self.viewControllers[0] as! SceneFeedViewController).type == .Explore {
            LocalMessage.post(.HomeFeedPageOne)
        } else {
            LocalMessage.post(.HomeFeedPageTwo)
        }
    }
}