//
//  Parse.swift
//  Lootz
//
//  Created by Brayden Girard on 2014-12-08.
//  Copyright (c) 2014 Brayden Girard. All rights reserved.
//

import Foundation

class ParseImpl: DatabaseManager {
    
    func signUp(user: User) {
       
        var parseUser = PFUser()
        
        parseUser.username = user.getUsername()
        parseUser.email = user.getEmail()
        parseUser["health"] = user.getHealth()
        parseUser["energy"] = user.getEnergy()
        parseUser["clarity"] = user.getClarity()
        parseUser["inventory"] = user.getInventory()
        parseUser["equipment"] = user.getEquipment()
        parseUser["latHistory"] = user.getLatHistory()
        parseUser["lngHistory"] = user.getLngHistory()
        parseUser["gold"] = user.getGold()
        
        parseUser.signUpInBackgroundWithBlock {
            (succeeded: Bool!, error: NSError!) -> Void in
            if error == nil {
                NSNotificationCenter.defaultCenter().postNotificationName("signUpSuccess", object: nil)
            } else {
                let errorString = error.userInfo!["error"] as NSString
                println(errorString)
                
                NSNotificationCenter.defaultCenter().postNotificationName("signUpFail", object: nil)
            }
        }
    }
    
    func login(username: String, password: String) {
        PFUser.logInWithUsernameInBackground(username, password:password) {
            (user: PFUser!, error: NSError!) -> Void in
            if user != nil {
                NSNotificationCenter.defaultCenter().postNotificationName("loginSuccess", object: nil)
            } else {
                let errorString = error.userInfo!["error"] as NSString
                println(errorString)
                
                NSNotificationCenter.defaultCenter().postNotificationName("loginFail", object: nil)
            }
        }
    }
    
    func checkAutoSignIn() -> Bool {
        var currentUser = PFUser.currentUser()
        if currentUser != nil {
            return true
        } else {
            return false
        }
    }
    
    func getUser() -> User {
        var currentUser = PFUser.currentUser()
        if currentUser != nil {
            var user = User(parseUser: currentUser)
            return user
        } else {
            NSNotificationCenter.defaultCenter().postNotificationName("exit", object: nil)
            var user = User()
            return user
        }
    }
    
    func getUserByUsername(username: String) -> User {
        var query = PFUser.query()
        query.whereKey("username", equalTo:username)
        return User(parseUser: query.getFirstObject())
    }

    func saveUser(user: User) -> Bool {
        var parseUser = PFUser.currentUser()
        if parseUser != nil {
            parseUser.username = user.getUsername()
            parseUser.email = user.getEmail()
            parseUser["health"] = user.getHealth()
            parseUser["energy"] = user.getEnergy()
            parseUser["clarity"] = user.getClarity()
            parseUser["inventory"] = user.getInventory()
            parseUser["equipment"] = user.getEquipment()
            parseUser["latHistory"] = user.getLatHistory()
            parseUser["lngHistory"] = user.getLngHistory()
            parseUser["gold"] = user.getGold()
            return true
        } else {
            NSNotificationCenter.defaultCenter().postNotificationName("exit", object: nil)
            return false
        }
    }
    
    func saveUserLocation(location: CLLocation) {
        var currentUser = PFUser.currentUser()
        if currentUser != nil {
            PFUser.currentUser().fetchInBackgroundWithBlock({ (object:PFObject!, error: NSError!) -> Void in
                NSNotificationCenter.defaultCenter().postNotificationName("refreshProfile", object: nil)
            })
        } else {
            NSNotificationCenter.defaultCenter().postNotificationName("exit", object: nil)
        }

        var lat = location.coordinate.latitude as Double
        var lng = location.coordinate.longitude as Double

        var locationHistory = self.getUser().getLocationHistory()
    
        locationHistory.latitudes.append(lat)
        locationHistory.longitudes.append(lng)
        
        currentUser["latHistory"] = locationHistory.latitudes
        currentUser["lngHistory"] = locationHistory.longitudes
        
        currentUser.saveEventually()
    }
    
    func updateUser() {
        var currentUser = PFUser.currentUser()
        if currentUser != nil {
            PFUser.currentUser().fetchInBackgroundWithBlock({ (object:PFObject!, error: NSError!) -> Void in
                NSNotificationCenter.defaultCenter().postNotificationName("refreshProfile", object: nil)
            })
        } else {
            NSNotificationCenter.defaultCenter().postNotificationName("exit", object: nil)
        }
    }
    
    func findChests(lat: Double, lng: Double, distance: Double) {
    
        let currentLocation = PFGeoPoint(latitude:lat, longitude:lng)
     
        var query = PFQuery(className:"Chest")

        query.whereKey("location", nearGeoPoint: currentLocation, withinKilometers: distance)
   
        query.limit = 10
   
        query.findObjectsInBackgroundWithBlock { (objects: Array!, error: NSError!) -> Void in
            var finalChests = [Chest]()
            
            if let chests = objects {
                for c in chests {
                    var chest = Chest(parseChest: c as PFObject)
                    finalChests.append(chest)
                }
            }
            NSNotificationCenter.defaultCenter().postNotificationName("chestSearchComplete", object: self, userInfo:["chests": finalChests])
        }
    }
}