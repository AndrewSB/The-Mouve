//
//  SceneTitleView.swift
//  The Mouve
//
//  Created by Andrew Breckenridge on 4/24/15.
//  Copyright (c) 2015 Andrew Breckenridge. All rights reserved.
//

import UIKit

enum SceneType: String {
    case Explore = "Explore"
    case Scene = "The Scene"
    
    case Newsfeed = "Newsfeed"
    case Invites = "Invites"
    
    case Followers = "Followers"
    case Following = "Following"
}

class SceneTitleView: UIView {
    var view: UIView!
    
    @IBOutlet weak var leftButton: UIButton!
    @IBOutlet weak var rightButton: UIButton!
    @IBOutlet weak var underlineView: UIView!
    
    convenience init(type: SceneType, frame: CGRect) { //init from code
        self.init(frame: frame)
        
        self.type = type
        
        otherSetup()
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        xibSetup()
    }
    
    required init(coder aDecoder: NSCoder) { //init from storyboard
        super.init(coder: aDecoder)
        
        xibSetup()
        otherSetup()
    }
    
    func xibSetup() {
        self.view = loadViewFromNib("SceneTitleView")
        
        view.frame = bounds
        view.autoresizingMask = .FlexibleWidth | .FlexibleHeight
        
        addSubview(view)
    }
    
    func otherSetup() {
        self.leftButton.setTitle(self.buttonOne.0.rawValue.uppercaseString, forState: .Normal)
        self.leftButton.titleLabel?.sizeToFit()
        
        self.rightButton.setTitle(self.buttonTwo.0.rawValue.uppercaseString, forState: .Normal)
        self.rightButton.titleLabel?.sizeToFit()
        
        dispatch_async(dispatch_get_main_queue(), {
            println("didload")
            self.underlineView.frame.size = CGSize(width: self.leftButton.frame.width, height: 2)
            self.underlineView.frame.origin.y = self.leftButton.frame.origin.y + self.leftButton.bounds.height - 4
            self.underlineView.frame.origin.x = self.leftButton.frame.origin.x
        })
        
        LocalMessage.observe(buttonOne.2, classFunction: "pageOne", inClass: self)
        LocalMessage.observe(buttonTwo.2, classFunction: "pageTwo", inClass: self)
    }
    
    
    
    var type: SceneType? {
        willSet {
            UIView.animateWithDuration(0.2, animations: {
                let animateToButton = newValue == self.buttonOne.0 ? self.leftButton : self.rightButton
                
                let origin = CGPoint(x: animateToButton.frame.origin.x, y: animateToButton.frame.origin.y + animateToButton.frame.height - 4)
                self.underlineView.frame = CGRect(origin: origin, size: CGSize(width: animateToButton.frame.width, height: 2))
            })
        }
    }
    
    func pageOne() { type = buttonOne.0 }
    func pageTwo() { type = buttonTwo.0 }
    
    
    @IBAction func leftButtonWasHit(sender: AnyObject) {
        if type != buttonOne.0 {
            LocalMessage.post(buttonOne.1)
            type = buttonOne.0
        }
    }
    
    @IBAction func rightButtonWasHit(sender: AnyObject) {
        if type != buttonTwo.0 {
            LocalMessage.post(buttonTwo.1)
            type = buttonTwo.0
        }
    }
    
    var buttonOne: (SceneType, LocalMessageNotification, LocalMessageNotification) {
        get {
            if 0...1 ~= type!.hashValue {
                return (.Explore, .HomeTitlePageOne, .HomeFeedPageOne)
            } else {
                return (.Newsfeed, .ActivityTitlePageOne, .ActivityFeedPageOne)
            }
        }
    }
    
    var buttonTwo: (SceneType, LocalMessageNotification, LocalMessageNotification) {
        get {
            if 0...1 ~= type!.hashValue {
                return (.Scene, .HomeTitlePageTwo, .HomeFeedPageTwo)
            } else {
                return (.Invites, .ActivityTitlePageTwo, .ActivityFeedPageTwo)
            }
        }
    }
}