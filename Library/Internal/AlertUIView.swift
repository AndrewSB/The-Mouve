//
//  AlertUIView.swift
//  The Mouve
//
//  Created by Andrew Breckenridge on 5/9/15.
//  Copyright (c) 2015 Andrew Breckenridge. All rights reserved.
//

import UIKit

@IBDesignable class AlertUIView: UIView {
    var view: UIView!

    convenience init(frame: CGRect, title: String, message: String) { //init from code
        self.init(frame: frame)
        
        setupView()
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        xibSetup()
    }
    
    required init?(coder aDecoder: NSCoder) { //init from storyboard
        super.init(coder: aDecoder)
        
        xibSetup()
//        otherSetup()
    }
    
    func xibSetup() {
        self.view = loadViewFromNib("SceneTitleView")
        
        view.frame = bounds
        view.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        
        addSubview(view)

    }

    func setupView() {
        view.layer.cornerRadius = 6
    }
}
