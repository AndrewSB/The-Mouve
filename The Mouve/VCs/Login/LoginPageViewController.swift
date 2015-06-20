//
//  LoginPageViewController.swift
//  The Mouve
//
//  Created by Andrew Breckenridge on 4/1/15.
//  Copyright (c) 2015 Andrew Breckenridge. All rights reserved.
//

import UIKit
import Parse

class LoginPageViewController: UIPageViewController {
    var pageControl: UIPageControl?

    var viewLoadedIndex: Int!
    var showingIndex: Int! {
        didSet { pageControl?.currentPage = showingIndex }
    }
    
    let pageData: [(copy: String, image: String)] = [("Discover events that are happening around you", "background-1"), ("Create and attend events in a 24 hour period", "background-2"), ("Simply add the details and show case your event. It’s that simple.","background-3")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pageViewControllerDidLoad()
        addStaticViewElements()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBarHidden = true
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        statusBar(.LightContent)
    }
}

extension LoginPageViewController { //View code
    func addStaticViewElements() {
        self.pageControl = UIPageControl(frame: CGRect(view: view, height: 22, width: 44))
        pageControl!.numberOfPages = 3
        
        let mouveImageView = UIImageView(frame: CGRect(view: view, height: 44, width: 38))
        mouveImageView.frame.origin.y -= (self.view.frame.height*3 / 9)
        mouveImageView.image = UIImage(named: "mouve-icon")
        
        let loginButton = OutlinedButton(frame: CGRect(view: view, height: 36, width: 200), color: UIColor.seaFoamGreen())
        loginButton.addTarget(self, action: Selector("loginButtonWasHit:"), forControlEvents: .TouchUpInside)
        loginButton.setTitle("Login", forState: .Normal)
        loginButton.frame.origin.y += (self.view.frame.height / 4) - 50
        
        let signupButton = FilledButton(frame: CGRect(view: view, height: 36, width: 200), color: UIColor.seaFoamGreen())
        signupButton.addTarget(self, action: Selector("signupButtonWasHit:"), forControlEvents: .TouchUpInside)
        signupButton.setTitle("Sign up", forState: .Normal)
        signupButton.frame.origin.y += (self.view.frame.height / 4) + 15
        
        let skipButton = UIButton()
        skipButton.titleLabel?.font = UIFont(name: "HalisGR-Book", size: 14)
        skipButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        skipButton.setTitle("Try without an account", forState: .Normal)
        skipButton.sizeToFit()
        skipButton.frame = CGRect(origin: CGPoint(x: self.view.bounds.width  - skipButton.frame.width - 15, y: self.view.bounds.height - skipButton.frame.height - 5), size: skipButton.frame.size)
        skipButton.addTarget(self, action: Selector("skipButtonWasHit:"), forControlEvents: .TouchUpInside)
        
        [pageControl!, mouveImageView, loginButton, signupButton, skipButton].map({
            self.view.addSubview($0)
        })
    }
    
    func loginButtonWasHit(sender: AnyObject) {
        performSegueWithIdentifier("segueToLogin", sender: self)
    }
    
    func signupButtonWasHit(sender: AnyObject) {
        performSegueWithIdentifier("segueToSignup", sender: self)
    }
    
    func skipButtonWasHit(sender: AnyObject) {
        let loader = addSpinnerAndStall()
        
        PFAnonymousUtils.logInWithBlock { (user, error) -> Void in
            if error != nil || user == nil {
                self.presentViewController(UIAlertController(title: "Couldn't anonymously login", message: error!.localizedDescription), animated: true, completion: nil)
            }
            self.bringAliveAndRemove(loader)
            appDel.checkLogin()
        }
    }
}

extension LoginPageViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    func pageViewControllerDidLoad() {
        self.dataSource = self
        self.delegate = self
        
        let startingViewController = (viewControllerAtIndex(0) as TutorialViewController!)
        self.setViewControllers([startingViewController], direction: .Forward, animated: true, completion: nil)
    }
    
    func viewControllerAtIndex(index: Int) -> TutorialViewController? {
        let vc = UIStoryboard(name: "Login", bundle: nil).instantiateViewControllerWithIdentifier("tutorialPageVC") as! TutorialViewController
        
        viewLoadedIndex = index
        vc.pageIndex = viewLoadedIndex
        
        vc.title = pageData[viewLoadedIndex].copy
        vc.pageImage = UIImage(named: pageData[viewLoadedIndex].image)!
        
        return vc
    }

    
    /*
        Data Source
    */
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        let pageIndex = (viewController as! TutorialViewController).pageIndex
        
        switch pageIndex {
        case 1..<pageData.count.👎🏽:
            return viewControllerAtIndex(pageIndex - 1)
        default:
            return nil
        }
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        let pageIndex = (viewController as! TutorialViewController).pageIndex
        
        switch pageIndex {
        case 0..<pageData.count.👎🏽:
            return viewControllerAtIndex(pageIndex + 1)
        default:
            return nil
        }
    }
    
    
    /*
        Delegate
    */
    func pageViewController(pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [AnyObject], transitionCompleted completed: Bool) {
        if completed {
            let vc = pageViewController.viewControllers[0] as! TutorialViewController
            showingIndex = vc.pageIndex
        }
    }
}