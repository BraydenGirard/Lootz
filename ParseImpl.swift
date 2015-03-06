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
        var currentUser = PFUser.currentUser()
        if currentUser != nil {
           return self.getUserFromParse(currentUser)
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
        var parseUser = PFUser.currentUser()
        if parseUser != nil {
            var lootArray = parseUser["loot"] as [PFObject]
            
            parseUser.username = user.getUsername()
            parseUser.email = user.getEmail()
            parseUser["health"] = user.getHealth()
            parseUser["energy"] = user.getEnergy()
            parseUser["clarity"] = user.getClarity()
            parseUser["latHistory"] = user.getLatHistory()
            parseUser["lngHistory"] = user.getLngHistory()
            parseUser["gold"] = user.getGold()
            
            for var i=0; i<user.getInventory().count; i++ {
                
                if(user.getInventory()[i] is Gear) {
                    var newGear = user.getInventory()[i] as Gear
                    var isNew = true
                   
                    var parseGear:PFObject?
                    
                    //Check if the gear already exists in the inventory
                    for var k=0; k<lootArray.count; k++ {
                        parseGear = lootArray[k]
                        
                        if(parseGear!["name"] as String == newGear.getName()) {
                            isNew = false;
                            break;
                        }
                    }
                    
                    if(isNew) {
                        var gear = PFObject(className: "Gear")
                        
                        gear["name"] = newGear.getName() as String
                        gear["gold"] = newGear.isGold() as Bool
                        gear["quantity"] = newGear.getQuantity() as Int
                        gear.saveEventually()
                        gearArray.append(gear)
                        
                    } else {
                        println(newGear.getQuantity())
                        parseGear!["quantity"] = newGear.getQuantity();
                        parseGear!.saveEventually()
                        //gearArray.append(parseGear!)
                    }
                    
                    
                } else {
                    var isNew = true
                    
                    var parseLoot:PFObject? = nil
                    
                    //Check if the gear already exists in the inventory
                    for var k=0; k<lootArray.count; k++ {
                        parseLoot = lootArray[k]
                        
                        if(parseLoot!["name"] as String == user.getInventory()[i].getName()) {
                            isNew = false;
                            break;
                        }
                    }
                    
                    if(isNew) {
                        var loot = PFObject(className: "Loot")
                        loot["name"] = user.getInventory()[i].getName()
                        loot["quantity"] = user.getInventory()[i].getQuantity()
                        loot.saveEventually()

                        lootArray.append(loot)
                        
                    } else {
                        parseLoot!["quantity"] = user.getInventory()[i].getQuantity();
                        parseLoot!.saveEventually()
                        //lootArray.append(parseLoot!)
                    }
                    

                }
            }
            
            for var i=0; i<user.getEquipment().count; i++ {
                var isNew = true
                
                var parseLoot:PFObject? = nil
                
                //Check if the gear already exists in the inventory
                for var k=0; k<equipmentArray.count; k++ {
                    parseLoot = equipmentArray[k]
                    
                    if(parseLoot!["name"] as String == user.getEquipment()[i].getName()) {
                        isNew = false;
                        break;
                    }
                }
                
                if(isNew) {
                    var loot = PFObject(className: "Gear")
                    loot["name"] = user.getEquipment()[i].getName()
                    loot["gold"] = user.getEquipment()[i].isGold()
                    loot["quantity"] = user.getEquipment()[i].getQuantity()
                    loot.saveEventually()
                    equipmentArray.append(loot)
                    
                } else {
                    parseLoot!["quantity"] = user.getEquipment()[i].getQuantity();
                    parseLoot!.saveEventually()
                    //equipmentArray.append(parseLoot!)
                }
               
            }
            
            parseUser["loot"] = lootArray
            parseUser["gear"] = gearArray
            parseUser["equipment"] = equipmentArray
            
            parseUser.saveEventually()
            return true
        } else {
            NSNotificationCenter.defaultCenter().postNotificationName("exit", object: nil)
            return false
        }
    }
    
    func saveUserLocation(location: CLLocation) {
        var currentUser = PFUser.currentUser()
        if currentUser != nil {
            var lat = location.coordinate.latitude as Double
            var lng = location.coordinate.longitude as Double
            
            var locationHistory = self.getUser().getLocationHistory()
            
            locationHistory.latitudes.append(lat)
            locationHistory.longitudes.append(lng)
            
            currentUser["latHistory"] = locationHistory.latitudes
            currentUser["lngHistory"] = locationHistory.longitudes
            
            currentUser.saveEventually()
        } else {
            NSNotificationCenter.defaultCenter().postNotificationName("exit", object: nil)
        }
    }
    
    func updateUser() {
        if let currentUser = PFUser.currentUser() {
            currentUser.fetchIfNeededInBackgroundWithBlock({ (user: PFObject!, error: NSError!) -> Void in
                NSNotificationCenter.defaultCenter().postNotificationName("refresh", object: nil)
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
    
    //=====================================================//
    //                                                     //
    //                  HELPER FUNCTIONS                   //
    //                                                     //
    //=====================================================//
    
    
    func getUserFromParse(parseUser: PFObject) -> User {
        var result = self.getLootFromParse(parseUser["loot"] as [PFObject])
        
        return User(username: parseUser["username"] as String, email: parseUser["email"] as String, password: UNKNOWN, gold: parseUser["gold"] as Int, health: parseUser["health"] as Int, energy: parseUser["energy"] as Int, clarity: parseUser["clarity"] as Int, inventory: result.inventory, equipment: result.equipment, latHistory: parseUser["latHistory"] as [Double], lngHistory: parseUser["lngHistory"] as [Double], currentId: parseUser["id"] as Int)
    }
    
    func getLootFromParse(parseLoot: [PFObject]) -> (inventory: [Loot], equipment: [Gear]) {
        var inventory:[Loot] = []
        var equipment:[Gear] = []
        
        for var i=0; i<parseLoot.count; i++ {
            var parseLoot = parseLoot[i]
            
            if(parseLoot["type"] as NSString == TYPEGEAR && parseLoot["equiped"] as Bool) {
                equipment.append(Gear(name: parseLoot["name"] as String, gold: parseLoot["gold"] as Bool))
            } else if(parseLoot["type"] as NSString == TYPEGEAR) {
                inventory.append(Gear(name: parseLoot["name"] as String, gold: parseLoot["gold"] as Bool))
            } else if(parseLoot["type"] as NSString == TYPEPOTION) {
                inventory.append(Potion(name: parseLoot["name"] as String))
            }
        }
        
        return (inventory: inventory, equipment: equipment)
    }
    
    func getChestFromParse(parseChest: PFObject) -> Chest {
        let geoLocation = parseChest["location"] as PFGeoPoint
        return Chest(latitude: geoLocation.latitude, longitude: geoLocation.longitude, weapon: parseChest["weapon"] as String, weaponGold: parseChest["weaponGold"] as Bool, item: parseChest["item"] as String, gold: parseChest["gold"] as Int)
    }
}