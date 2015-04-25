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
        
        xibSetup()
    }
    
    func xibSetup() {
        self.view = loadViewFromNib("SceneTitleView")
        
        view.frame = bounds
        view.autoresizingMask = .FlexibleWidth | .FlexibleHeight
        
        addSubview(view)
        
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "pageOne", name: "\(superVC)DidGoToPageOne", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "pageTwo", name: "\(superVC)DidGoToPageTwo", object: nil)
    }
    
    func pageOne() {
        type = .Explore
    }
    
    func pageTwo() {
        type = .Scene
    }

    
    @IBAction func exploreButtonWasHit(sender: AnyObject) {
        if type != .Explore {
            NSNotificationCenter.defaultCenter().postNotificationName("TitleDidClickPageOne", object: self)
        }
        pageOne()
    }

    @IBAction func theSceneButtonWasHit(sender: AnyObject) {
        if type != .Scene {
            NSNotificationCenter.defaultCenter().postNotificationName("TitleDidClickPageTwo", object: self)
        }
        pageTwo()
    }
}