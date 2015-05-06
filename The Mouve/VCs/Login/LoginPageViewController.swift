//
//  LoginPageViewController.swift
//  The Mouve
//
//  Created by Andrew Breckenridge on 4/1/15.
//  Copyright (c) 2015 Andrew Breckenridge. All rights reserved.
//

import UIKit

class LoginPageViewController: UIPageViewController {
    var currentIndex: Int = Int()

    var showingIndex: Int = Int() {
        didSet {
            pageControl?.currentPage = showingIndex
        }
    }
    
    let pageTitles = ["Discover events that are happening around you", "Create and attend events in a 24 hour period", "Simply add the details and show case your event. It’s that simple."]
    let pageImages = [UIImage(named: "background-1"), UIImage(named: "background-2"), UIImage(named: "background-3")]
    
    var pageControl: UIPageControl?
    
    var pageViews = [TutorialViewController]()


    override func viewDidLoad() {
        super.viewDidLoad()
        self.dataSource = self
        self.delegate = self
        
        self.pageControl = UIPageControl(frame: CGRect.CreateRectInCenterOfView(self.view, height: 22, width: 40))
        pageControl!.numberOfPages = 3
        pageControl!.currentPage = 0
        
        self.view.addSubview(pageControl!)
        
        
        let startingViewController = (viewControllerAtIndex(0) as TutorialViewController!)
        self.setViewControllers([startingViewController], direction: .Forward, animated: true, completion: nil)
    }

    func viewControllerAtIndex(index: Int) -> TutorialViewController? {
        let vc = UIStoryboard(name: "Login", bundle: nil).instantiateViewControllerWithIdentifier("tutorialPageVC") as! TutorialViewController
        
        currentIndex = index
        vc.pageIndex = currentIndex
        
        vc.title = pageTitles[currentIndex]
        vc.pageImage = pageImages[currentIndex]!
        
        return vc
    }
}

extension LoginPageViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    /*
        Data Source
    */
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        var index = (viewController as! TutorialViewController).pageIndex
        
        switch index {
        case 0:
            return nil
        case NSNotFound:
            fatalError("NSNotFound")
        case pageTitles.count...Int.max-1:
            return nil
        default:
            index--
            return viewControllerAtIndex(index)
        }
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        var index = (viewController as! TutorialViewController).pageIndex
        index++
        
        switch index {
        case 0:
            return nil
        case NSNotFound:
            fatalError("NSNotFound")
        case pageTitles.count...Int.max-1:
            return nil
        default:
            return viewControllerAtIndex(index)
        }
    }
    
    
    /*
        Delegate
    */
    func pageViewController(pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [AnyObject], transitionCompleted completed: Bool) {
        println("at something")
        if completed {
            let vc = pageViewController.viewControllers[0] as! TutorialViewController
            println("\(vc.title) \(vc.pageIndex)")
            showingIndex = vc.pageIndex
        }
    }
}