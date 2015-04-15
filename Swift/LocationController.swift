//  Location management singleton

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
    
    //  Starts location services
    //  Starts monitoring for location updates
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
            manager.startMonitoringVisits()
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
    
    //  Starts background location services
    //  Starts monitoring for significant location changes
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
            manager.startMonitoringVisits()
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
    
    //  Stops location services
    //  Stops monitoring standard location services
    func stopLocationServices() {
        manager.stopUpdatingLocation()
        manager.stopMonitoringVisits()
        var userDefaults = NSUserDefaults()
        if let longitude = userDefaults.objectForKey("lng") as? Double {
            if let latitude = userDefaults.objectForKey("lat") as? Double {
                
                let homeRegion = CLCircularRegion(center: CLLocationCoordinate2D(latitude: latitude, longitude: longitude), radius: 30, identifier: "Home")
                manager.stopMonitoringForRegion(homeRegion)
            }
        }
    }
    
    //  Stops background location services
    //  Stops monitoring for significant location changes
    func stopBackgroundLocationServices() {
        manager.stopMonitoringSignificantLocationChanges()
        manager.stopMonitoringVisits()
        var userDefaults = NSUserDefaults()
        if let longitude = userDefaults.objectForKey("lng") as? Double {
            if let latitude = userDefaults.objectForKey("lat") as? Double {
                
                let homeRegion = CLCircularRegion(center: CLLocationCoordinate2D(latitude: latitude, longitude: longitude), radius: 30, identifier: "Home")
                manager.stopMonitoringForRegion(homeRegion)
            }
        }
    }
    
    //  Gets the users current location
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
    
    //  There was a location updated, get newest location
    //  If in background, save the location
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        self.currentLocation = locations[locations.count - 1] as? CLLocation
        //println("Location has been updated")
        if(backgroundState && currentLocation != nil) {
            if let theLocation = currentLocation {
                DBFactory.execute().saveUserLocation(theLocation)
            }
        }
    }
    
    //  Monitors for entering the home region
    func locationManager(manager: CLLocationManager!, didEnterRegion region: CLRegion!) {
        DBFactory.execute().updateHome(true)
    }
    
    //  Monitors for exiting the home region
    func locationManager(manager: CLLocationManager!, didExitRegion region: CLRegion!) {
        DBFactory.execute().updateHome(false)
    }
    
    //  Monitors for a visit event
    func locationManager(manager: CLLocationManager!, didVisit visit: CLVisit!) {
        
        if visit.departureDate.isEqualToDate(NSDate.distantFuture() as NSDate) {
            DBFactory.execute().regenerateEnergy()
        } else {
            println("Left location")
        }
        
    }
}