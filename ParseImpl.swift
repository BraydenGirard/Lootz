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
            var parseLoot:PFObject?
            var parseLootArray = PFUser.currentUser()["loot"] as [PFObject]
            var newLoot = true
        
            PFUser.currentUser()["lootId"] = user.getId()
            PFUser.currentUser()["health"] = user.getHealth()
            PFUser.currentUser()["energy"] = user.getEnergy()
            PFUser.currentUser()["clarity"] = user.getClarity()
            PFUser.currentUser()["xp"] = user.getXP()
            PFUser.currentUser()["latHistory"] = user.getLatHistory()
            PFUser.currentUser()["lngHistory"] = user.getLngHistory()
            PFUser.currentUser()["gold"] = user.getGold()
            
            for var i=0; i<user.getInventory().count; i++ {
                newLoot = true
                for var k=0; k<parseLootArray.count; k++ {
                    parseLoot = parseLootArray[k]
                    var parseLootId = parseLoot!["lootId"] as String
                    let localLootId = String(user.getInventory()[i].getId())
                    
                    if(localLootId == parseLoot!["lootId"] as String) {
                        //println("Found unique loot")
                        newLoot = false
                        
                        if(parseLoot!["equiped"] as Bool) {
                            parseLootArray[k]["equiped"] = false
                        }
                        
                        break
                    }
                    
                }
                if(newLoot) {
                    var loot = PFObject(className: "Loot")
                    loot["type"] = user.getInventory()[i].getClassType()
                    
                    if(user.getInventory()[i].getClassType() == TYPEGEAR) {
                        var gear = user.getInventory()[i] as Gear
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
                    if(localLootId == parseLoot!["lootId"] as String) {
                        
                        if(!(parseLoot!["equiped"] as Bool)) {
                            parseLootArray[k]["equiped"] = true
                        }
                        break
                    }
                }
            }
            
            PFUser.currentUser()["loot"] = parseLootArray
            
            PFObject.saveAllInBackground(parseLootArray, block: { (complete: Bool, error: NSError!) -> Void in
                if(error != nil) {
                    println("Failed to save users loot to server")
                }
                PFUser.currentUser().saveInBackgroundWithBlock({ (complete: Bool, error: NSError!) -> Void in
                    if(error != nil) {
                        println("Failed to save user")
                    } else {
                        self.updateUser()
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
        }
    }
    
    func updateUser() {
        if PFUser.currentUser() != nil {
            
            var queryUser = PFQuery(className: "_User")
            queryUser.whereKey("objectId", equalTo: PFUser.currentUser().objectId)
            queryUser.includeKey("loot")
            
            queryUser.getFirstObjectInBackgroundWithBlock({ (parseUser: PFObject!, error: NSError!) -> Void in
                if parseUser != nil {
                    PFUser.currentUser()["email"] = parseUser["email"]
                    PFUser.currentUser()["lootId"] = parseUser["lootId"]
                    PFUser.currentUser()["health"] = parseUser["health"]
                    PFUser.currentUser()["energy"] = parseUser["energy"]
                    PFUser.currentUser()["clarity"] = parseUser["clarity"]
                    PFUser.currentUser()["xp"] = parseUser["xp"]
                    PFUser.currentUser()["latHistory"] = parseUser["latHistory"]
                    PFUser.currentUser()["lngHistory"] = parseUser["lngHistory"]
                    PFUser.currentUser()["gold"] = parseUser["gold"]
                    PFUser.currentUser()["loot"] = parseUser["loot"]
            
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
    
    func removeLootFromServer(loot: Loot) {
        
        if PFUser.currentUser() != nil {
            var currentLoot = PFUser.currentUser()["loot"] as [PFObject]
            
            for var i=0; i<currentLoot.count; i++ {
                var parseLoot = currentLoot[i] as PFObject
                if(parseLoot["lootId"] as String == loot.getId()) {
                    currentLoot.removeAtIndex(i)
                }
            }
            
            PFUser.currentUser()["loot"] = currentLoot
        
            var removeQuery = PFQuery(className: "Loot")
            removeQuery.whereKey("lootId", equalTo: loot.getId())
        
            removeQuery.getFirstObjectInBackgroundWithBlock { (loot: PFObject!, error: NSError!) -> Void in
                if loot != nil {
                    loot.deleteEventually()
                } else {
                    "Removing loot from server failed"
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
        
        removeQuery.findObjectsInBackgroundWithBlock { (objects: Array!, error: NSError!) -> Void in
            var finalChests = [Chest]()
            
            if let chests = objects {
                for c in chests {
                    c.deleteEventually()
                }
            } else {
                println("Could not find a chest to remove from server")
            }
        }

    }
    
    func getDiscoveredChests() {
        if PFUser.currentUser() != nil {
            var user = self.getUser()
            var discoveredChestLngs = user.getLngHistory()
            var discoveredChestLats = user.getLatHistory()
            
            println("Discovered this many chests: \(discoveredChestLngs.count)")
            
            if(discoveredChestLngs.count > 0) {
                let currentLocation = PFGeoPoint(latitude:discoveredChestLats[0], longitude:discoveredChestLngs[0])
                
                var query = PFQuery(className:"Chest")
                
                query.whereKey("location", nearGeoPoint: currentLocation, withinKilometers: SEARCHDISTANCE)
                
                query.limit = 10
                
                query.findObjectsInBackgroundWithBlock { (objects: Array!, error: NSError!) -> Void in
                    var finalChests = [Chest]()
                    
                    if let chests = objects {
                        for c in chests {
                            var chest = self.getChestFromParse(c as PFObject)
                            finalChests.append(chest)
                        }
                    }
                    println("Founds this many chests in the area: \(finalChests.count)")
                    
                    var discoveredChestLngs = user.getLngHistory()
                    var discoveredChestLats = user.getLatHistory()
                    
                    if(finalChests.count < 1 && discoveredChestLngs.count > 0) {
                        println("in recurse function")
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
        var result = self.getLootFromParse(parseUser["loot"] as [PFObject])
        var user = User(username: parseUser["username"] as String, email: parseUser["email"] as String, password: UNKNOWN, gold: parseUser["gold"] as Int, health: parseUser["health"] as Int, energy: parseUser["energy"] as Int, clarity: parseUser["clarity"] as Int, xp: parseUser["xp"] as Int, inventory: result.inventory, equipment: result.equipment, latHistory: parseUser["latHistory"] as [Double], lngHistory: parseUser["lngHistory"] as [Double], currentId: parseUser["lootId"] as Int)
        
        return user
    }
    
    func getLootFromParse(parseLoot: [PFObject]) -> (inventory: [Loot], equipment: [Gear]) {
        var inventory:[Loot] = []
        var equipment:[Gear] = []
        
        for var i=0; i<parseLoot.count; i++ {
            var parseLoot = parseLoot[i]
            
            if(parseLoot["type"] as NSString == TYPEGEAR && parseLoot["equiped"] as Bool) {
                equipment.append(Gear(name: parseLoot["name"] as String, gold: parseLoot["gold"] as Bool, lootId: parseLoot["lootId"] as String))
            } else if(parseLoot["type"] as NSString == TYPEGEAR) {
                inventory.append(Gear(name: parseLoot["name"] as String, gold: parseLoot["gold"] as Bool, lootId: parseLoot["lootId"] as String))
            } else if(parseLoot["type"] as NSString == TYPEPOTION) {
                inventory.append(Potion(name: parseLoot["name"] as String, lootId: parseLoot["lootId"] as String))
            }
            
        }
        
        return (inventory: inventory, equipment: equipment)
    }
    
    func getChestFromParse(parseChest: PFObject) -> Chest {
        let geoLocation = parseChest["location"] as PFGeoPoint
        return Chest(latitude: geoLocation.latitude, longitude: geoLocation.longitude, weapon: parseChest["weapon"] as String, weaponGold: parseChest["weaponGold"] as Bool, item: parseChest["item"] as String, gold: parseChest["gold"] as Int)
    }
}