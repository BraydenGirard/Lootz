//
//  Loot.swift
//  Lootz
//
//  Created by Brayden Girard on 2015-01-06.
//  Copyright (c) 2015 Brayden Girard. All rights reserved.
//

import Foundation

let UNKNOWN = "Uknown"
let MAP = "Map"
let BOUNTY = "Bounty"
let BAG = "Loot_Bag"
let GOLD = "Gold"
let EMERALD = "Emerald"
let SAPHIRE = "Saphire"
let RUBY = "Ruby"
let CLARITYPOT = "Clarity_Potion"
let ENERGYPOT = "Enerygy_Potion"
let HEALTHPOT = "Health_Potion"
let BOW = "Bow"
let TSWORD = "Toy_Sword"
let SWORD = "Sword"
let DAGGER = "Dagger"
let AXE = "Axe"
let MACE = "Mace"
let SPEAR = "Spear"
let STAFF = "Staff"
let SSHIELD = "Small_Shield"
let LSHIELD = "Large_Shield"
let HELMET = "Helmet"
let BARMOUR = "Body_Armour"
let GOLDPREFIX = "Gold "
let ONEHAND = "One_Hand"
let TWOHAND = "Two_Hand"
let ONEHANDARMOUR = "One_Hand_Armour"

let DAMAGE = 1
let GDAMAGE = 2
let POTRARE = 5
let MAPRARE = 2
let BAGRARE = 5
let MAXBAG = 1
let BOUNTYRARE = 10
let MAXBOUNTY = 1
let GOLDRARE = 100

class Loot {
    let name = UNKNOWN
    let image =  UIImage(contentsOfFile: "default.png")!
    let rarity = 0
    var quantity = 0
    
    init(name: String, image: UIImage, rarity: Int, quantity: Int) {
        self.name = name
        self.image = image
        self.rarity = rarity
        self.quantity = quantity
    }
    
    init() {
        
    }
    
    func getImage() -> UIImage {
      return image
    }
    
    func getRarity() -> Int {
        return rarity
    }
    
    func getName() -> String {
        return name
    }
    
    func getPrettyName() -> String {
        var splitName = name.componentsSeparatedByString("_")
        var prettyName: String = ""
        for i in 0...splitName.count - 1 {
            if i != splitName.count - 1 {
                prettyName += splitName[i] + " "
            }
            else {
                prettyName += splitName[i]
            }
        }
        return prettyName;
    }
    
    func getQuantity() -> Int {
        return self.quantity
    }
    
    func setQuantity(quantity: Int) {
        self.quantity = quantity
    }
    
    func use() { }
    
    func remove() { }
    
    func delete() { }
    
}