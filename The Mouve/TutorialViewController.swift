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
    @IBOutlet weak var loginButton: UIButton!
    
    
    
    var pageImage: UIImage = UIImage()
    var pageIndex: Int = Int()

    override func viewDidLoad() {
        super.viewDidLoad()
        backgroundImage.image = pageImage
        backgroundImage.frame = view.frame
        pageLabel.text = title
        
        switch pageIndex {
        case 3:
            loginButton.hidden = false
            pageLabel.hidden = true
        default:
            loginButton.hidden = true
            pageLabel.hidden = false
        }
    }
    
    
    @IBAction func loginButtonWasHit(sender: AnyObject) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        presentViewController(storyboard.instantiateInitialViewController() as UIViewController, animated: true, completion: nil)
    }
}
