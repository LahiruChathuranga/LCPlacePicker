//
//  LocationManager.swift
//  EMPlacePicker
//
//  Created by Lahiru Chathuranga on 5/21/19.
//  Copyright © 2019 ElegantMedia. All rights reserved.
//

import Foundation
import GoogleMaps
import GooglePlaces


open class LocationManager: NSObject, CLLocationManagerDelegate {
    
    static let shared = LocationManager()
    private var manager: CLLocationManager!
    var userLocation: CLLocation?
    
     open override init() {
        super.init()
        manager = CLLocationManager()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
    }
    
    public func determineCurrentLocation() {
        if CLLocationManager.locationServicesEnabled() {
            manager.startUpdatingLocation()
        }
    }
    
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let _userLocation: CLLocation = locations[0] as CLLocation
        // Call stopUpdatingLocation() to stop listening for location updates,
        // other wise this function will be called every time when user location changes.
        userLocation = (_userLocation)
        manager.stopUpdatingLocation()
    }
    
    public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        //
    }
}


