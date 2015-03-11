//
//  LocationController.swift
//  Lootz
//
//  Created by Brayden Girard on 2015-02-10.
//  Copyright (c) 2015 Brayden Girard. All rights reserved.
//

import Foundation

class LocationController: NSObject, CLLocationManagerDelegate{
    
    class var sharedInstance : LocationController {
        struct Static {
            static let instance : LocationController = LocationController()
        }
        return Static.instance
    }
    
    let manager = CLLocationManager()
    var currentLocation: CLLocation?
    var backgroundState = false
    
    func startLocationServices() -> Bool {
        manager.delegate = self;
        manager.desiredAccuracy = kCLLocationAccuracyBest
        backgroundState = false;
        
        switch CLLocationManager.authorizationStatus() {
        case .NotDetermined:
            manager.requestAlwaysAuthorization()
        case .AuthorizedWhenInUse, .Restricted, .Denied:
            return false
        default:
            manager.startUpdatingLocation()
        }
        return true
    }
    
    func startBackgroundLocationServices() -> Bool {
       
        manager.delegate = self;
        manager.desiredAccuracy = kCLLocationAccuracyBest
        backgroundState = true;
        
        switch CLLocationManager.authorizationStatus() {
        case .NotDetermined:
            manager.requestAlwaysAuthorization()
        case .AuthorizedWhenInUse, .Restricted, .Denied:
            return false
        default:
            manager.startMonitoringSignificantLocationChanges()
             println("Background location started")
        }
        return true
    }
    
    func stopLocationServices() {
        manager.stopUpdatingLocation()
    }
    
    func stopBackgroundLocationServices() {
        manager.stopMonitoringSignificantLocationChanges()
    }
    
    func getCurrentLocation() -> CLLocation? {
        return currentLocation
    }
    
    //Location manager was authorized start monitoring locations
    func locationManager(manager: CLLocationManager!, didChangeAuthorizationStatus status:CLAuthorizationStatus)
    {
        if status == CLAuthorizationStatus.AuthorizedAlways {
            manager.startUpdatingLocation()
        }
    }
    
    //Location was updated get newest location
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        self.currentLocation = locations[locations.count - 1] as? CLLocation
        //println("Location has been updated")
        if(backgroundState && currentLocation != nil) {
            println("Found location in background")
            if let theLocation = currentLocation {
                DBFactory.execute().saveUserLocation(theLocation)
            }
        }
    }
}