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
            var userDefaults = NSUserDefaults()
            if let longitude = userDefaults.objectForKey("lng") as? Double {
                if let latitude = userDefaults.objectForKey("lat") as? Double {
                
                    let homeRegion = CLCircularRegion(center: CLLocationCoordinate2D(latitude: latitude, longitude: longitude), radius: 30, identifier: "Home")
                    manager.startMonitoringForRegion(homeRegion)
                }
            }
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
            var userDefaults = NSUserDefaults()
            if let longitude = userDefaults.objectForKey("lng") as? Double {
                if let latitude = userDefaults.objectForKey("lat") as? Double {
                    
                    let homeRegion = CLCircularRegion(center: CLLocationCoordinate2D(latitude: latitude, longitude: longitude), radius: 30, identifier: "Home")
                    manager.startMonitoringForRegion(homeRegion)
                }
            }
        }
        return true
    }
    
    func stopLocationServices() {
        manager.stopUpdatingLocation()
        var userDefaults = NSUserDefaults()
        if let longitude = userDefaults.objectForKey("lng") as? Double {
            if let latitude = userDefaults.objectForKey("lat") as? Double {
                
                let homeRegion = CLCircularRegion(center: CLLocationCoordinate2D(latitude: latitude, longitude: longitude), radius: 30, identifier: "Home")
                manager.stopMonitoringForRegion(homeRegion)
            }
        }
    }
    
    func stopBackgroundLocationServices() {
        manager.stopMonitoringSignificantLocationChanges()
        var userDefaults = NSUserDefaults()
        if let longitude = userDefaults.objectForKey("lng") as? Double {
            if let latitude = userDefaults.objectForKey("lat") as? Double {
                
                let homeRegion = CLCircularRegion(center: CLLocationCoordinate2D(latitude: latitude, longitude: longitude), radius: 30, identifier: "Home")
                manager.stopMonitoringForRegion(homeRegion)
            }
        }
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
    
    func locationManager(manager: CLLocationManager!, didEnterRegion region: CLRegion!) {
        NSLog("Entering region")
        var user = DBFactory.execute().getUser()
        user.setHome(true)
        user.setEnergy(FULLENERGY)
        DBFactory.execute().saveUser(user)
    }
    
    func locationManager(manager: CLLocationManager!, didExitRegion region: CLRegion!) {
        NSLog("Exit region")
        var user = DBFactory.execute().getUser()
        user.setHome(false)
        DBFactory.execute().saveUser(user)
    }
}