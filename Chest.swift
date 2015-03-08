//
//  Chest.swift
//  Lootz
//
//  Created by Brayden Girard on 2015-01-18.
//  Copyright (c) 2015 Brayden Girard. All rights reserved.
//

import Foundation

class Chest {
    
    private let latitude: Double
    private let longitude: Double
    private let weapon: String
    private let weaponGold: Bool
    private let item: String
    private let gold: Int
    
    init(latitude: Double, longitude: Double, weapon: String, weaponGold: Bool, item:String, gold: Int) {
        self.latitude = latitude
        self.longitude = longitude
        self.weapon = weapon
        self.weaponGold = weaponGold
        self.item = item
        self.gold = gold
    }
    
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
    
    func getLoot() -> (success: Bool, user: User) {
        var loot = [Loot]()
        var weapon:Gear
        var user = DBFactory.execute().getUser()
        weapon = Gear(name: self.weapon, gold: self.weaponGold, lootId: String(user.getNextId()) + user.getEmail())
        
        loot.append(weapon)
        
        if(self.item != "Empty") {
            var item = Loot(name: self.item, imageName:self.item, lootId: String(user.getNextId()) + user.getEmail())
            loot.append(item)
        }
        
        if(user.addInventory(loot)) {
            return (true, user)
        } else {
            return (false, user)
        }
    }
}