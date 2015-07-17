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
    
    let newUser = User()
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        statusBar(.Default)
        addTextDismiss()
        addNavControllerLikePan()
        
        IQKeyboardManager.sharedManager().keyboardDistanceFromTextField = ((createAccountButton.frame.origin.y + createAccountButton.frame.height) - nameTextField.frame.origin.y) + 5
        
        [nameTextField, usernameTextField, passwordTextField, emailTextField].map({ $0.delegate = self })
    }

    @IBAction func createAccountButtonWasHit(sender: AnyObject) {
//        newUser.username = usernameTextField.text.lowercaseString
//        newUser.password = passwordTextField.text.lowercaseString
//        newUser.email = emailTextField.text.lowercaseString
//        
        persistentData.sharedInstance.registerUser(
            nameTextField.text,
            username:usernameTextField.text,
            email: emailTextField.text,
            password: passwordTextField.text,
            authToken: "demo",
            image: "http://google.com/")

    }
    
    @IBAction func facebookButtonWasHit(sender: AnyObject) {
        let loginManager: Void = FBSDKLoginManager()
            .logInWithReadPermissions(["email", "user_friends", "public_profile"], handler: { (result, error) in
                if error != nil {
                    self.presentViewController(UIAlertController(title: "Whoops!", message: error!.localizedDescription), animated: true, completion: nil)
                } else if result.isCancelled {
                    self.presentViewController(UIAlertController(title: "Whoops!", message: "We couldn't access facebook! Did you hit cancel?"), animated: true, completion: nil)
                } else {
                    FBSDKGraphRequest(graphPath: "email", parameters: nil).startWithCompletionHandler({ (connection, result, error) in
                        if error != nil {
                            self.presentViewController(UIAlertController(title: "Whoops!", message: error!.localizedDescription), animated: true, completion: nil)
                        } else {
                            if let result = result as? String {
                                dispatch_async(dispatch_get_main_queue(), {
                                    self.emailTextField.text = result
                                    self.usernameTextField.text = result.substringToIndex(result.rangeOfString("@", options: nil, range: nil, locale: nil)!.startIndex)
                                })
                            }
                        }
                    })
                    self.nameTextField.text = FBSDKProfile.currentProfile().name
                    
                    persistentData.sharedInstance.fbRegister(self.usernameTextField.text, email: self.emailTextField.text, fbId: FBSDKAccessToken.currentAccessToken().userID, name: self.nameTextField.text)
                }
            })
    }
    
    @IBAction func backButtonWasHit(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    // MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        view.endEditing(true)
    }
//    func usernameSuggester(fullname: String){
//        var fullNameArr = split(fullname) {$0 == " "}
//        var firstName: String = fullNameArr[0]
//        var lastName: String? = fullNameArr.count > 1 ? fullNameArr[-1] : nil
//        let username = firstName+lastName!
//        return username.lowercaseString
//    }

}


extension SignupViewController: UITextFieldDelegate {
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        switch textField {
        case nameTextField:
            nameTextField.resignFirstResponder()
            usernameTextField.becomeFirstResponder()
        case usernameTextField:
            usernameTextField.resignFirstResponder()
            passwordTextField.becomeFirstResponder()
        case passwordTextField:
            passwordTextField.resignFirstResponder()
            emailTextField.becomeFirstResponder()
        case emailTextField:
            emailTextField.resignFirstResponder()
            createAccountButtonWasHit(self)
        default: ()
        }
        
        return true
    }
}