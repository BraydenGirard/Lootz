//
//  Loot.swift
//  Lootz
//
//  Created by Brayden Girard on 2015-01-06.
//  Copyright (c) 2015 Brayden Girard. All rights reserved.
//

import Foundation

let UNKNOWN = "Uknown"
let TYPEGEAR = "Gear"
let TYPEPOTION = "Potion"
let GOLD = "Gold"
let CLARITYPOT = "Clarity_Potion"
let ENERGYPOT = "Energy_Potion"
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
let LSHIELD = "Shield"
let HELMET = "Helmet"
let BARMOUR = "Body_Armour"
let ONEHAND = "One_Hand"
let TWOHAND = "Two_Hand"
let ONEHANDARMOUR = "One_Hand_Armour"
let GOLDSUFFIX = "_Gold"


let DAMAGE = 25
let GOLDDAMAGE = 50

class Loot: NSObject {
    let name: String
    let image: UIImage
    let lootId: String
    
    init(name: String, imageName: String, lootId: String) {
        self.lootId = lootId
        self.name = name
        self.image = UIImage(named: imageName)!
    }
    
    func getImage() -> UIImage {
      return image
    }
    
    func getName() -> String {
        return name
    }
    
    func getId() -> String {
        return self.lootId
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
    
    func getClassType() -> String {
        return UNKNOWN
    }
    
    func use() { }
}