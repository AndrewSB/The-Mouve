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
    
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    
    var pageImage: UIImage = UIImage()
    var pageIndex: Int = Int()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        super.viewDidAppear(false)
        
        let imageSize = CGSize(width: self.view.bounds.width, height: self.view.bounds.height + 50)
        
        let backgroundImage = UIImageView(frame: CGRect(origin: CGPoint(x: 15, y: 0), size: imageSize))
        backgroundImage.image = pageImage
        backgroundImage.contentMode = .ScaleAspectFill
        
        self.view.insertSubview(backgroundImage, atIndex: 0)
        
        pageLabel.text = title
        
        signUpButton.layer.cornerRadius = 6
        loginButton.layer.cornerRadius = 6
        loginButton.layer.borderColor = UIColor.seaFoamGreen().CGColor
        loginButton.layer.borderWidth = 1
        
        self.automaticallyAdjustsScrollViewInsets = false
    }

    
    @IBAction func signUpButtonWasHit(sender: AnyObject) {
    }
    
    @IBAction func loginButtonWasHit(sender: AnyObject) {
    }
    
    @IBAction func unwindToTutorialVC(segue: UIStoryboardSegue) {}
}
