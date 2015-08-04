//
//  HomeTabBarController.swift
//  The Mouve
//
//  Created by Andrew Breckenridge on 8/3/15.
//  Copyright (c) 2015 Andrew Breckenridge. All rights reserved.
//

import UIKit

class HomeTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        viewControllers = [
            UIStoryboard.initialIn(.TheScene),
            UIStoryboard.initialIn(.Activity),
            UIStoryboard.initialIn(.Profile),
            UIStoryboard.initialIn(.Settings)
        ]
    }

}
