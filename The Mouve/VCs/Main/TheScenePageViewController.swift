//
//  TheScenePageViewController.swift
//  The Mouve
//
//  Created by Andrew Breckenridge on 4/24/15.
//  Copyright (c) 2015 Andrew Breckenridge. All rights reserved.
//

import UIKit
import Alamofire

class TheScenePageViewController: UIPageViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        self.dataSource = self
        
        assert(view.subviews[0] is UIScrollView, "s")
        (view.subviews[0] as! UIScrollView).delegate = self
        
        LocalMessage.observe(.TitleHitPageOne, classFunction: "pageOne", inClass: self)
        LocalMessage.observe(.TitleHitPageTwo, classFunction: "pageTwo", inClass: self)
        
        navigationItem.titleView = SceneTitleView(type: .Explore, superVC: "HomeFeed", frame: CGRect(x: 0, y: 0, width: 180, height: 44))

        pageViewControllerDidLoad()
    }
    
    func pageOne() {
        if (self.viewControllers[0] as! SceneFeedViewController).type == SceneType.Scene {
            let vc = initVC("sceneFeedVC", storyboard: "Main") as! SceneFeedViewController
            vc.type = .Explore
        
            self.setViewControllers([vc], direction: .Reverse, animated: true, completion: nil)
        }
    }
    
    func pageTwo() {
        if (self.viewControllers[0] as! SceneFeedViewController).type == SceneType.Explore {
            let vc = initVC("sceneFeedVC", storyboard: "Main") as! SceneFeedViewController
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
    func pageViewControllerDidLoad() {
        let sceneFeedVC = initVC("sceneFeedVC", storyboard: "Main") as! SceneFeedViewController
        sceneFeedVC.type = .Explore
        
        self.setViewControllers([sceneFeedVC], direction: .Forward, animated: true, completion: nil)
        
        self.view.backgroundColor = UIColor.whiteColor()
        if let url = UserDefaults.profilePictureURL {
            Alamofire.request(.GET, url).response { (request, response, data, error) -> () in
                if let data = data as? NSData {
                    let profileImage = UIImage(data: data)
                    if let profileImage = profileImage {
                        let imageView = UIImageView(image: profileImage)
                        imageView.frame = self.view.frame
                        
                        let blurView = UIVisualEffectView(effect: UIBlurEffect(style: .Light))
                        blurView.frame = self.view.frame
                        
                        imageView.addSubview(blurView)
                        
                        dispatch_async(dispatch_get_main_queue(), {
                            self.view.insertSubview(imageView, atIndex: 0)
                        })
                    }
                }
            }
        }
    }
    
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
}

extension TheScenePageViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(scrollView: UIScrollView) {
        println((scrollView.contentOffset.x - view.frame.width - 44)/view.frame.width)
    }
}