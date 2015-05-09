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
    func setupForEntry(view: UIView) {
        setupForEntry(view.frame.origin.y + view.frame.height - 224)
    }
    
    private func setupForEntry(offset: CGFloat) {
        UserDefaults.keyboardOffet = offset
        setupForEntry()
    }
    
    func setupForEntry() {
        addTextDismiss()
        registerForKeyboard()
    }
    
    func addTextDismiss() {
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "hideKeyboard:"))} func hideKeyboard(id: AnyObject) { view.endEditing(true)
    }
    
    func registerForKeyboard() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWasShown:", name: UIKeyboardWillShowNotification, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillBeHidden:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func deregisterForKeyboard() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardDidShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func keyboardWasShown(id: AnyObject) {
            UIView.animateWithDuration(0.2, animations: {
                self.view.frame.origin.y -= UserDefaults.keyboardOffet
            })
    }
    
    func keyboardWillBeHidden(id: AnyObject) {
            UIView.animateWithDuration(0.2, animations: {
                self.view.frame.origin.y = 0
            })
    }
}