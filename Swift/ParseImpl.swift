//  Parse implementation of database manager protocol

import Foundation

class ParseImpl: DatabaseManager {
    
    //  MARK: User management
    
    //  Given a users signup information, send a parse sign up request
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
            (succeeded: Bool!, error: NSError!) -> Void in
            if error == nil {
                println("The Parse sign up was successful")
                NSNotificationCenter.defaultCenter().postNotificationName("signUpSuccess", object: nil)
            } else {
                let errorString = error.userInfo!["error"] as NSString
                println("The Parse sign up failed with error: \(errorString)")
                
                NSNotificationCenter.defaultCenter().postNotificationName("signUpFail", object: nil)
            }
        }
    }
    
    //  Given a users login information, send a Parse login request
    func login(username: String, password: String) {
        PFUser.logInWithUsernameInBackground(username, password:password) {
            (user: PFUser!, error: NSError!) -> Void in
            if user != nil {
                println("The Parse login was successful")
                NSNotificationCenter.defaultCenter().postNotificationName("loginSuccess", object: nil)
            } else {
                let errorString = error.userInfo!["error"] as NSString
                println("The Parse login failed with error: \(errorString)")
                
                NSNotificationCenter.defaultCenter().postNotificationName("loginFail", object: nil)
            }
        }
    }
    
    //  Check if a user is currently logged in
    func checkAutoSignIn() -> Bool {
        var currentUser = PFUser.currentUser()
        if currentUser != nil {
            return true
        } else {
            return false
        }
    }
    
    //  Get the local copy of the user
    func getUser() -> User {
        if PFUser.currentUser() != nil {
           return self.getUserFromParse(PFUser.currentUser())
        } else {
            NSNotificationCenter.defaultCenter().postNotificationName("exit", object: nil)
            var user = User()
            return user
        }
    }
    
    //  Get a user by their username
    func getUserByUsername(username: String) -> User {
        var query = PFUser.query()
        query.whereKey("username", equalTo:username)
        return self.getUserFromParse(query.getFirstObject())
    }
    
    //  Update the user in the database
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
            PFUser.currentUser()["homeLat"] = user.getHomeLat()
            PFUser.currentUser()["homeLng"] = user.getHomeLng()
            PFUser.currentUser()["home"] = user.isHome()
            
            //  Id used to keep track of who loot belongs to
            //  Check to see if the id in the local loot matches
            //  the id of the server loot, if not remove the server loot
            //  and add the new loot
            
            for var i=0; i<user.getInventory().count; i++ {
                newLoot = true
                for var k=0; k<parseLootArray.count; k++ {
                    parseLoot = parseLootArray[k]
                    var parseLootId = parseLoot!["lootId"] as String
                    let localLootId = String(user.getInventory()[i].getId())
                    
                    if(localLootId == parseLoot!["lootId"] as String) {
                        newLoot = false
                        
                        if(parseLoot!["equiped"] as Bool) {
                            parseLootArray[k]["equiped"] = false
                        }
                        
                        break
                    }
                    
                }
                if(newLoot) {
                    var loot = PFObject(className: "Loot")

                    if(user.getInventory()[i] is Gear) {
                        var gear = user.getInventory()[i] as Gear
                        loot["type"] = TYPEGEAR
                        loot["lootId"] = String(gear.getId())
                        loot["name"] = gear.getName()
                        loot["gold"] = gear.isGold()
                        loot["equiped"] = false
                    } else if(user.getInventory()[i] is Potion) {
                        
                        var potion = user.getInventory()[i]
                        loot["type"] = TYPEPOTION
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
                        let errorString = error.userInfo!["error"] as NSString
                        println("Parse failed to save user with error: \(errorString)")
                    } else {
                        println("Parse successfully saved the user")
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
    
    //  Add a new location for a chest found in the background to a users 
    //  list of discovered chests
    func saveUserLocation(location: CLLocation) {
        if PFUser.currentUser() != nil {
            
            var latHistory = PFUser.currentUser()["latHistory"] as [Double]
            var lngHistory = PFUser.currentUser()["lngHistory"] as [Double]
            
            latHistory.append(location.coordinate.latitude as Double)
            lngHistory.append(location.coordinate.longitude as Double)
            
            PFUser.currentUser()["latHistory"] = latHistory
            PFUser.currentUser()["lngHistory"] = lngHistory
            
            PFUser.currentUser().saveEventually()
            
            println("Added background location")
        }
    }
    
    //  Regenerates energy to full
    func regenerateEnergy() {
        if PFUser.currentUser() != nil {
            
            PFUser.currentUser()["energy"] = FULLENERGY
            
            PFUser.currentUser().saveEventually()
            
            println("Energy regenerated")
        }
    }
    
    //  Update the users home state
    func updateHome(home: Bool) {
        if PFUser.currentUser() != nil {
            
            PFUser.currentUser()["home"] = home
            
            if home {
                PFUser.currentUser()["energy"] = FULLENERGY
            }
            
            PFUser.currentUser().saveEventually()
        }
    }

    //  Update the local copy of a user with the server copy
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
                    PFUser.currentUser()["homeLat"] = parseUser["homeLng"]
                    PFUser.currentUser()["homeLng"] = parseUser["homeLat"]
                    PFUser.currentUser()["home"] = parseUser["home"]
                    println("Parse user updated successfully")
                    NSNotificationCenter.defaultCenter().postNotificationName("refresh", object: nil)
                } else {
                    let errorString = error.userInfo!["error"] as NSString
                    println("Parse failed to find user on server when trying to update with error: \(errorString)")
                }
            })
        } else {
            NSNotificationCenter.defaultCenter().postNotificationName("exit", object: nil)
        }
    }
    
    //  MARK: Chest management
    
    //  Find chests in the area based on a given distance and location
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
            println("Parse query for chests is complete")
            NSNotificationCenter.defaultCenter().postNotificationName("chestSearchComplete", object: self, userInfo:["chests": finalChests])
        }
    }
    
    //  Remove a chest from the server (when a user loots a chest)
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
                let errorString = error.userInfo!["error"] as NSString
                println("Parse could not find a chest to remove from server with error: \(errorString)")
            }
        }

    }
    
    //  Get this list of chests a user has discovered in the background
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
                
                query.findObjectsInBackgroundWithBlock { (objects: Array!, error: NSError!) -> Void in
                    var finalChests = [Chest]()
                    
                    if let chests = objects {
                        for c in chests {
                            var chest = self.getChestFromParse(c as PFObject)
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
                        println("Parse found chests in range of location history")
                        NSNotificationCenter.defaultCenter().postNotificationName("chestDiscoveryComplete", object: self, userInfo:["chests": finalChests])
                    }
                }
            } else {
                println("Parse could not find chests in range of location history")
                NSNotificationCenter.defaultCenter().postNotificationName("chestDiscoveryComplete", object: self, userInfo:["chests": []])
            }
            
        }
        else {
            NSNotificationCenter.defaultCenter().postNotificationName("exit", object: nil)
        }
    }
    
    //  MARK: Loot management
    
    //  Remove loot from the server (when user removes inventory loot)
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
                    let errorString = error.userInfo!["error"] as NSString
                    println("Parse removing loot from the server failed with error: \(errorString)")
                }
            }
        }
        else {
            NSNotificationCenter.defaultCenter().postNotificationName("exit", object: nil)
        }
    }
    
    //  MARK: Helper functions
    
    //  Copy the parse instance of user into a user model
    func getUserFromParse(parseUser: PFObject) -> User {
        var result = self.getLootFromParse(parseUser["loot"] as [PFObject])
        var user = User(username: parseUser["username"] as String, email: parseUser["email"] as String, password: UNKNOWN, gold: parseUser["gold"] as Int, health: parseUser["health"] as Int, energy: parseUser["energy"] as Int, clarity: parseUser["clarity"] as Int, xp: parseUser["xp"] as Int, inventory: result.inventory, equipment: result.equipment, latHistory: parseUser["latHistory"] as [Double], lngHistory: parseUser["lngHistory"] as [Double], currentId: parseUser["lootId"] as Int, homeLat: parseUser["homeLat"] as Double, homeLng: parseUser["homeLng"] as Double, home: parseUser["home"] as Bool)
        
        return user
    }
    
    //  Copy the parse instance of a users loot into the lootz user model
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
    
    //  Copy a parse chest object into a lootz chest object
    func getChestFromParse(parseChest: PFObject) -> Chest {
        let geoLocation = parseChest["location"] as PFGeoPoint
        return Chest(latitude: geoLocation.latitude, longitude: geoLocation.longitude, weapon: parseChest["weapon"] as String, weaponGold: parseChest["weaponGold"] as Bool, item: parseChest["item"] as String, gold: parseChest["gold"] as Int)
    }
}