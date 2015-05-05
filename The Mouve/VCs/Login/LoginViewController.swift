//
//  LoginViewController.swift
//  The Mouve
//
//  Created by Andrew Breckenridge on 5/4/15.
//  Copyright (c) 2015 Andrew Breckenridge. All rights reserved.
//

import UIKit
import Parse

class LoginViewController: UIViewController {
    @IBOutlet weak var emailTextField: UnderlinedTextField!
    @IBOutlet weak var passwordTextField: UnderlinedTextField!

    @IBOutlet weak var loginButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        addTextDismiss()
                
        loginButton.layer.borderWidth = 2
        loginButton.layer.borderColor = UIColor.seaFoamGreen().CGColor
        loginButton.layer.cornerRadius = 4
    }


    @IBAction func loginButtonWasHit(sender: AnyObject) {
        PFUser.logInWithUsernameInBackground(emailTextField.text.lowercaseString, password: passwordTextField.text, block: { (user: PFUser?, error: NSError?) -> Void in
            if user != nil {
                // Do stuff after successful login.
            } else {
                if let error = error {
                    let errorString = error.userInfo?["error"] as? NSString
                    self.presentViewController(UIAlertController(title: "Uh oh!", message: errorString as! String), animated: true, completion: nil)
                }
                assert(true == false, "yo some login error ???")
            }
        })
    }
    
    @IBAction func signUpButtonWasHit(sender: AnyObject) {
    }
    
    @IBAction func backButtonWasHit(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    
    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        view.endEditing(true)
    }

}
