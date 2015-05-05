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
        let loadingSpinnerView = addLoadingView()
        view.addSubview(loadingSpinnerView)
        
        let emailQuery = PFQuery(className: "_User")
        emailQuery.whereKey("email", equalTo: emailTextField.text.lowercaseString)
        
        emailQuery.getFirstObjectInBackgroundWithBlock({ (object, error) in
            if let object = object {
                PFUser.logInWithUsernameInBackground(object["username"] as! String, password: self.passwordTextField.text, block: { (user, error) in
                    if user != nil {
                        println("dun logged in")
                        appDel.checkLogin()
                    } else {
                        if let error = error {
                            self.removeLoadingView(loadingSpinnerView)
                            let errorString = error.userInfo?["error"] as? NSString
                            self.presentViewController(UIAlertController(title: "Uh oh!", message: errorString as! String), animated: true, completion: nil)
                        }
                    }
                })
            } else {
                if let error = error {
                    self.removeLoadingView(loadingSpinnerView)
                    self.presentViewController(UIAlertController(title: "Uh oh", message: error.localizedDescription), animated: true, completion: nil)
                }
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
