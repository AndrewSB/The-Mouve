//
//  TutorialViewController.swift
//  The Mouve
//
//  Created by Andrew Breckenridge on 4/1/15.
//  Copyright (c) 2015 Andrew Breckenridge. All rights reserved.
//

import UIKit

class TutorialViewController: UIViewController {
    @IBOutlet weak var pageLabel: UILabel!
    
    @IBOutlet weak var loginSignupScrollView: UIScrollView!
    @IBOutlet weak var loginSignupConstraint: NSLayoutConstraint!
    
    
    var pageImage: UIImage = UIImage()
    var pageIndex: Int = Int()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loginSignupConstraint.constant = view.frame.height
        loginSignupScrollView.contentSize.width = self.view.frame.width
        
        let imageSize = CGSize(width: self.view.bounds.width, height: self.view.bounds.height + 50)
        
        let backgroundImage = UIImageView(frame: CGRect(origin: CGPoint(x: 15, y: 0), size: imageSize))
        backgroundImage.image = pageImage
        backgroundImage.contentMode = .ScaleAspectFill
        
        self.view.insertSubview(backgroundImage, atIndex: 0)
        
        pageLabel.text = title
        
        switch pageIndex {
        case 2:
//            loginButton.hidden = false
            pageLabel.hidden = true
        default:
//            loginButton.hidden = true
            pageLabel.hidden = false
        }
    }
}
