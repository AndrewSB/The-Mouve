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
    case Scene = "Scene"
}

class SceneTitleView: UIView {
    @IBOutlet weak var exploreButton: UIButton!
    @IBOutlet weak var theSceneButton: UIButton!
    @IBOutlet weak var underlineView: UIView!
    
    var view: UIView!
    
    @IBInspectable var typeAsString: String? {
        didSet {
            type = SceneType(rawValue: typeAsString!)
        }
    }
    
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
    
    convenience init(type: SceneType, superVC: String, frame: CGRect) { //init from code
        self.init()
        
        self.frame = frame
        self.superVC = superVC
        self.type = type
        
        LocalMessage.observe(.HomeFeedPageOne, classFunction: "pageOne", inClass: self)
        LocalMessage.observe(.HomeFeedPageTwo, classFunction: "pageTwo", inClass: self)
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        xibSetup()
    }
    
    required init(coder aDecoder: NSCoder) { //init from storyboard
        println(view)
        
        super.init(coder: aDecoder)
        xibSetup()
    }
    
    func xibSetup() {
        self.view = loadViewFromNib("SceneTitleView")
        
        view.frame = bounds
        view.autoresizingMask = .FlexibleWidth | .FlexibleHeight
        
        addSubview(view)

        println("called xib setup \(superVC)")

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