//
//  LoginViewController.swift
//  The Mouve
//
//  Created by Andrew Breckenridge on 5/4/15.
//  Copyright (c) 2015 Andrew Breckenridge. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    @IBOutlet weak var emailTextField: UnderlinedTextField!
    @IBOutlet weak var passwordTextField: UnderlinedTextField!

    @IBOutlet weak var loginButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
                
        loginButton.layer.borderWidth = 2
        loginButton.layer.borderColor = UIColor.seaFoamGreen().CGColor
        loginButton.layer.cornerRadius = 4
    }


    @IBAction func loginButtonWasHit(sender: AnyObject) {
    }
    
    @IBAction func signUpButtonWasHit(sender: AnyObject) {
    }
    
    @IBAction func backButtonWasHit(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
