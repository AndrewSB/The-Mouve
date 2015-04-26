//
//  SceneTitleView.swift
//  The Mouve
//
//  Created by Andrew Breckenridge on 4/24/15.
//  Copyright (c) 2015 Andrew Breckenridge. All rights reserved.
//

import UIKit

class SceneTitleView: UIView {
    @IBOutlet weak var exploreButton: UIButton!
    @IBOutlet weak var theSceneButton: UIButton!
    @IBOutlet weak var underlineView: UIView!
    
    var view: UIView!
    
    @IBInspectable var type: SceneType? {
        didSet {
            if type != oldValue {
                UIView.animateWithDuration(0.2, animations: {
                    let animateToButton = self.type == .Explore ? self.exploreButton : self.theSceneButton
                    let origin = CGPoint(x: animateToButton.frame.origin.x, y: animateToButton.frame.origin.y + animateToButton.frame.height - 4)
                    self.underlineView.frame = CGRect(origin: origin, size: CGSize(width: animateToButton.frame.width, height: 2))
                })
            }
        }
    }
    
    @IBInspectable var superVC: String?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        xibSetup()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        xibSetup()
    }
    
    convenience init(type: SceneType, superVC: String, frame: CGRect) {
        self.init()
        
        self.frame = frame
        self.superVC = superVC
        self.type = type
                
        LocalMessage.observe(.HomeFeedPageOne, classFunction: "pageOne", inClass: self)
        LocalMessage.observe(.HomeFeedPageTwo, classFunction: "pageTwo", inClass: self)
    }
    
    func xibSetup() {
        println("called xib setup")
        self.view = loadViewFromNib("SceneTitleView")
        
        view.frame = bounds
        view.autoresizingMask = .FlexibleWidth | .FlexibleHeight
        
        addSubview(view)
        //        LocalMessage.observe(.HomeFeedPageTwo, classFunction: pageTwo(), inClass: self)
    }
    
    override func didAddSubview(subview: UIView) {
        println("didAddSubview")
    }
    
    override func willRemoveSubview(subview: UIView) {
        println("willRemoveSubview")
    }
    
    override func didMoveToWindow() {
        println("didMoveToWindow")
    }
    
    override func willMoveToWindow(newWindow: UIWindow?) {
        println("didMoveToWindow")
    }
        
    func pageOne() {println("did pageone");type = .Explore}
    func pageTwo() {println("did pagetwo");type = .Scene}

    
    @IBAction func exploreButtonWasHit(sender: AnyObject) {
        
        if type != .Explore {
            LocalMessage.post(.TitleHitPageOne)
            type = .Explore
        }
    }

    @IBAction func theSceneButtonWasHit(sender: AnyObject) {
        
        if type != .Scene {
            LocalMessage.post(.TitleHitPageTwo)
            type = .Scene
        }
    }
}