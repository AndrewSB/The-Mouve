//
//  TheSceneNavigationItem.swift
//  The Mouve
//
//  Created by Andrew Breckenridge on 4/23/15.
//  Copyright (c) 2015 Andrew Breckenridge. All rights reserved.
//

import UIKit

class TheSceneNavigationItem: UINavigationItem {
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.titleView = SceneTitleView().instanceFromNib()
    
        self.titleView?.backgroundColor = UIColor.redColor()
    }
}

class SceneTitleView : UIView {
    @IBOutlet weak var exploreButton: UIButton!
    @IBOutlet weak var theSceneButton: UIButton!
    
    var view: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        xibSetup()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        xibSetup()
    }
    
    func xibSetup() {
        view = loadViewFromNib()
        
        // use bounds not frame or it'll be offset
        view.frame = bounds
        
        // Make the view stretch with containing view
        view.autoresizingMask = UIViewAutoresizing.FlexibleWidth | UIViewAutoresizing.FlexibleHeight
        
        // Adding custom subview on top of our view (over any custom drawing > see note below)
        addSubview(view)
    }
    
    func loadViewFromNib() -> UIView {
        let bundle = NSBundle(forClass: self.dynamicType)
        let nib = UINib(nibName: "CustomView", bundle: bundle)
        
        // Assumes UIView is top level and only object in CustomView.xib file
        let view = nib.instantiateWithOwner(self, options: nil)[0] as! UIView
        return view
    }

    
    @IBAction func exploreButtonWasHit(sender: AnyObject) {
        exploreButton.titleLabel?.text = "nla"
    }
    
    @IBAction func theSceneButtonWasHit(sender: AnyObject) {
        theSceneButton.titleLabel?.text = "da"
    }
    
}
