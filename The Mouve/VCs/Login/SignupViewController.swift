//
//  SignupViewController.swift
//  The Mouve
//
//  Created by Andrew Breckenridge on 5/4/15.
//  Copyright (c) 2015 Andrew Breckenridge. All rights reserved.
//

import UIKit
import Parse

class SignupViewController: UIViewController {
    @IBOutlet weak var nameTextField: UnderlinedTextField!
    @IBOutlet weak var usernameTextField: UnderlinedTextField!
    @IBOutlet weak var passwordTextField: UnderlinedTextField!
    @IBOutlet weak var emailTextField: UnderlinedTextField!

    @IBOutlet weak var createAccountButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addTextDismiss()

        createAccountButton.layer.borderColor = UIColor.seaFoamGreen().CGColor
        createAccountButton.layer.borderWidth = 2
        createAccountButton.layer.cornerRadius = 6
    }

    @IBAction func createAccountButtonWasHit(sender: AnyObject) {
        let newUser = PFUser()
        
        newUser["name"] = nameTextField.text
        newUser.username = usernameTextField.text.lowercaseString
        newUser.password = passwordTextField.text.lowercaseString
        newUser.email = emailTextField.text.lowercaseString
        
        newUser.signUpInBackgroundWithBlock { (succeeded: Bool, error: NSError?) -> Void in
            if let error = error {
                let errorString = error.userInfo?["error"] as? NSString
                self.presentViewController(UIAlertController(title: "Uh oh!", message: errorString as! String), animated: true, completion: nil)
            } else {
                println("you done signed up")
            }
        }

    }
    
    @IBAction func facebookButtonWasHit(sender: AnyObject) {
    }
    
    @IBAction func backButtonWasHit(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    
    // MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        view.endEditing(true)
    }

}
