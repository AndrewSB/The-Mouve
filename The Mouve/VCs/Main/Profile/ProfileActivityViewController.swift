//
//  ActivityViewController.swift
//  The Mouve
//
//  Created by Sam Ojogbo on 6/06/15.
//  Copyright (c) 2015 Sam Ojogbo. All rights reserved.
//

import UIKit

class ProfileActivityViewController: UIViewController {
    @IBOutlet weak var activityView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        let backButton = UIBarButtonItem(title: "<", style: UIBarButtonItemStyle.Plain, target: self, action: nil)
        backButton.setTitleTextAttributes([NSFontAttributeName: UIFont(name: "Helvetica", size: 20)!], forState: UIControlState.Normal)
        navigationItem.backBarButtonItem = backButton
        activityView.addSubview(SceneTitleView(type: .Followers, frame: CGRect(origin: .zeroPoint, size: CGSize(width: activityView.frame.width, height: activityView.frame.height))))
    }
}
