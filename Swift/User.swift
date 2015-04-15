//  User model

import Foundation

//  MARK: User constants

let FULLHEALTH = 100
let FULLENERGY = 100
let FULLCLARITY = 100
let FULLINVENTORY = 16
let CHESTXP = 10
let KILLXP = 100
let SEARCHDISTANCE = 0.1
let BOOSTEDSEARCHDISTANCE = 0.3
let CARLETON = (lat: 45.386583, lng: -75.696123)

class User {
    
    private let username: String        //  Users username
    private let email: String           //  Users email address
    private let password: String        //  Users password (only used on initial signup and for login)
    private var gold: Int               //  The amount of gold a user has
    private var health: Int             //  A users health (must be greater than 0 to be alive)
    private var energy: Int             //  A users energy (used for looting chests)
    private var clarity: Int            //  A users clarity (used for added search distance)
    private var xp: Int                 //  A users experience (gained looting chests)
    private var inventory: [Loot]       //  A users inventory
    private var equipment: [Gear]       //  The items a user currently has equiped
    private var latHistory: [Double]    //  The users latitude locations discovered in the background
    private var lngHistory: [Double]    //  The users longitude locations discovered in the background
    private var currentId: Int          //  The current loot id seed for the user (increased with every new piece of loot)
    private var homeLat: Double         //  The users latitude of their home base
    private var homeLng: Double         //  The users longitude of their home base
    private var home: Bool              //  Is the user currently at home base
    
    //  MARK: User Initializers
    
    //  Initialize an empty user
    init() {
        self.username = UNKNOWN
        self.email = UNKNOWN
        self.password = UNKNOWN
        self.gold = 0
        self.health = FULLHEALTH
        self.energy = FULLENERGY
        self.clarity = FULLCLARITY
        self.xp = 0
        self.inventory = []
        self.equipment = []
        self.latHistory = []
        self.lngHistory = []
        self.currentId = 0
        self.homeLat = CARLETON.lat
        self.homeLng = CARLETON.lng
        self.home = false
    }
    
    //  Initialize a new user
    init(username: String, email: String, password: String) {
        self.username = username
        self.email = email
        self.password = password
        self.gold = 0
        self.health = FULLHEALTH
        self.energy = FULLENERGY
        self.clarity = FULLCLARITY
        self.xp = 0
        self.inventory = []
        self.equipment = []
        self.latHistory = []
        self.lngHistory = []
        self.currentId = 0
        self.homeLat = CARLETON.lat
        self.homeLng = CARLETON.lng
        self.home = false
    }
    
    //  Initialize a user
    init(username: String, email: String, password: String, gold: Int, health: Int, energy: Int, clarity: Int, xp: Int, inventory: [Loot], equipment: [Gear], latHistory: [Double], lngHistory: [Double], currentId: Int, homeLat: Double, homeLng: Double, home: Bool) {
        self.username = username
        self.email = email
        self.password = password
        self.gold = gold
        self.health = health
        self.energy = energy
        self.clarity = clarity
        self.xp = xp
        self.inventory = inventory
        self.equipment = equipment
        self.latHistory = latHistory
        self.lngHistory = lngHistory
        self.currentId = currentId
        self.homeLat = homeLat
        self.homeLng = homeLng
        self.home = home
    }
    
    //  MARK: User setters and getters
    
    func getNextId() -> Int {
        self.currentId = self.currentId + 1;
        return self.currentId;
    }
    
    func getId() -> Int {
        return self.currentId
    }
    
    func getUsername() -> String {
        return username
    }
    
    func getEmail() -> String {
        return email
    }
    
    func getPassword() -> String {
        return password
    }
    
    func getGold() -> Int {
        return gold
    }
    
    func setGold(gold: Int) {
        self.gold = gold
    }
    
    func addGold(gold: Int) {
        self.gold = self.gold + gold;
    }
    
    func getHealth() -> Int {
        return health
    }
    
    func setHealth(health: Int) {
        self.health = health
    }
    
    func restoreHealth() {
        self.health = FULLHEALTH
    }
    
    func getEnergy() -> Int {
        return energy
    }
    
    func setEnergy(energy: Int) {
        self.energy = energy;
    }
    
    func restoreEnergy() {
        self.energy = FULLENERGY
    }
    
    func getClarity() -> Int {
        return clarity
    }
    
    func getClarityDistance() -> Double {
        if(clarity != 0) {
            clarity = clarity - 25
            return BOOSTEDSEARCHDISTANCE
        }
        else {
            return SEARCHDISTANCE
        }
    }
    
    func setClarity(clarity: Int) {
        self.clarity = clarity
    }
    
    func restoreClarity() {
        self.clarity = FULLCLARITY
    }
    
    func getXP() -> Int{
        return self.xp
    }
    
    func gainXP(xp: Int) {
        self.xp = self.xp + xp
    }
    
    func getHomeLat() -> Double {
        return homeLat
    }
    
    func getHomeLng() -> Double {
        return homeLng
    }
    
    func setHomeLat(homeLat: Double) {
        self.homeLat = homeLat
    }
    
    func setHomeLng(homeLng: Double) {
        self.homeLng = homeLng
    }
    
    func isHome() -> Bool {
        return home
    }
    
    func setHome(home: Bool) {
        self.home = home
    }
    
    func getHitDamage() -> Int {
        var damage = 0
        
        for e in self.equipment {
            if(e.getType() == ONEHAND || e.getType() == TWOHAND) {
                damage += e.getDamage()
            }
        }
        return damage;
    }
    
    func getHitChance() -> Int {
        var chance = 0
        var tempChance = 0
        var isDual = false
        
        for e in self.equipment {
            if(e.getType() == ONEHAND || e.getType() == TWOHAND) {
                if(!isDual) {
                    chance += e.getAccuracy()
                    isDual = true
                }
                else {
                    if(e.getAccuracy() > chance) {
                        chance = e.getAccuracy()
                    }
                }
            }
        }
        return chance;
    }
    
    func getBlockDamage() -> Int {
        var damage = 0
        
        for e in self.equipment {
            if(e.getType() == ONEHANDARMOUR || e.getType() == HELMET || e.getType() == BARMOUR){
                damage += e.getDamage()
            }
        }
        return damage;
    }
    
    func getBlockChance() -> Int {
        var chance = 0
        
        for e in self.equipment {
            if(e.getType() == ONEHANDARMOUR || e.getType() == HELMET || e.getType() == BARMOUR){
                chance += e.getAccuracy()
            }
        }
        return chance;
    }
    
    func getLvl() -> String {
        println(self.getHitChance())
        println(self.getBlockChance())
        var lvl = self.getHitChance() + self.getBlockChance()

        return String(lvl)
    }
    
    //  Returns true if item is added
    //  Returns false if item cannot be added
    //  because inventory is full
    func addInventory(item: Loot) -> Bool {
        if(self.inventory.count < FULLINVENTORY) {
            self.inventory.append(item)
            return true
        }
        return false
    }
    
    //  Returns false if not enough room to add all items
    //  returns true if all items are added to inventory
    func addInventory(items: [Loot]) -> Bool {

        if(getInventory().count + items.count <= FULLINVENTORY) {
            for i in items {
                println("Adding item \(i.getName())")
                self.inventory.append(i)
            }
            return true
        } else {
            return false
        }
    }
    
    //  Removes the item from inventory if it exists
    func removeInventory(item: Loot) -> Bool {
        for var i=0; i<self.inventory.count; i++ {
            if(self.inventory[i].getId() == item.getId()) {
                self.inventory.removeAtIndex(i)
                DBFactory.execute().removeLootFromServer(item)
                return true
            }
        }
        return false
    }
    
    //  Removes item from inventory to equipment
    func equipFromInventory(item: Gear) -> Bool {
     
        for var i=0; i<self.inventory.count; i++ {
            if(self.inventory[i].getId() == item.getId()) {
                self.inventory.removeAtIndex(i)
                self.equipment.append(item)
                return true
            }
        }
        return false
    }
    
    
    
    func getInventory() -> [Loot] {
        return inventory
    }
    
    //  If room to equip returns true
    //  Else returns false and must remove equipment first
    func equipGear(item: Gear) -> Bool {
        if(self.equipmentCount(item.getType()) == 0) {
            //println("Equiping item")
            if(item.getType() == ONEHAND && self.equipmentCount(TWOHAND) == 0) {
                equipFromInventory(item)
                return true
            } else if(item.getType() == TWOHAND && self.equipmentCount(ONEHAND) == 0 && self.equipmentCount(ONEHANDARMOUR) == 0) {
                equipFromInventory(item)
                return true
            } else if(item.getType() == ONEHANDARMOUR && self.equipmentCount(TWOHAND) == 0 && self.equipmentCount(ONEHAND) < 2) {
                equipFromInventory(item)
                return true
            } else if(item.getType() == HELMET) {
                equipFromInventory(item)
                return true
            } else if(item.getType() == BARMOUR) {
                equipFromInventory(item)
                return true
            }
        }
        else if(self.equipmentCount(item.getType()) == 1){
            if(item.getType() == ONEHAND && self.equipmentCount(ONEHANDARMOUR) == 0) {
                equipFromInventory(item)
                return true
            }
        }
        return false
    }
    
    //  Returns true if inventory has room for gear
    func removeGear(gear: Loot) -> Bool {
        if(self.addInventory(gear)) {
            for var i=0; i<self.equipment.count; i++ {
                if(self.equipment[i].getId() == gear.getId()) {
                    self.equipment.removeAtIndex(i)
                }
            }
            return true
        } else {
            return false
        }
    }
    
    //  Returns how many of that item is equipped
    func equipmentCount(type: String) -> Int {
        var count = 0
        for var i=0; i<self.equipment.count; i++ {
            if(self.equipment[i].getType() == type) {
                count++
            }
        }
        return count
    }

    func getEquipment() -> [Gear] {
        return equipment
    }
    
    func getEquipment(type: String) -> Gear? {
        for tempItem in self.equipment {
            if(type == tempItem.getType()) {
                return tempItem;
            }
        }
        return nil
    }
    
    func isEquiped(gear: Gear) -> Bool {
        for tempGear in self.equipment {
            if(tempGear.getType() == gear.getType()) {
                return true
            }
        }
        return false
    }
    
    func getDualEquipment(type: String) -> [Loot]? {
        var weapons = [Loot]()
        for tempItem in self.equipment {
            if(type == tempItem.getType()) {
                weapons.append(tempItem)
            }
        }
        
        if(weapons.count > 0) {
            return weapons
        } else {
            return nil
        }
    }
    
    func getLocationHistory() -> (latitudes: [Double], longitudes: [Double]) {
        return (latitudes: latHistory, longitudes: lngHistory)
    }
    
    func setLocationtHistory(locationTuple: (latitudes: [Double], longitudes: [Double])) {
        self.latHistory = locationTuple.latitudes
        self.lngHistory = locationTuple.longitudes
    }
    
    func getLatHistory() -> [Double] {
        return latHistory
    }
    
    func getLngHistory() -> [Double] {
        return lngHistory
    }
    
    func setLatHistory(latHistory: [Double]) {
        self.latHistory = latHistory
    }
    
    func setLngHistory(lngHistory: [Double]) {
        self.lngHistory = lngHistory
    }
  
}