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

    private let damage = 1
    private let accuracy = 0
    private let isRanged = false
    private let isGold = false
    
    init(name: String, isGold: Bool, quantity: Int) {
        self.isGold = isGold
        var rareMod = 1
        var rarity = 0
        if isGold {
            damage = 2
            rareMod = 2
        }
        
        if name == BOW {
            self.isRanged = true
            self.accuracy = 80
            rarity = 20
        } else if name == TSWORD {
            self.accuracy = 50
            rarity = 50
        } else if name == SWORD {
            self.accuracy = 85
            rarity = 15
        } else if name == DAGGER {
            self.accuracy = 75
            rarity = 25
        } else if name == AXE {
            self.accuracy = 99
            rarity = 1
        } else if name == MACE {
            self.accuracy = 95
            rarity = 5
        } else if name == SPEAR {
            self.isRanged = true
            self.accuracy = 60
            rarity = 40
        } else if name == STAFF {
            self.isRanged = true
            self.accuracy = 99
            rarity = 1
        } else if name == SSHIELD {
            self.accuracy = 10
            rarity = 10
        } else if name == LSHIELD {
            self.accuracy = 20
            rarity = 5
        } else if name == HELMET {
            self.accuracy = 10
            rarity = 10
        } else if name == ARMOUR {
            self.accuracy = 20
            rarity = 5
        }
        
        super.init(name: name, image: UIImage(contentsOfFile:name + ".png")!, rarity: rarity/rareMod, quantity: quantity)
    }
    
    convenience init(parseWeapon: PFObject) {
        self.init(name: parseWeapon["name"] as String, isGold: parseWeapon["isGold"] as Bool, quantity: parseWeapon["quantity"] as Int)
    }
    
    override func getPrettyName() -> String {
        var prettyName = ""
        if isGold {
            prettyName = GOLDPREFIX + super.getPrettyName();
        }
        return prettyName;
    }
}