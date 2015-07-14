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
    @IBOutlet weak var signupButton: UIButton!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        statusBar(.Default)
        addTextDismiss()
        addNavControllerLikePan()
        
        IQKeyboardManager.sharedManager().keyboardDistanceFromTextField = ((signupButton.frame.origin.y + signupButton.frame.height) - emailTextField.frame.origin.y) + 5
        
        [emailTextField, passwordTextField].map({ $0.delegate = self })
    }
    
    @IBAction func loginButtonWasHit(sender: AnyObject) {
        view.userInteractionEnabled = false
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
                            loadingSpinnerView.removeFromSuperview()
                            self.view.userInteractionEnabled = true
                            
                            let errorString = error.userInfo?["error"] as? NSString
                            self.presentViewController(UIAlertController(title: "Uh oh!", message: errorString as! String), animated: true, completion: nil)
                        }
                    }
                })
            } else {
                if let error = error {
                    loadingSpinnerView.removeFromSuperview()
                    self.view.userInteractionEnabled = true
                    
                    self.presentViewController(UIAlertController(title: "Uh oh", message: error.localizedDescription), animated: true, completion: nil)
                }
            }
        })
    }
    
    @IBAction func signUpButtonWasHit(sender: AnyObject) {
        let signUpVC = self.initVC("signUpVC", storyboard: "Login") as! SignupViewController
        
        var navigationStack = self.navigationController!.viewControllers
        navigationStack.removeLast()
        navigationStack.append(signUpVC)
        self.navigationController!.setViewControllers(navigationStack, animated: true)
    }
    
    @IBAction func backButtonWasHit(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    
    // MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        view.endEditing(true)
    }
}

extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        switch textField {
        case emailTextField:
            emailTextField.resignFirstResponder()
            passwordTextField.becomeFirstResponder()
        case passwordTextField:
            passwordTextField.resignFirstResponder()
            loginButtonWasHit(self)
        default: ()
        }
        
        return true
    }
}