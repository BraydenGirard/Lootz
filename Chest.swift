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
    
    convenience init(parseChest: PFObject) {
        let geoLocation = parseChest["location"] as PFGeoPoint
        self.init(latitude: geoLocation.latitude, longitude: geoLocation.longitude, weapon: parseChest["weapon"] as String, weaponGold: parseChest["weaponGold"] as Bool, item: parseChest["item"] as String, gold: parseChest["gold"] as Int)
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
    
    func getLoot() -> [Loot] {
        var loot = [Loot]()
        var weapon:Gear
        if(self.weaponGold) {
            weapon = Gear(name: self.weapon + "_Gold", gold: self.weaponGold, quantity: 1)
        } else {
            weapon = Gear(name: self.weapon, gold: self.weaponGold, quantity: 1)
        }
        
        loot.append(weapon)
        
        if(self.item != "Empty") {
            var item = Loot(name: self.item, image: UIImage(named:self.item)!, quantity: 1)
            loot.append(item)
        }
        
        return loot
    }
}