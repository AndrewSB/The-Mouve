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
        self.setViewControllers([SceneFeedViewController(type: .Scene)], direction: .Forward, animated: true, completion: nil)
    }
}

extension TheScenePageViewController: UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        return (viewController as! SceneFeedViewController).type == SceneType.Explore ? SceneFeedViewController(type: .Scene) : nil
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        return (viewController as! SceneFeedViewController).type == SceneType.Explore ? nil : SceneFeedViewController(type: .Scene)
    }
}