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
        parseUser["xp"] = user.getXP()
        parseUser["latHistory"] = user.getLatHistory()
        parseUser["lngHistory"] = user.getLngHistory()
        parseUser["gold"] = user.getGold()
        parseUser["loot"] = []
        parseUser["lootId"] = user.getId()
        parseUser["homeLat"] = user.getHomeLat()
        parseUser["homeLng"] = user.getHomeLng()
        parseUser["home"] = user.isHome()
        
        parseUser.signUpInBackgroundWithBlock {
            (success: Bool, error: NSError?) -> Void in
            if success {
                println("Parse sign up was successful")
                NSNotificationCenter.defaultCenter().postNotificationName("signUpSuccess", object: nil)
            } else {
                if let err = error {
                    println("Parse sign up failed with error: \(err)")
                } else {
                    println("Parse sign up failed with unknown error")
                }
                
                NSNotificationCenter.defaultCenter().postNotificationName("signUpFail", object: nil)
            }
        }
    }
    
    func login(username: String, password: String) {
        PFUser.logInWithUsernameInBackground(username, password: password) { (resultUser: PFUser?, error: NSError?) -> Void in
    
            if let user = resultUser {
                println("Parse login was successful")
                NSNotificationCenter.defaultCenter().postNotificationName("loginSuccess", object: nil)
            } else {
                if let err = error {
                    println("Parse login failed with error: \(err)")
                } else {
                    println("Parse login failed with unknown error")
                }
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
           return self.getUserFromParse(PFUser.currentUser()!)
        } else {
            NSNotificationCenter.defaultCenter().postNotificationName("exit", object: nil)
            var user = User()
            return user
        }
    }
    
    func getUserByUsername(username: String) -> User {
        var query = PFUser.query()
        query!.whereKey("username", equalTo:username)
        return self.getUserFromParse(query!.getFirstObject()!)
    }
    
    //Check to see if the id in inventory loot matches
    //the id of the parse loot, if not remove the parse loot
    //from server and add the new loot
    func saveUser(user: User) -> Bool {
        if PFUser.currentUser() != nil {
            var parseLoot:PFObject?
            var parseLootArray = PFUser.currentUser()!["loot"] as! [PFObject]
            var newLoot = true
        
            PFUser.currentUser()!["lootId"] = user.getId()
            PFUser.currentUser()!["health"] = user.getHealth()
            PFUser.currentUser()!["energy"] = user.getEnergy()
            PFUser.currentUser()!["clarity"] = user.getClarity()
            PFUser.currentUser()!["xp"] = user.getXP()
            PFUser.currentUser()!["latHistory"] = user.getLatHistory()
            PFUser.currentUser()!["lngHistory"] = user.getLngHistory()
            PFUser.currentUser()!["gold"] = user.getGold()
            PFUser.currentUser()!["homeLat"] = user.getHomeLat()
            PFUser.currentUser()!["homeLng"] = user.getHomeLng()
            PFUser.currentUser()!["home"] = user.isHome()
            
    
            
            for var i=0; i<user.getInventory().count; i++ {
                newLoot = true
                for var k=0; k<parseLootArray.count; k++ {
                    parseLoot = parseLootArray[k]
                    var parseLootId = parseLoot!["lootId"] as! String
                    let localLootId = String(user.getInventory()[i].getId())
                    
                    if(localLootId == parseLoot!["lootId"] as! String) {
                        newLoot = false
                        
                        if(parseLoot!["equiped"] as! Bool) {
                            parseLootArray[k]["equiped"] = false
                        }
                        
                        break
                    }
                    
                }
                if(newLoot) {
                    var loot = PFObject(className: "Loot")
                    loot["type"] = user.getInventory()[i].getClassType()

                    if(user.getInventory()[i].getClassType() == TYPEGEAR) {
                        var gear = user.getInventory()[i] as! Gear
                        
                        loot["lootId"] = String(gear.getId())
                        loot["name"] = gear.getName()
                        loot["gold"] = gear.isGold()
                        loot["equiped"] = false
                    } else if(user.getInventory()[i].getClassType() == TYPEPOTION) {
                        
                        var potion = user.getInventory()[i]
                    
                        loot["lootId"] = String(potion.getId())
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
                    let localLootId = String(user.getEquipment()[i].getId())
                    if(localLootId == parseLoot!["lootId"] as! String) {
                        
                        if(!(parseLoot!["equiped"] as! Bool)) {
                            parseLootArray[k]["equiped"] = true
                        }
                        break
                    }
                }
            }
            
            PFUser.currentUser()!["loot"] = parseLootArray
            
            PFObject.pinAll(parseLootArray, withName: "Loot")
            
            PFUser.currentUser()?.saveEventually({ (success: Bool, error: NSError?) -> Void in
                if(success) {
                    println("The user was saved successfully")
                } else {
                    if let err = error {
                        println("Parse error when saving user: \(err)")
                    } else {
                        println("Unknown error while saving user")
                    }
                    
                }
            })
        
            //self.updateUser()
            
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
            
            var userDefaults = NSUserDefaults()
            userDefaults.setDouble(lat, forKey: "lat")
            userDefaults.setDouble(lng, forKey: "lng")
            
            var locationHistory = self.getUser().getLocationHistory()
            
            locationHistory.latitudes.append(lat)
            locationHistory.longitudes.append(lng)
            
            PFUser.currentUser()!["latHistory"] = locationHistory.latitudes
            PFUser.currentUser()!["lngHistory"] = locationHistory.longitudes
            
            PFUser.currentUser()?.saveEventually({ (success: Bool, error: NSError?) -> Void in
                if(success) {
                    println("The users location saved successfully")
                } else {
                    if let err = error {
                        println("Parse error when saving users location: \(err)")
                    } else {
                        println("Unknown error while saving users location")
                    }
                    
                }
            })
        }
    }
    
    func updateUser() {
        if PFUser.currentUser() != nil {
            NSNotificationCenter.defaultCenter().postNotificationName("refresh", object: nil)
    
            var queryUser = PFQuery(className: "_User")
            
            queryUser.whereKey("objectId", equalTo: PFUser.currentUser()!.objectId!)
            queryUser.includeKey("loot")
            
            
            queryUser.getFirstObjectInBackgroundWithBlock({ (resultUser: PFObject?, error: NSError?) -> Void in
                if let parseUser = resultUser {
                    PFUser.currentUser()!["email"] = parseUser["email"]
                    PFUser.currentUser()!["lootId"] = parseUser["lootId"]
                    PFUser.currentUser()!["health"] = parseUser["health"]
                    PFUser.currentUser()!["energy"] = parseUser["energy"]
                    PFUser.currentUser()!["clarity"] = parseUser["clarity"]
                    PFUser.currentUser()!["xp"] = parseUser["xp"]
                    PFUser.currentUser()!["latHistory"] = parseUser["latHistory"]
                    PFUser.currentUser()!["lngHistory"] = parseUser["lngHistory"]
                    PFUser.currentUser()!["gold"] = parseUser["gold"]
                    PFUser.currentUser()!["loot"] = parseUser["loot"]
                    PFUser.currentUser()!["homeLat"] = parseUser["homeLng"]
                    PFUser.currentUser()!["homeLng"] = parseUser["homeLat"]
                    PFUser.currentUser()!["home"] = parseUser["home"]
            
                    NSNotificationCenter.defaultCenter().postNotificationName("refresh", object: nil)
                } else {
                    println("Failed to find user on server when trying to update")
                }
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
   
        query.findObjectsInBackgroundWithBlock { (objects: [AnyObject]?, error: NSError?) -> Void in
            var finalChests = [Chest]()
            
            if let chests = objects {
                for c in chests {
                    var chest = self.getChestFromParse(c as! PFObject)
                    finalChests.append(chest)
                }
            }
            NSNotificationCenter.defaultCenter().postNotificationName("chestSearchComplete", object: self, userInfo:["chests": finalChests])
        }
    }
    
    func removeLootFromServer(loot: Loot) {
        
        if PFUser.currentUser() != nil {
            var currentLoot = PFUser.currentUser()!["loot"] as! [PFObject]
            
            for var i=0; i<currentLoot.count; i++ {
                var parseLoot = currentLoot[i] as PFObject
                if(parseLoot["lootId"] as! String == loot.getId()) {
                    currentLoot.removeAtIndex(i)
                }
            }
            
            PFUser.currentUser()!["loot"] = currentLoot
        
            var removeQuery = PFQuery(className: "Loot")
            removeQuery.whereKey("lootId", equalTo: loot.getId())
        
            removeQuery.getFirstObjectInBackgroundWithBlock { (resultLoot: PFObject?, error: NSError?) -> Void in
                if let loot = resultLoot {
                    loot.deleteInBackgroundWithBlock({ (success: Bool, error: NSError?) -> Void in
                        if success {
                            println("Parse removed loot from server successfully")
                        } else {
                            if let err = error {
                                println("Parse failed to remove loot from server with error: \(err)")
                            } else {
                                println("Parse failed to remove loot from server with unknown error")
                            }
                        }
                    })
                } else {
                    if let err = error {
                        println("Parse could not find loot to remove with error: \(err)")
                    } else {
                        println("Parse could not find loot to remove with unknown error")
                    }
                }
            }
            
            //NSNotificationCenter.defaultCenter().postNotificationName("refresh", object: nil)
        }
        else {
            NSNotificationCenter.defaultCenter().postNotificationName("exit", object: nil)
        }
    }
    
    func removeChestFromServer(chest: Chest) {
        var removeQuery = PFQuery(className: "Chest")
        let point = PFGeoPoint(latitude:chest.getLatitude(), longitude:chest.getLongitude())
        
        removeQuery.whereKey("location", nearGeoPoint: point, withinKilometers: 0.1)
        
        removeQuery.limit = 1
        
        removeQuery.findObjectsInBackgroundWithBlock { (objects: [AnyObject]?, error: NSError?) -> Void in
            var finalChests = [Chest]()
            
            if let chests = objects  {
                for c in chests {
                    (c as! PFObject).deleteInBackgroundWithBlock({ (success: Bool, error: NSError?) -> Void in
                        if success {
                            println("Parse removed chest successfully")
                        } else {
                            if let err = error {
                                println("Parse failed to remove chest with error: \(err)")
                            } else {
                                println("Parse failed to remove chest with unknown error")
                            }
                        }
                    })
                }
            } else {
                if let err = error {
                    println("Parse could not find a chest to remove from server with error: \(err)")
                } else {
                    println("Parse could not find a chest to remove from server with unknown error")
                }
            }
        }

    }
    
    func getDiscoveredChests() {
        if PFUser.currentUser() != nil {
            var user = self.getUser()
            var discoveredChestLngs = user.getLngHistory()
            var discoveredChestLats = user.getLatHistory()
            
            if(discoveredChestLngs.count > 0) {
                let currentLocation = PFGeoPoint(latitude:discoveredChestLats[0], longitude:discoveredChestLngs[0])
                
                var query = PFQuery(className:"Chest")
                
                query.whereKey("location", nearGeoPoint: currentLocation, withinKilometers: SEARCHDISTANCE)
                
                query.limit = 10
            
                query.findObjectsInBackgroundWithBlock { (objects: [AnyObject]?, error: NSError?) -> Void in
                    var finalChests = [Chest]()
                    
                    if let chests = objects {
                        for c in chests {
                            var chest = self.getChestFromParse(c as! PFObject)
                            finalChests.append(chest)
                        }
                    }
                    
                    var discoveredChestLngs = user.getLngHistory()
                    var discoveredChestLats = user.getLatHistory()
                    
                    if(finalChests.count < 1 && discoveredChestLngs.count > 0) {
                        var user = self.getUser()
                        
                        discoveredChestLngs.removeAtIndex(0)
                        discoveredChestLats.removeAtIndex(0)
                        
                        user.setLatHistory(discoveredChestLats)
                        user.setLngHistory(discoveredChestLngs)
                        self.saveUser(user)
                        
                        self.getDiscoveredChests()
                    } else {
                        NSNotificationCenter.defaultCenter().postNotificationName("chestDiscoveryComplete", object: self, userInfo:["chests": finalChests])
                    }
                }
            } else {
                println("No chests have been discovered")
                NSNotificationCenter.defaultCenter().postNotificationName("chestDiscoveryComplete", object: self, userInfo:["chests": []])
            }
            
        }
        else {
            NSNotificationCenter.defaultCenter().postNotificationName("exit", object: nil)
        }
    }
    
    //=====================================================//
    //                                                     //
    //                  HELPER FUNCTIONS                   //
    //                                                     //
    //=====================================================//
    
    
    func getUserFromParse(parseUser: PFObject) -> User {
        
        
        var result = self.getLootFromParse((parseUser["loot"] as? [PFObject])!)
        var user = User(username: parseUser["username"] as! String, email: parseUser["email"] as! String, password: UNKNOWN, gold: parseUser["gold"] as! Int, health: parseUser["health"] as! Int, energy: parseUser["energy"] as! Int, clarity: parseUser["clarity"] as! Int, xp: parseUser["xp"] as! Int, inventory: result.inventory, equipment: result.equipment, latHistory: parseUser["latHistory"] as! [Double], lngHistory: parseUser["lngHistory"] as! [Double], currentId: parseUser["lootId"] as! Int, homeLat: parseUser["homeLat"] as! Double, homeLng: parseUser["homeLng"] as! Double, home: parseUser["home"] as! Bool)
        
        return user
    }
    
    func getLootFromParse(parseLoot: [PFObject]) -> (inventory: [Loot], equipment: [Gear]) {
        var inventory:[Loot] = []
        var equipment:[Gear] = []
        
        for var i=0; i<parseLoot.count; i++ {
            var parseLoot = parseLoot[i]
           // parseLoot.fetchIfNeeded()
            if(parseLoot["type"] as? NSString == TYPEGEAR && parseLoot["equiped"] as! Bool) {
                equipment.append(Gear(name: parseLoot["name"] as! String, gold: parseLoot["gold"] as! Bool, lootId: parseLoot["lootId"] as! String))
            } else if(parseLoot["type"] as? NSString == TYPEGEAR) {
                inventory.append(Gear(name: parseLoot["name"] as! String, gold: parseLoot["gold"] as! Bool, lootId: parseLoot["lootId"] as! String))
            } else if(parseLoot["type"] as? NSString == TYPEPOTION) {
                inventory.append(Potion(name: parseLoot["name"] as! String, lootId: parseLoot["lootId"] as! String))
            }
            
        }
        
        return (inventory: inventory, equipment: equipment)
    }
    
    func getChestFromParse(parseChest: PFObject) -> Chest {
        let geoLocation = parseChest["location"] as! PFGeoPoint
        return Chest(latitude: geoLocation.latitude, longitude: geoLocation.longitude, weapon: parseChest["weapon"] as! String, weaponGold: parseChest["weaponGold"] as! Bool, item: parseChest["item"] as! String, gold: parseChest["gold"] as! Int)
    }
}