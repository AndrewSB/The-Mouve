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
        
        let sceneFeedVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("sceneFeedVC") as! SceneFeedViewController
        
        sceneFeedVC.type = .Explore
        
        self.setViewControllers([sceneFeedVC], direction: .Forward, animated: true, completion: nil)
        
    }
    
    @IBAction func hamburgerButtonWasHit(sender: AnyObject) {
        (self.view.superview?.superview as? ECSlidingViewController)?.anchorTopViewToRightAnimated(true)
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
        println("changed page")
    }
}