//
//  LoginPageViewController.swift
//  The Mouve
//
//  Created by Andrew Breckenridge on 4/1/15.
//  Copyright (c) 2015 Andrew Breckenridge. All rights reserved.
//

import UIKit

class LoginPageViewController: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    var currentIndex: Int = Int()
    var showingIndex: Int = Int() {
        didSet {
            println("nah \(currentIndex)")
            pageControl?.currentPage = currentIndex
        }
    }
    
    let pageTitles = ["fuck", "this", "fucking", "shit"]
    let pageImages = [UIImage(named: "test"), UIImage(named: "test"), UIImage(named: "test"), UIImage(named: "test")]
    
    var pageControl: UIPageControl?
    
    var pageViews = [TutorialViewController]()


    override func viewDidLoad() {
        super.viewDidLoad()

        self.dataSource = self
        
        pageControl  = UIPageControl(frame: CGRect.CreateRectInCenterOfView(view, offset: 20, height: 40, width: 100))
        pageControl!.numberOfPages = 4
        pageControl!.currentPage = currentIndex
        
        view.addSubview(pageControl!)
        
        let startingViewController = (viewControllerAtIndex(0) as TutorialViewController!)
        let viewControllers = [startingViewController]
        
        self.setViewControllers(viewControllers, direction: .Forward, animated: true, completion: nil)
        edgesForExtendedLayout = .None
        
    }

    func viewControllerAtIndex(index: Int) -> TutorialViewController? {
        let vc = UIStoryboard(name: "Login", bundle: nil).instantiateViewControllerWithIdentifier("tutorialPageVC") as! TutorialViewController
        
        currentIndex = index
        vc.pageIndex = currentIndex
        
        vc.title = pageTitles[currentIndex]
        vc.pageImage = pageImages[currentIndex]!
        
        return vc
    }
    
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        var index = (viewController as! TutorialViewController).pageIndex
        
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
        var index = (viewController as! TutorialViewController).pageIndex
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

    func pageViewController(pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [AnyObject], transitionCompleted completed: Bool) {
        
        showingIndex = (pageViewController.viewControllers.last as! TutorialViewController).pageIndex
    }
}
