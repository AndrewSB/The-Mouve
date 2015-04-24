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
    
    
    var view: UIView!
    var underlineView = UIView()
    
    var type: SceneType {
        didSet {
            UIView.animateWithDuration(0.5, animations: {
                let animateToButton = self.type == .Explore ? self.exploreButton : self.theSceneButton
                self.underlineView.frame = CGRect(origin: CGPoint(x: animateToButton.frame.origin.x, y: animateToButton.frame.origin.y + animateToButton.frame.height + 2), size: CGSize(width: animateToButton.frame.width, height: 2))
            })
        }
    }
    
    override init(frame: CGRect) {
//        setup(.Explore)
        super.init(frame: frame)
        xibSetup()
    }
    
    required init(coder aDecoder: NSCoder) {
//        setup(.Explore)
        super.init(coder: aDecoder)
        xibSetup()
    }
    
//    func setup(type: SceneType) {
//        self.type = type
//        underlineView.backgroundColor = UIColor.seaFoamGreen
//    }
    
    func xibSetup() {
        let nib = UINib(nibName: "SceneTitleView", bundle: NSBundle(forClass: self.dynamicType))
        self.view = nib.instantiateWithOwner(self, options: nil)[0] as! UIView
        
        view.frame = bounds
        view.autoresizingMask = .FlexibleWidth | .FlexibleHeight
        
        addSubview(view)
    }
}