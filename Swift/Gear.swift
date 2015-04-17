//  Subclass of Loot - Gear is equipable loot

import Foundation

class Gear: Loot {
    
    private let type = UNKNOWN      //  Determines location gear can be equiped
    private let damage = DAMAGE     //  The amount of damage the gear does in combat
    private let accuracy = 0        //  The accuracy bonus given by the gear in combat
    private let ranged = false      //  Is the gear is ranged
    private let gold = false        //  Is the gear gold
    
    //  Initialize gear based on its name
    init(name: String, gold: Bool, lootId: String) {
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
            super.init(name: name, imageName: name + GOLDSUFFIX, lootId: lootId)
        } else {
            super.init(name: name, imageName: name, lootId: lootId)
        }
    }
    
    //  MARK: Gear getters
    
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
}