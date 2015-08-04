//
//  UIStoryboardExtension.swift
//  The Mouve
//
//  Created by Andrew Breckenridge on 8/2/15.
//  Copyright (c) 2015 Andrew Breckenridge. All rights reserved.
//

import UIKit

extension UIStoryboard {
    
    enum Named: String {
        case Login = "Login"
        
        case TheScene = "Scene"
        case Activity = "Activity"
        case Profile = "Profile"
        case Settings = "Settings"
    }
    
    class func initialIn(storyboardEnum: Named) -> UIViewController {
        let storyboardName = storyboardEnum.rawValue
        return UIStoryboard.initialIn(storyboard: storyboardName)
    }
    
    class func initialIn(storyboard storyboardNamed: String) -> UIViewController {
        let storyboard = UIStoryboard(name: storyboardNamed, bundle: NSBundle.mainBundle())
        return storyboard.instantiateInitialViewController() as! UIViewController
    }
    
}