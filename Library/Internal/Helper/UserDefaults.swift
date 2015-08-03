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

class DefaultRecords: UserDefaults {
    enum DefaultKey: String {
        case LastLocation = "lastLocation"
    }
    
    class var lastLocation: CLLocation? {
        get {
            let key = UserDefaults.keyFor(.Default(.LastLocation))
            if let lat = get("\(key)-latitude") as? Double, lon = get("\(key)-longitude") as? Double {
                return CLLocation(latitude: lat, longitude: lon)
            } else {
                return nil
            }
        }
        set {
            let key = UserDefaults.keyFor(.Default(.LastLocation))
            set(newValue!.coordinate.latitude, forKey: "\(key)-latitude")
            set(newValue!.coordinate.longitude, forKey: "\(key)-longitude")
        }
    }
}