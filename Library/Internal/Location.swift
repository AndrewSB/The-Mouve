////
////  Location.swift
////  The Mouve
////
////  Created by Andrew Breckenridge on 6/18/15.
////  Copyright (c) 2015 Andrew Breckenridge. All rights reserved.
////
//
import UIKit
import CoreLocation

class Location: CLLocationManager, CLLocationManagerDelegate {
    var mostRecentLocation: CLLocation? {
        didSet {
            UserDefaults.lastLocation = mostRecentLocation
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
            print("you can't see me", terminator: "")
        }
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.mostRecentLocation = (locations.last as CLLocation?)!
    }
}
//import CoreLocation
//
//class ViewController: UIViewController, CLLocationManagerDelegate {
//    
//    let locationManager = CLLocationManager()
//    var LatitudeGPS = NSString()
//    var LongitudeGPS = NSString()
//        var mostRecentLocation: CLLocation? {
//            didSet {
//                UserDefaults.lastLocation = mostRecentLocation
//                LocalMessage.post(.NewLocationRegistered)
//            }
//        }
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        // Do any additional setup after loading the view, typically from a nib.
//        self.updateLocation()
//    }
//        func updateLocation() {
//            self.locationManager.delegate = self
//            self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
//            //self.locationManager.distanceFilter = 10
//            self.locationManager.requestWhenInUseAuthorization()
//            self.locationManager.startUpdatingLocation()
//        }
//        
//        func locationManager(manager: CLLocationManager, didUpdateLocations locations: [AnyObject]) {
//            
//            locationManager.stopUpdatingLocation() // Stop Location Manager - keep here to run just once
//            
//            LatitudeGPS = String(format: "%.6f", manager.location!.coordinate.latitude)
//            LongitudeGPS = String(format: "%.6f", manager.location!.coordinate.longitude)
//            print("Latitude - \(LatitudeGPS)")
//            
//}