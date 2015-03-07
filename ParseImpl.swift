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
        parseUser.password = user.getPassword()
        parseUser.email = user.getEmail()
        parseUser["health"] = user.getHealth()
        parseUser["energy"] = user.getEnergy()
        parseUser["clarity"] = user.getClarity()
        parseUser["latHistory"] = user.getLatHistory()
        parseUser["lngHistory"] = user.getLngHistory()
        parseUser["gold"] = user.getGold()
        parseUser["loot"] = []
        parseUser["id"] = user.getId()
        
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
        if PFUser.currentUser() != nil {
           return self.getUserFromParse(PFUser.currentUser())
        } else {
            NSNotificationCenter.defaultCenter().postNotificationName("exit", object: nil)
            var user = User()
            return user
        }
    }
    
    func getUserByUsername(username: String) -> User {
        var query = PFUser.query()
        query.whereKey("username", equalTo:username)
        return self.getUserFromParse(query.getFirstObject())
    }
    
    //Check to see if the id in inventory loot matches
    //the id of the parse loot, if not remove the parse loot
    //from server and add the new loot
    func saveUser(user: User) -> Bool {
        if PFUser.currentUser() != nil {
            println("Inside save user")
            var parseLoot:PFObject?
            var parseLootArray = PFUser.currentUser()["loot"] as [PFObject]
            var newLoot = true
        
            PFUser.currentUser()["id"] = user.getId()
            PFUser.currentUser()["health"] = user.getHealth()
            PFUser.currentUser()["energy"] = user.getEnergy()
            PFUser.currentUser()["clarity"] = user.getClarity()
            PFUser.currentUser()["latHistory"] = user.getLatHistory()
            PFUser.currentUser()["lngHistory"] = user.getLngHistory()
            PFUser.currentUser()["gold"] = user.getGold()
            
            println("Size of inventory is \(user.getInventory().count)")
            
            
            for var i=0; i<user.getInventory().count; i++ {
                newLoot = true
                for var k=0; k<parseLootArray.count; k++ {
                    parseLoot = parseLootArray[k]
                    
                    if(user.getInventory()[i].getId() == parseLoot!["id"] as Int) {
                        newLoot = false
                    }
                    
                }
                if(newLoot) {
                    var loot = PFObject(className: "Loot")
                    loot["type"] = user.getInventory()[i].getClassType()
                    
                    if(user.getInventory()[i].getClassType() == TYPEGEAR) {
                        var gear = user.getInventory()[i] as Gear
                        loot["id"] = gear.getId()
                        loot["name"] = gear.getName()
                        loot["gold"] = gear.isGold()
                        loot["equiped"] = false
                    } else if(user.getInventory()[i].getClassType() == TYPEPOTION) {
                        var potion = user.getInventory()[i]
                        loot["id"] = potion.getId()
                        loot["name"] = potion.getName()
                        loot["gold"] = false
                        loot["equiped"] = false
                    }
                    parseLootArray.append(loot)
                }
            }
            
            for var i=0; i<user.getEquipment().count; i++ {
                newLoot = true
                for var k=0; k<parseLootArray.count; k++ {
                    parseLoot = parseLootArray[k]
                    
                    if(user.getEquipment()[i].getId() == parseLoot!["id"] as Int) {
                        newLoot = false
                    }
                    
                }
                
                if(newLoot) {
                    var loot = PFObject(className: "Loot")
                    var gear = user.getEquipment()[i]
                    
                    loot["type"] = gear.getClassType()
                    loot["id"] = gear.getId()
                    loot["name"] = gear.getName()
                    loot["gold"] = gear.isGold()
                    loot["equiped"] = true
                    parseLootArray.append(loot)
                }
            }
            
            PFUser.currentUser()["loot"] = parseLootArray
            
            PFObject.saveAllInBackground(parseLootArray, block: { (complete: Bool, error: NSError!) -> Void in
            
                PFUser.currentUser().saveInBackgroundWithBlock({ (complete: Bool, error: NSError!) -> Void in
                    if(error != nil) {
                        println("Failed to save user")
                    } else {
                        println("User save complete")
                        NSNotificationCenter.defaultCenter().postNotificationName("refresh", object: nil)
                    }
                })
            })
        
            return true
        } else {
            NSNotificationCenter.defaultCenter().postNotificationName("exit", object: nil)
            return false
        }
    }
    
    func saveUserLocation(location: CLLocation) {
        if PFUser.currentUser() != nil {
            var lat = location.coordinate.latitude as Double
            var lng = location.coordinate.longitude as Double
            
            var locationHistory = self.getUser().getLocationHistory()
            
            locationHistory.latitudes.append(lat)
            locationHistory.longitudes.append(lng)
            
            PFUser.currentUser()["latHistory"] = locationHistory.latitudes
            PFUser.currentUser()["lngHistory"] = locationHistory.longitudes
            
            PFUser.currentUser().saveEventually()
        } else {
            NSNotificationCenter.defaultCenter().postNotificationName("exit", object: nil)
        }
    }
    
    func updateUser() {
        if PFUser.currentUser() != nil {
            
            var queryUser = PFQuery(className: "_User")
            queryUser.whereKey("objectId", equalTo: PFUser.currentUser().objectId)
            queryUser.includeKey("loot")
            
            queryUser.getFirstObjectInBackgroundWithBlock({ (parseUser: PFObject!, error: NSError!) -> Void in
                if parseUser != nil {
                    println("Found user successfully")
                    
                    PFUser.currentUser()["id"] = parseUser["id"]
                    PFUser.currentUser()["health"] = parseUser["health"]
                    PFUser.currentUser()["energy"] = parseUser["energy"]
                    PFUser.currentUser()["clarity"] = parseUser["clarity"]
                    PFUser.currentUser()["latHistory"] = parseUser["latHistory"]
                    PFUser.currentUser()["lngHistory"] = parseUser["lngHistory"]
                    PFUser.currentUser()["gold"] = parseUser["gold"]
                    PFUser.currentUser()["loot"] = parseUser["loot"]
            
                    //NSNotificationCenter.defaultCenter().postNotificationName("refresh", object: nil)
                }
            })
        } else {
            NSNotificationCenter.defaultCenter().postNotificationName("exit", object: nil)
        }
    }
    
    func findChests(lat: Double, lng: Double, distance: Double) {
        println("Inside find chests")
        let currentLocation = PFGeoPoint(latitude:lat, longitude:lng)
     
        var query = PFQuery(className:"Chest")

        query.whereKey("location", nearGeoPoint: currentLocation, withinKilometers: distance)
   
        query.limit = 10
   
        query.findObjectsInBackgroundWithBlock { (objects: Array!, error: NSError!) -> Void in
            var finalChests = [Chest]()
            
            if let chests = objects {
                for c in chests {
                    var chest = self.getChestFromParse(c as PFObject)
                    finalChests.append(chest)
                }
            }
            NSNotificationCenter.defaultCenter().postNotificationName("chestSearchComplete", object: self, userInfo:["chests": finalChests])
        }
    }
    
    //=====================================================//
    //                                                     //
    //                  HELPER FUNCTIONS                   //
    //                                                     //
    //=====================================================//
    
    
    func getUserFromParse(parseUser: PFObject) -> User {
        var result = self.getLootFromParse(parseUser["loot"] as [PFObject])
        var user = User(username: parseUser["username"] as String, email: parseUser["email"] as String, password: UNKNOWN, gold: parseUser["gold"] as Int, health: parseUser["health"] as Int, energy: parseUser["energy"] as Int, clarity: parseUser["clarity"] as Int, inventory: result.inventory, equipment: result.equipment, latHistory: parseUser["latHistory"] as [Double], lngHistory: parseUser["lngHistory"] as [Double], currentId: parseUser["id"] as Int)
     
        println(user.getId())
        
        return user
    }
    
    func getLootFromParse(parseLoot: [PFObject]) -> (inventory: [Loot], equipment: [Gear]) {
        var inventory:[Loot] = []
        var equipment:[Gear] = []
        
        for var i=0; i<parseLoot.count; i++ {
            var parseLoot = parseLoot[i]
            
            if(parseLoot["type"] as NSString == TYPEGEAR && parseLoot["equiped"] as Bool) {
                equipment.append(Gear(name: parseLoot["name"] as String, gold: parseLoot["gold"] as Bool, id: parseLoot["id"] as Int))
            } else if(parseLoot["type"] as NSString == TYPEGEAR) {
                inventory.append(Gear(name: parseLoot["name"] as String, gold: parseLoot["gold"] as Bool, id: parseLoot["id"] as Int))
            } else if(parseLoot["type"] as NSString == TYPEPOTION) {
                inventory.append(Potion(name: parseLoot["name"] as String, id: parseLoot["id"] as Int))
            }
        }
        
        return (inventory: inventory, equipment: equipment)
    }
    
    func getChestFromParse(parseChest: PFObject) -> Chest {
        let geoLocation = parseChest["location"] as PFGeoPoint
        return Chest(latitude: geoLocation.latitude, longitude: geoLocation.longitude, weapon: parseChest["weapon"] as String, weaponGold: parseChest["weaponGold"] as Bool, item: parseChest["item"] as String, gold: parseChest["gold"] as Int)
    }
}