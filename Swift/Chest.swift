//  Chest model

import Foundation

class Chest {
    
    private let latitude: Double    //  Location of chest latitude
    private let longitude: Double   //  Location of chest longitude
    private let weapon: String      //  The name of the weapon in the chest
    private let weaponGold: Bool    //  Is the weapon in the chest gold
    private let item: String        //  The name of the item in the chest ('Empty' if none)
    private let gold: Int           //  The amount of gold (money) in the chest
    
    //  Initialize a chest
    init(latitude: Double, longitude: Double, weapon: String, weaponGold: Bool, item:String, gold: Int) {
        self.latitude = latitude
        self.longitude = longitude
        self.weapon = weapon
        self.weaponGold = weaponGold
        self.item = item
        self.gold = gold
    }
    
    //  MARK: Chest Getters
    
    func getLatitude() -> Double {
        return self.latitude
    }
    
    func getLongitude() -> Double {
        return self.longitude
    }

    func getWeapon() -> String {
        return self.weapon
    }
    
    func isGold() -> Bool {
        return self.weaponGold
    }
    
    func getItem() -> String {
        return self.item
    }
    
    func getGold() -> Int {
        return self.gold
    }
    
    //  Creates loot objects from the contents of a chest
    //  Adds the loot objects to the given users inventory
    func getLoot() -> (success: Bool, user: User) {
        var loot = [Loot]()
        var weapon:Gear
        var user = DBFactory.execute().getUser()
        weapon = Gear(name: self.weapon, gold: self.weaponGold, lootId: String(user.getNextId()) + user.getEmail())
        
        loot.append(weapon)
        
        if(self.item != "Empty") {
            var item = Potion(name: self.item, lootId: String(user.getNextId()) + user.getEmail())
            loot.append(item)
            println("potion found")
        }
        
        if(user.addInventory(loot)) {
            return (true, user)
        } else {
            return (false, user)
        }
    }
}