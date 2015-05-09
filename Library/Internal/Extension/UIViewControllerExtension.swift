//
//  UIViewControllerExtension.swift
//  The Mouve
//
//  Created by Andrew Breckenridge on 4/25/15.
//  Copyright (c) 2015 Andrew Breckenridge. All rights reserved.
//

import UIKit

extension UIViewController {
    func initVC(vcID: String, storyboard: String) -> UIViewController {
        return UIStoryboard(name: storyboard, bundle: nil).instantiateViewControllerWithIdentifier(vcID) as! UIViewController
    }
}

extension UIViewController { // Remote Loading heloer
    func addLoadingView() -> UIActivityIndicatorView {
        view.userInteractionEnabled = false
        
        let aV = UIActivityIndicatorView(frame: CGRectMake(view.frame.width/2 - 11, view.frame.height/2 - 11, 11, 11))
        aV.startAnimating()
        aV.color = UIColor.grayColor()
        
        return aV
    }
    
    func addSpinnerAndStall() -> UIActivityIndicatorView {
        let spinner = addLoadingView()
        self.view.addSubview(spinner)
        
        self.view.userInteractionEnabled = false
        
        return spinner
    }
    
    func bringAliveAndRemove(spinner: UIActivityIndicatorView) {
        spinner.removeFromSuperview()
        self.view.userInteractionEnabled = true
    }
}

extension UIViewController { // Keyboard
    func addTextDismiss() {
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "hideKeyboard:"))
    }
    
    func registerForKeyboard() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWasShown:", name: UIKeyboardWillShowNotification, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillBeHidden:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func deregisterForKeyboard() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardDidShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func hideKeyboard(sender: AnyObject) {
        view.endEditing(true)
    }
    
    func keyboardWasShown(id: AnyObject) {
        println("shown")
    }
    
    func keyboardWillBeHidden(id: AnyObject) {
        println("will hide")
    }
}