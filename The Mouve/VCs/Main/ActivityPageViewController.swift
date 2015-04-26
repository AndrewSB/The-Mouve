//
//  ActivityPageViewController.swift
//  The Mouve
//
//  Created by Andrew Breckenridge on 4/25/15.
//  Copyright (c) 2015 Andrew Breckenridge. All rights reserved.
//

import UIKit

class ActivityPageViewController: UIPageViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        LocalMessage.observe(.ActivityTitlePageOne, classFunction: "pageOne", inClass: self)
        LocalMessage.observe(.ActivityTitlePageTwo, classFunction: "pageTwo", inClass: self)

    }
    
    func pageOne() {
        println("pageone")
    }

    func pageTwo() {
        println("pagetwo")
    }

}
