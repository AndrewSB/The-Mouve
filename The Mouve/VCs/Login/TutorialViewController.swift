//
//  TutorialViewController.swift
//  The Mouve
//
//  Created by Andrew Breckenridge on 4/1/15.
//  Copyright (c) 2015 Andrew Breckenridge. All rights reserved.
//

import UIKit
import Parse

class TutorialViewController: UIViewController {
    @IBOutlet weak var pageLabel: UILabel!
    @IBOutlet weak var pageLabelWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var backgroundImageView: UIImageView!
        
    var pageImage: UIImage = UIImage()
    var pageIndex: Int = Int()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
 
        print("didload")
        pageLabel.text = title
        pageLabelWidthConstraint.constant = self.view.frame.width - 88
        
        backgroundImageView.image = pageImage
        backgroundImageView.center = view.center
        backgroundImageView.frame.size = CGSize(width: view.frame.width, height: view.frame.height)
    }
    
    @IBAction func unwindToTutorialVC(segue: UIStoryboardSegue) {}
}
