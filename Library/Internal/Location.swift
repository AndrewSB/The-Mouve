//
//  Location.swift
//  The Mouve
//
//  Created by Andrew Breckenridge on 6/18/15.
//  Copyright (c) 2015 Andrew Breckenridge. All rights reserved.
//

import UIKit
import CoreLocation

class Location: CLLocationManager, CLLocationManagerDelegate {
    var mostRecentLocation: CLLocation? {
        didSet {
            LocalMessage.post(.NewLocationRegistered)
        }
    }
    
    override init() {
        super.init()
        self.delegate = self
        self.desiredAccuracy = kCLLocationAccuracyThreeKilometers
        
        mostRecentLocation = UserDefaults.lastLocation
        
        switch CLLocationManager.authorizationStatus() {
        case .AuthorizedWhenInUse, .AuthorizedAlways:
            self.startUpdatingLocation()
        case .Denied, .NotDetermined, .Restricted:
            self.requestWhenInUseAuthorization()
            print("you can't see me")
        }
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        self.mostRecentLocation = locations.last as? CLLocation
    }
}