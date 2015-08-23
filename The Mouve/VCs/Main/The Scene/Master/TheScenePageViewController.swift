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
        
        LocalMessage.observe(.HomeTitlePageOne, classFunction: "pageOne", inClass: self)
        LocalMessage.observe(.HomeTitlePageTwo, classFunction: "pageTwo", inClass: self)
        
        navigationItem.titleView = SceneTitleView(type: .Explore, frame: CGRect(x: 0, y: 0, width: 140, height: 44))
        
//        let currentMouves = Realm().objects(Mouve)

        pageViewControllerDidLoad()
    }
    
    func pageOne() {
        if (self.viewControllers[0] as! SceneFeedViewController).type == SceneType.Scene {
            self.setViewControllers([sceneVCWithType(.Explore)], direction: .Forward, animated: true, completion: nil)
        }
    }
    
    func pageTwo() {
        if (self.viewControllers[0] as! SceneFeedViewController).type == SceneType.Explore {
            self.setViewControllers([sceneVCWithType(.Scene)], direction: .Reverse, animated: true, completion: nil)
        }
    }
    
    @IBAction func hamburgerButtonWasHit(sender: AnyObject) {
    }
    
    @IBAction func activityButtonWasHit(sender: AnyObject) {
    }
}

extension TheScenePageViewController: UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    func pageViewControllerDidLoad() {
        self.setViewControllers([sceneVCWithType(.Scene)], direction: .Reverse, animated: true, completion: nil)
        
        self.view.backgroundColor = UIColor.whiteColor()
        if let url = UserDefaults.profilePictureURL {
            Alamofire.request(.GET, url).response { (request, response, data, error) -> () in
                if let data = data as NSData? {
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
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        return (viewController as! SceneFeedViewController).type == .Scene ? sceneVCWithType(.Explore) : nil
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        return (viewController as! SceneFeedViewController).type == SceneType.Explore ? nil : sceneVCWithType(.Scene)
    }
    
    
    func sceneVCWithType(type: SceneType) -> SceneFeedViewController {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("sceneFeedVC") as! SceneFeedViewController
        vc.type = type
        
        return vc
    }
    
    @IBAction func unwindToTheSceneVC(segue: UIStoryboardSegue) {}
}