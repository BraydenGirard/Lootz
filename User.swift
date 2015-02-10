//
//  User.swift
//  Lootz
//
//  Created by Brayden Girard on 2014-12-08.
//  Copyright (c) 2014 Brayden Girard. All rights reserved.
//

import Foundation

let FULLHEALTH = 4
let FULLENERGY = 100
let FULLCLARITY = 100
let FULLINVENTORY = 20

class User {
    
    private let username: String
    private let email: String
    private let password: String
    private var health: Int
    private var energy: Int
    private var clarity: Int
    private var inventory: [Loot]
    private var equipment: [Gear]
    private var locationHistory: [CLLocation]
    
    init() {
        self.username = UNKNOWN
        self.email = UNKNOWN
        self.password = UNKNOWN
        self.health = FULLHEALTH
        self.energy = FULLENERGY
        self.clarity = FULLCLARITY
        self.inventory = [Loot]()
        self.equipment = [Gear]()
        self.locationHistory = [CLLocation]()
    }
    
    init(username: String, email: String, password: String) {
        self.username = username
        self.email = email
        self.password = password
        self.health = FULLHEALTH
        self.energy = FULLENERGY
        self.clarity = FULLCLARITY
        self.inventory = [Loot]()
        self.equipment = [Gear]()
        self.locationHistory = [CLLocation]()
    }
    
    init(username: String, email: String, password: String, health: Int, energy: Int, clarity: Int, inventory: [Loot], equipment: [Gear], locationHistory: [CLLocation]) {
        self.username = username
        self.email = email
        self.password = password
        self.health = health
        self.energy = energy
        self.clarity = clarity
        self.inventory = inventory
        self.equipment = equipment
        self.locationHistory = locationHistory
    }
    
    convenience init(parseUser: PFObject) {
        self.init(username: parseUser["username"] as String, email: parseUser["email"] as String, password: UNKNOWN, health: parseUser["health"] as Int, energy: parseUser["energy"] as Int, clarity: parseUser["clarity"] as Int, inventory: parseUser["inventory"] as [Loot], equipment: parseUser["equipment"] as [Gear], locationHistory: parseUser["locationHistory"] as [CLLocation])
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
            return 2
        }
        else {
            return 1
        }
    }
    
    func setClarity(clarity: Int) {
        self.clarity = clarity
    }
    
    func restoreClarity() {
        self.clarity = FULLCLARITY
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
            if(e.getType() != ONEHAND || e.getType() != TWOHAND) {
                damage += e.getDamage()
            }
        }
        return damage;
    }
    
    func getBlockChance() -> Int {
        var chance = 0
        
        for e in self.equipment {
            if(e.getType() != ONEHAND || e.getType() != TWOHAND) {
                chance += e.getAccuracy()
            }
        }
        return chance;
    }
    
    //Returns true if item is added
    //Returns false if item cannot be added
    //because it already exits and only allowed 1
    func addInventory(item: Loot) -> Bool {
        var uniqueItem = false
        
        var index = self.findInventoryIndex(item)
        
        if(index == -1) {
            uniqueItem = true
        }
        
        if(self.inventory.count < FULLINVENTORY || !uniqueItem) {
            var index = self.findInventoryIndex(item)
            
            if(index != -1) {
                self.inventory[index].quantity = self.inventory[index].quantity + item.getQuantity()
                return true
            }
            self.inventory.append(item)
            return true
        }
        return false
    }
    
    //Returns 0 if all items are added to the inventory
    //Returns number of items that must be cleared from inventory to make room
    //if inventory does not have enough room
    func addInventory(items: [Loot]) -> Int {
        var uniqueItems = 0
        
        for i in items {
            var index = self.findInventoryIndex(i)
            
            if(index == -1) {
                uniqueItems++
            }
        }
        
        if(getInventory().count + uniqueItems <= FULLINVENTORY) {
            for i in items {
                var index = self.findInventoryIndex(i)
                
                if(index != -1) {
                    self.inventory[index].quantity + i.getQuantity()
                }
                else {
                    self.inventory.append(i)
                }
            }
            return 0
        }
        else {
            return getInventory().count + uniqueItems - FULLINVENTORY
        }
    }
    
    //Removes the item from inventory if it exists
    //decreases quantity if multiple exist
    func removeInventory(item: Loot) {
        if(getInventory().count > 0) {
            var index = findInventoryIndex(item)
            if(index != -1) {
                var result = self.inventory[index].quantity - item.quantity
                if(result > 0) {
                    self.inventory[index].setQuantity(result)
                }
                else {
                    self.inventory[index].remove()
                }
            }
        }
    }
    
    //Removes one item from inventory to equipment
    func equipFromInventory(item: Gear) {
        if(getInventory().count > 0) {
            var index = findInventoryIndex(item)
            if(index != -1) {
                var result = self.inventory[index].quantity - 1
                if(result > 0) {
                    item.setQuantity(1)
                    self.equipment.append(item)
                    self.inventory[index].setQuantity(result)
                }
                else {
                    item.setQuantity(1)
                    self.equipment.append(item)
                    self.inventory[index].remove()
                }
            }
        }
    }
    
    
    
    func getInventory() -> [Loot] {
        return inventory
    }
    
    //If room to equip returns true
    //Else returns false and must remove equipment first
    func equipGear(item: Gear) -> Bool {
        if(self.equipmentCount(item.getType()) == 0) {
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
    
    //Returns true if inventory has room for gear
    func removeGear(gear: Gear) -> Bool {
        var index = 0
     
        for e in self.equipment {
            if(e.getName() == gear.getName()) {
                if(self.addInventory(self.equipment[index])) {
                    self.equipment[index].remove()
                    return true
                }
                else {
                    return false
                }
            }
            index++
        }
        return false
    }
    
    //Returns how many of that item are equipped
    func equipmentCount(type: String) -> Int {
        var count = 0
        for e in self.equipment {
            if(e.getType() == type) {
                count++
            }
        }
        return count
    }

    func getEquipment() -> [Loot] {
        return equipment
    }
    
    func getEquipment(type: String) -> Loot? {
        for tempItem in self.equipment {
            if(type == tempItem.getType()) {
                return tempItem;
            }
        }
        return nil
    }
    
    func getDualEquipment(type: String) -> [Loot]? {
        var index = 0
        var weapons = [Loot]()
        for tempItem in self.equipment {
            if(type == tempItem.getType()) {
                weapons[index] = tempItem;
                index++
            }
        }
        return nil
    }
    
    //Returns -1 if the item does not exist in inventory
    //Returns an index >= 0 if item exists in inventory
    func findInventoryIndex(item: Loot) -> Int {
        var index = 0
        for tempItem in self.inventory {
            if(item.name == tempItem.name) {
                return index
            }
            index++
        }
        return -1
    }
    
    func getLocationHistory() -> [CLLocation] {
        return locationHistory
    }
    
    func setLocationHistory(locationHistory: [CLLocation]) {
        self.locationHistory = locationHistory
    }
    
  
}