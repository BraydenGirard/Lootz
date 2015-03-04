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
            
            var lootArray = [PFObject]()
            var gearArray = [PFObject]()
            
            for var i=0; i<user.getInventory().count; i++ {
                
                if(user.getInventory()[i] is Gear) {
                    var currentGear = user.getInventory()[i] as Gear
                    var gear = PFObject(className: "Gear")
                    gear["name"] = currentGear.getName() as String
                    gear["gold"] = currentGear.isGold() as Bool
                    gear["quantity"] = currentGear.getQuantity() as Int
                    gearArray.append(gear)
                } else {
                    var loot = PFObject(className: "Loot")
                    loot["name"] = user.getInventory()[i].getName()
                    loot["quantity"] = user.getInventory()[i].getQuantity()
                    lootArray.append(loot)

                }
            }
            
            var equipment = [PFObject]()
            
            for var i=0; i<user.getEquipment().count; i++ {
                var loot = PFObject(className: "Gear")
                loot["name"] = user.getEquipment()[i].getName()
                loot["isGold"] = user.getEquipment()[i].isGold()
                loot["quantity"] = user.getEquipment()[i].getQuantity()
                equipment.append(loot)
            }
            
            parseUser["loot"] = lootArray
            parseUser["gear"] = gearArray
            parseUser["equipment"] = equipment
            
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
            var userQuery = PFUser.query()
         
            PFUser.currentUser().fetchIfNeededInBackgroundWithBlock({ (user:PFObject!, error: NSError!) -> Void in
                user["loot"].fetchIfNeededInBackgroundWithBlock({ (inventory: PFObject!, error: NSError!) -> Void in
                    NSNotificationCenter.defaultCenter().postNotificationName("refreshProfile", object: nil)
                })
                user["gear"].fetchIfNeededInBackgroundWithBlock({ (inventory: PFObject!, error: NSError!) -> Void in
                    NSNotificationCenter.defaultCenter().postNotificationName("refreshProfile", object: nil)
                })
                user["equipment"].fetchIfNeededInBackgroundWithBlock({ (inventory: PFObject!, error: NSError!) -> Void in
                    NSNotificationCenter.defaultCenter().postNotificationName("refreshProfile", object: nil)
                })
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
    
    func getChestFromParse(parseChest: PFObject) -> Chest {
        return Chest(latitude: parseChest["latitude"] as Double, longitude: parseChest["longitude"] as Double, weapon: parseChest["weapon"] as String, weaponGold: parseChest["weaponGold"] as Bool, item: parseChest["item"] as String, gold: parseChest["gold"] as Int)
    }
    
    func getUserFromParse(parseUser: PFObject) -> User {
        var loot = self.getLootFromParse(parseUser["loot"] as [PFObject])
        var gear = self.getGearFromParse(parseUser["gear"] as [PFObject])
        var inventory:[Loot] = []
        
        for l in loot {
            inventory.append(l)
        }
        
        for g in gear {
            inventory.append(g)
        }
        
        var equipment = self.getGearFromParse(parseUser["equipment"] as [PFObject])
        
        return User(username: parseUser["username"] as String, email: parseUser["email"] as String, password: UNKNOWN, gold: parseUser["gold"] as Int, health: parseUser["health"] as Int, energy: parseUser["energy"] as Int, clarity: parseUser["clarity"] as Int, inventory: inventory, equipment: equipment, latHistory: parseUser["latHistory"] as [Double], lngHistory: parseUser["lngHistory"] as [Double])
    }
    
    func getLootFromParse(parseInv: [PFObject]) -> [Loot] {
        var inventory:[Loot] = []
        
        for var i=0; i<parseInv.count; i++ {
            var parseLoot = parseInv[i]
            var loot = Loot(name: parseLoot["name"] as String, image: UIImage(named: parseLoot["name"] as String)!, quantity: parseLoot["quantity"] as Int)
            inventory.append(loot)
        }
        
        return inventory
    }
    
    func getGearFromParse(parseEqp: [PFObject]) -> [Gear] {
        var equipment:[Gear] = []
        
        for var i=0; i<parseEqp.count; i++ {
            var parseGear = parseEqp[i]
            var gear = Gear(name: parseGear["name"] as String, gold: parseGear["isGold"] as Bool, quantity: parseGear["quantity"] as Int)
            equipment.append(gear)
        }
        
        return equipment
    }
}