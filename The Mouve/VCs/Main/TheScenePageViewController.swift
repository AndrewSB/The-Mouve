//
//  TheScenePageViewController.swift
//  The Mouve
//
//  Created by Andrew Breckenridge on 4/24/15.
//  Copyright (c) 2015 Andrew Breckenridge. All rights reserved.
//

import UIKit

class TheScenePageViewController: UIPageViewController {
    private let sceneFeedVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("sceneFeedVC") as! SceneFeedViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        self.dataSource = self
        
        sceneFeedVC.type = .Explore
        
        self.setViewControllers([sceneFeedVC], direction: .Forward, animated: true, completion: nil)
    }
}

extension TheScenePageViewController: UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        sceneFeedVC.type = .Scene
        
        println("before \((viewController as! SceneFeedViewController).type.hashValue)")
        
        return (viewController as! SceneFeedViewController).type == SceneType.Explore ? sceneFeedVC : nil
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        sceneFeedVC.type = .Explore
        
        println("after \((viewController as! SceneFeedViewController).type.hashValue)")
        
        return (viewController as! SceneFeedViewController).type == SceneType.Explore ? nil : sceneFeedVC
    }
}