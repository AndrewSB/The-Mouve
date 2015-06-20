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
        
    var pageImage: UIImage = UIImage()
    var pageIndex: Int = Int()
    
    var backgroundImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
 
        println("didload")
        pageLabel.text = title
        pageLabelWidthConstraint.constant = self.view.frame.width - 88
        
        backgroundImageView = UIImageView(image: pageImage)
        backgroundImageView.contentMode = .ScaleAspectFill
        backgroundImageView.frame.size = view.frame.size
        
        self.view.insertSubview(backgroundImageView, atIndex: 0)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        println("didappear")
//        backgroundImageView.frame.size = view.frame.size
//        
//        self.view.insertSubview(backgroundImageView, atIndex: 0)
    }
    
    @IBAction func unwindToTutorialVC(segue: UIStoryboardSegue) {}
}
