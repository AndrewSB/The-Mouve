//
//  TutorialPageViewControllerDataSource.swift
//  The Mouve
//
//  Created by Andrew Breckenridge on 3/5/15.
//  Copyright (c) 2015 Andrew Breckenridge. All rights reserved.
//

import UIKit

class TutorialPageViewControllerDataSource: NSObject, UIPageViewControllerDataSource {
    let pageTitles = ["Create a Glassjar to collect money from your friends", "Get your friends to join in", "Get paid and do something awesome!", "The simplest way to collect money from your friends"]
    let pageImages = [UIImage(named: "screen1"), UIImage(named: "screen2"), UIImage(named: "screen3"), nil]
    var currentIndex: Int = Int()
    
    func viewControllerAtIndex(index: Int) -> TutorialViewController? {
        let vc = UIStoryboard(name: "Welcome", bundle: nil).instantiateViewControllerWithIdentifier("tutorialPageVC") as TutorialViewController
        
        currentIndex = index
        vc.pageIndex = currentIndex
        
        
        vc.title = pageTitles[currentIndex]
        
        return vc
    }
    
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        var index = (viewController as TutorialViewController).pageIndex
        
        switch index {
        case 0:
            return nil
        case NSNotFound:
            fatalError("NSNotFound")
        case pageTitles.count...Int.max:
            return nil
        default:
            index--
            return viewControllerAtIndex(index)
        }
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        var index = (viewController as TutorialViewController).pageIndex
        index++
        
        switch index {
        case 0:
            return nil
        case NSNotFound:
            fatalError("NSNotFound")
        case pageTitles.count...Int.max:
            return nil
        default:
            return viewControllerAtIndex(index)
        }
    }

}
