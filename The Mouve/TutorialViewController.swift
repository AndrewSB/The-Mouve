//
//  TutorialViewController.swift
//  The Mouve
//
//  Created by Andrew Breckenridge on 4/1/15.
//  Copyright (c) 2015 Andrew Breckenridge. All rights reserved.
//

import UIKit

class TutorialViewController: UIViewController {
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var pageLabel: UILabel!
    
    
    
    var pageImage: UIImage = UIImage()
    var pageIndex: Int = Int()

    override func viewDidLoad() {
        super.viewDidLoad()
        println("dsaadsasd")
        
        backgroundImage.image = pageImage
        backgroundImage.frame = view.frame
        pageLabel.text = title
    }
}
