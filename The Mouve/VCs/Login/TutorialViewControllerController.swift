//
//  TutorialViewControllerController.swift
//  The Mouve
//
//  Created by Andrew Breckenridge on 5/6/15.
//  Copyright (c) 2015 Andrew Breckenridge. All rights reserved.
//

import UIKit
import Parse

class TutorialViewControllerController: UIViewController {
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        signUpButton.layer.cornerRadius = 6
        loginButton.layer.cornerRadius = 6
        loginButton.layer.borderColor = UIColor.seaFoamGreen().CGColor
        loginButton.layer.borderWidth = 1
    }
    
    
    @IBAction func signUpButtonWasHit(sender: AnyObject) {
        performSegueWithIdentifier("segueToLogin", sender: self)
    }
    
    @IBAction func loginButtonWasHit(sender: AnyObject) {
        performSegueWithIdentifier("segueToSignup", sender: self)   
    }
    
    @IBAction func tryWithoutAnAccountWasHit(sender: AnyObject) {
        PFAnonymousUtils.logInWithBlock {
            (user: PFUser?, error: NSError?) -> Void in
            if error != nil || user == nil {
                println("Anonymous login failed.")
            } else {
                appDel.checkLogin()
                println("Anonymous user logged in.")
            }
        }
        
    }
}
