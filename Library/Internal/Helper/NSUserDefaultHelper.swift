//
//  NSUserDefaultHelper.swift
//  The Mouve
//
//  Created by Andrew Breckenridge on 4/25/15.
//  Copyright (c) 2015 Andrew Breckenridge. All rights reserved.
//

import Foundation

enum UserDefaultKeys: String {
    case keyboardOffset = "keyboardOffset"
    case profilePictureURL = "profilePictureURL"
}

class UserDefaults {
    static let get = NSUserDefaults.standardUserDefaults().objectForKey
    static let set = NSUserDefaults.standardUserDefaults().setObject
    
    class var keyboardOffet: CGFloat {
        get {
            if let offset = get(UserDefaultKeys.keyboardOffset.rawValue) as? CGFloat {
                return offset
            } else { return 0 }
        }
        set {
            set(newValue, forKey: UserDefaultKeys.keyboardOffset.rawValue)
        }
    }
    
    class var profilePictureURL: String? {
        get {
            return get(UserDefaultKeys.profilePictureURL.rawValue) as? String
        }
        set {
            set(newValue, forKey: UserDefaultKeys.profilePictureURL.rawValue)
        }
    }
}