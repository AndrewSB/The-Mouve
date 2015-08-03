//
//  DefaultModel.swift
//  The Mouve
//
//  Created by Andrew Breckenridge on 8/3/15.
//  Copyright (c) 2015 Andrew Breckenridge. All rights reserved.
//

import Foundation
import CoreLocation

class DefaultModel {
    static let sharedInstance = DefaultModel()
    private lazy var records = DefaultRecords.self
    let defaultErrorMessage = "Looking for network..."
    
    var lastLocation: CLLocation? {
        get {
            return records.lastLocation
        }
    }
}

internal class DefaultRecords: UserDefaults {
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