//Rarity is diveded by 2 if weapon is gold
//If weapon is ranged, allowed to attack the last looter
//If the weapon is not ranged, allowed to attack the last looter if within 5 minutes of loot time
//Weapon damage is doubled if gold for offensive weapon
//Weapon block amount (damage) is doubled if gold for defensive weapon
//Accuracy is chance of hit calculated by 100 / accuracy for offensive weapons
//Accuracy is chance of block calculated by 100 / accuracy for defensive weapons

import Foundation

class Gear: Loot {
    
    private let type: String
    private let damage: Int
    private let accuracy: Int
    private let ranged: Bool
    private let gold: Bool
    
    init(name: String, gold: Bool, lootId: String) {
        self.gold = gold
        
        if name == BOW {
            self.type = TWOHAND
            self.ranged = true
            self.accuracy = 80
        } else if name == TSWORD {
            self.type = ONEHAND
            self.accuracy = 50
            self.ranged = false
        } else if name == SWORD {
            self.type = ONEHAND
            self.accuracy = 85
            self.ranged = false
        } else if name == DAGGER {
            self.type = ONEHAND
            self.accuracy = 75
            self.ranged = false
        } else if name == AXE {
            self.type = TWOHAND
            self.accuracy = 99
            self.ranged = false
        } else if name == MACE {
            self.type = ONEHAND
            self.accuracy = 95
            self.ranged = false
        } else if name == SPEAR {
            self.type = ONEHAND
            self.ranged = true
            self.accuracy = 60
        } else if name == STAFF {
            self.type = ONEHAND
            self.ranged = true
            self.accuracy = 99
        } else if name == SSHIELD {
            self.type = ONEHANDARMOUR
            self.accuracy = 10
            self.ranged = false
        } else if name == LSHIELD {
            self.type = ONEHANDARMOUR
            self.accuracy = 20
            self.ranged = false
        } else if name == HELMET {
            self.type = HELMET
            self.accuracy = 10
            self.ranged = false
        } else if name == BARMOUR {
            self.type = BARMOUR
            self.accuracy = 20
            self.ranged = false
        } else {
            self.type = UNKNOWN
            self.accuracy = 0
            self.ranged = false
        }

        if(self.gold) {
            damage = GOLDDAMAGE
            super.init(name: name, imageName: name + GOLDSUFFIX, lootId: lootId)
        } else {
            damage = DAMAGE
            super.init(name: name, imageName: name, lootId: lootId)
        }
    }
    
    func getType() -> String {
        return self.type
    }
    
    func getDamage() -> Int {
        return self.damage
    }
    
    func getAccuracy() -> Int {
        return self.accuracy
    }
    
    func isRanged() -> Bool {
        return self.ranged
    }
    
    func isGold() -> Bool {
        return self.gold
    }
    
    override func use() {
        
    }
    
    override func getClassType() -> String {
        return TYPEGEAR
    }
}