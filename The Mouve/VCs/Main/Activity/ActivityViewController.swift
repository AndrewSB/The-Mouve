//
//  ActivityViewController.swift
//  The Mouve
//
//  Created by Andrew Breckenridge on 4/26/15.
//  Copyright (c) 2015 Andrew Breckenridge. All rights reserved.
//

import UIKit

class ActivityViewController: UIViewController {
    @IBOutlet weak var activityView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        activityView.addSubview(SceneTitleView(type: .Newsfeed, frame: CGRect(origin: .zero, size: CGSize(width: activityView.frame.width, height: activityView.frame.height))))
    }
}
