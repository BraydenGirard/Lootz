//
//  User.swift
//  Lootz
//
//  Created by Brayden Girard on 2014-12-08.
//  Copyright (c) 2014 Brayden Girard. All rights reserved.
//

import Foundation

let FULLHEALTH = 3
let FULLENERGY = 100
let FULLCLARITY = 100

class User {
    
    private let username: String
    private let email: String
    private let password: String
    private var health: Int
    private var energy: Int
    private var clarity: Int
    private var inventory: [Loot]
    private var equipment: [Gear]
    
    init() {
        self.username = UNKNOWN
        self.email = UNKNOWN
        self.password = UNKNOWN
        self.health = 0
        self.energy = 0
        self.clarity = 0
        self.inventory = [Loot]()
        self.equipment = [Gear]()
    }
    
    init(username: String, email: String, password: String, health: Int, energy: Int, clarity: Int, inventory: [Loot], equipment: [Gear]) {
        self.username = username
        self.email = email
        self.password = password
        self.health = health
        self.energy = energy
        self.clarity = clarity
        self.inventory = inventory
        self.equipment = equipment
    }
    
    convenience init(parseUser: PFObject) {
        self.init(username: parseUser["username"] as String, email: parseUser["email"] as String, password: parseUser["password"] as String, health: parseUser["health"] as Int, energy: parseUser["energy"] as Int, clarity: parseUser["clarity"] as Int, inventory: parseUser["inventory"] as [Loot], equipment: parseUser["equipment"] as [Gear])
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
    
    func setClarity(clarity: Int) {
        self.clarity = clarity
    }
    
    func restoreClarity() {
        self.clarity = FULLCLARITY
    }
    
    func getHitDamage() -> Int {
        return 0
    }
    
    func getHitChance() -> Int {
        return 0
    }
    
    func getBlockDamage() -> Int {
        return 0
    }
    
    func getBlockChance() -> Int {
        return 0
    }
    
    func addInventory(item: Loot) {
        //Add item to array if it does not already exist (check item names) else add 1 to quantity
    }
    
    func removeInventory(item: Loot) {
        //Remove item from array if only 1 exists (check item name and quantity) else remove 1 from quantity
    }
    
    func getInventory() -> [Loot] {
        return inventory
    }
    
    func equipGear(item: Gear) {
        //Check to see if already wearing to much of that type of gear
    }
    
    func removeGear(item: Gear) {
        //Check to see if inventory has room
    }
    
    func getEquipment() -> [Loot] {
        return equipment
    }
}