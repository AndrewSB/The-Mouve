//
//  SignupViewController.swift
//  The Mouve
//
//  Created by Andrew Breckenridge on 5/4/15.
//  Copyright (c) 2015 Andrew Breckenridge. All rights reserved.
//

import UIKit

class SignupViewController: UIViewController {
    @IBOutlet weak var nameTextField: UnderlinedTextField!
    @IBOutlet weak var usernameTextField: UnderlinedTextField!
    @IBOutlet weak var passwordTextField: UnderlinedTextField!
    @IBOutlet weak var emailTextField: UnderlinedTextField!

    @IBOutlet weak var createAccountButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        createAccountButton.layer.borderColor = UIColor.seaFoamGreen().CGColor
        createAccountButton.layer.borderWidth = 2
        createAccountButton.layer.cornerRadius = 6
    }

    @IBAction func createAccountButtonWasHit(sender: AnyObject) {
    }
    
    @IBAction func facebookButtonWasHit(sender: AnyObject) {
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
