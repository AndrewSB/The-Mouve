//
//  ViewController.swift
//  The Mouve
//
//  Created by Andrew Breckenridge on 3/4/15.
//  Copyright (c) 2015 Andrew Breckenridge. All rights reserved.
//

import UIKit
import TwitterKit


class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let logInButton = TWTRLogInButton(logInCompletion: {
            (session: TWTRSession!, error: NSError!) in
            self.updateWithAuth()
        })
        logInButton.center = CGPointMake(self.view.center.x, self.view.center.y + 44)
        self.view.addSubview(logInButton)

        
        
        let digitAuthButton = DGTAuthenticateButton(authenticationCompletion: {
            (session: DGTSession!, error: NSError!) in
            self.updateWithAuth()
        })
        digitAuthButton.center = self.view.center
        self.view.addSubview(digitAuthButton)
    }

    func updateWithAuth() {
        performSegueWithIdentifier("segueToMain", sender: self)
    }
    
    
}

