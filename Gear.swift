//Rarity is diveded by 2 if weapon is gold
//Rarity is the difference of 100 - accuracy for offensive weapon
//Rarity is the quotient of 100 / accuracy for defensive weapon
//If weapon is ranged, allowed to attack the last looter
//If the weapon is not ranged, allowed to attack the last looter if within 5 minutes of loot time
//Weapon damage is doubled if gold for offensive weapon
//Weapon block amount (damage) is doubled if gold for defensive weapon
//Accuracy is chance of hit calculated by 100 / accuracy for offensive weapons
//Accuracy is chance of block calculated by 100 / accuracy for defensive weapons

import Foundation

class Gear: Loot {
    
    private let type = UNKNOWN
    private let damage = 1
    private let accuracy = 0
    private let isRanged = false
    private let isGold = false
    
    init(type: String, isGold: Bool) {
        self.type = type
        self.isGold = isGold
        var rareMod = 1
        if isGold {
            damage = 2
            rareMod = 2
        }
        
        if type == BOW {
            self.isRanged = true
            self.accuracy = 80
            super.init(name: BOW, image: UIImage(contentsOfFile:BOW + ".png")!, rarity: 20/rareMod)
        } else if type == TSWORD {
            self.accuracy = 50
            super.init(name: TSWORD, image: UIImage(contentsOfFile:TSWORD + ".png")!, rarity: 50/rareMod)
        } else if type == SWORD {
            self.accuracy = 85
             super.init(name: SWORD, image: UIImage(contentsOfFile:SWORD + ".png")!, rarity: 15/rareMod)
        } else if type == DAGGER {
            self.accuracy = 75
            super.init(name: DAGGER, image: UIImage(contentsOfFile:DAGGER + ".png")!, rarity: 25/rareMod)
        } else if type == AXE {
            self.accuracy = 99
            super.init(name: AXE, image: UIImage(contentsOfFile:AXE + ".png")!, rarity: 1/rareMod)
        } else if type == MACE {
            self.accuracy = 95
            super.init(name: MACE, image: UIImage(contentsOfFile:MACE + ".png")!, rarity: 5/rareMod)
        } else if type == SPEAR {
            self.isRanged = true
            self.accuracy = 60
            super.init(name: SPEAR, image: UIImage(contentsOfFile:SPEAR + ".png")!, rarity: 40/rareMod)
        } else if type == STAFF {
            self.isRanged = true
            self.accuracy = 99
            super.init(name: STAFF, image: UIImage(contentsOfFile:STAFF + ".png")!, rarity: 1/rareMod)
        } else if type == SSHIELD {
            self.accuracy = 10
            super.init(name: SSHIELD, image: UIImage(contentsOfFile:SSHIELD + ".png")!, rarity: 10/rareMod)
        } else if type == LSHIELD {
            self.accuracy = 20
            super.init(name: LSHIELD, image: UIImage(contentsOfFile:LSHIELD + ".png")!, rarity: 5/rareMod)
        } else if type == HELMET {
            self.accuracy = 10
            super.init(name: HELMET, image: UIImage(contentsOfFile:HELMET + ".png")!, rarity: 10/rareMod)
        } else if type == ARMOUR {
            self.accuracy = 20
            super.init(name: ARMOUR, image: UIImage(contentsOfFile:ARMOUR + ".png")!, rarity: 5/rareMod)
        } else {
            super.init()
        }
    }
    
    convenience init(parseWeapon: PFObject) {
        self.init(type: parseWeapon["type"] as String, isGold: parseWeapon["isGold"] as Bool)
    }
    
    override func getPrettyName() -> String {
        var splitName = super.name.componentsSeparatedByString("_")
        var prettyName: String = ""
        if isGold {
            prettyName = GOLDPREFIX;
        }
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
    
}