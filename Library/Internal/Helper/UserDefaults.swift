//
//  NSUserDefaultHelper.swift
//  The Mouve
//
//  Created by Andrew Breckenridge on 4/25/15.
//  Copyright (c) 2015 Andrew Breckenridge. All rights reserved.
//

import Foundation
import CoreLocation

class UserDefaults {
    static let get = NSUserDefaults.standardUserDefaults().objectForKey
    static let set = NSUserDefaults.standardUserDefaults().setObject
    
    enum UserDefaultKey {
        case Default(DefaultRecords.DefaultKey)
        case User(UserRecords.UserKey)
    }
    
    class func keyFor(defaultKey: UserDefaultKey) -> String {
        switch defaultKey {
        case .Default(let key):
            return "Default\(key.rawValue)"
        case .User(let key):
            return "User\(key.rawValue)"
        }
    }
}