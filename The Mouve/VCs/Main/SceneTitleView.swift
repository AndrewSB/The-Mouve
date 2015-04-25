//
//  SceneTitleView.swift
//  The Mouve
//
//  Created by Andrew Breckenridge on 4/24/15.
//  Copyright (c) 2015 Andrew Breckenridge. All rights reserved.
//

import UIKit

@IBDesignable class SceneTitleView: UIView {
    @IBOutlet weak var exploreButton: UIButton!
    @IBOutlet weak var theSceneButton: UIButton!
    @IBOutlet weak var underlineView: UIView!
    
    var view: UIView!
    
    var type: SceneType {
        didSet {
            UIView.animateWithDuration(0.2, animations: {
                let animateToButton = self.type == .Explore ? self.exploreButton : self.theSceneButton
                let origin = CGPoint(x: animateToButton.frame.origin.x, y: animateToButton.frame.origin.y + animateToButton.frame.height - 4)
                self.underlineView.frame = CGRect(origin: origin, size: CGSize(width: animateToButton.frame.width, height: 2))
            })
        }
    }
    
    override init(frame: CGRect) {
        self.type = .Explore

        super.init(frame: frame)
        xibSetup()
    }
    
    required init(coder aDecoder: NSCoder) {
        self.type = .Explore
        
        super.init(coder: aDecoder)
        xibSetup()
    }
    
    func xibSetup() {
        self.view = loadViewFromNib("SceneTitleView")
        
        view.frame = bounds
        view.autoresizingMask = .FlexibleWidth | .FlexibleHeight
        
        addSubview(view)
    }
    
    @IBAction func exploreButtonWasHit(sender: AnyObject) {
        type = .Explore
    }

    @IBAction func theSceneButtonWasHit(sender: AnyObject) {
        type = .Scene
    }
}