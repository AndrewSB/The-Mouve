//
//  NSUserDefaultHelper.swift
//  The Mouve
//
//  Created by Andrew Breckenridge on 4/25/15.
//  Copyright (c) 2015 Andrew Breckenridge. All rights reserved.
//

import Foundation
import CoreLocation

enum UserDefaultKeys: String {
    case lastLocation = "lastLocation"
    case profilePictureURL = "profilePictureURL"
}

class UserDefaults {
    static let get = NSUserDefaults.standardUserDefaults().objectForKey
    static let set = NSUserDefaults.standardUserDefaults().setObject
    
    class var lastLocation: CLLocation? {
        get {
            let key = UserDefaultKeys.lastLocation.rawValue
            if let lat = get("\(key)-latitude") as? Double, lon = get("\(key)-longitude") as? Double {
                return CLLocation(latitude: lat, longitude: lon)
            } else {
                return nil
            }
        }
        set {
            let key = UserDefaultKeys.lastLocation.rawValue
            set(newValue!.coordinate.latitude, forKey: "\(key)-latitude")
            set(newValue!.coordinate.longitude, forKey: "\(key)-longitude")
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