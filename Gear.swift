//Rarity is diveded by 2 if weapon is gold
//If weapon is ranged, allowed to attack the last looter
//If the weapon is not ranged, allowed to attack the last looter if within 5 minutes of loot time
//Weapon damage is doubled if gold for offensive weapon
//Weapon block amount (damage) is doubled if gold for defensive weapon
//Accuracy is chance of hit calculated by 100 / accuracy for offensive weapons
//Accuracy is chance of block calculated by 100 / accuracy for defensive weapons

import Foundation

class Gear: Loot {
    
    private let type = UNKNOWN
    private let damage = DAMAGE
    private let accuracy = 0
    private let ranged = false
    private let gold = false
    
    init(name: String, gold: Bool, id: Int) {
        self.gold = gold
        
        if name == BOW {
            self.type = TWOHAND
            self.ranged = true
            self.accuracy = 80
        } else if name == TSWORD {
            self.type = ONEHAND
            self.accuracy = 50
        } else if name == SWORD {
            self.type = ONEHAND
            self.accuracy = 85
        } else if name == DAGGER {
            self.type = ONEHAND
            self.accuracy = 75
        } else if name == AXE {
            self.type = TWOHAND
            self.accuracy = 99
        } else if name == MACE {
            self.type = ONEHAND
            self.accuracy = 95
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
        } else if name == LSHIELD {
            self.type = ONEHANDARMOUR
            self.accuracy = 20
        } else if name == HELMET {
            self.type = HELMET
            self.accuracy = 10
        } else if name == BARMOUR {
            self.type = BARMOUR
            self.accuracy = 20
        }

        if(self.gold) {
            damage = GOLDDAMAGE
            super.init(name: name, imageName: name + GOLDSUFFIX, id: id)
        } else {
            super.init(name: name, imageName: name, id: id)
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
    
    override func use() { }
    
    override func getClassType() -> String {
        return TYPEGEAR
    }
}