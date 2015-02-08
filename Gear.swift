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
    private let damage = 1
    private let accuracy = 0
    private let ranged = false
    private let gold = false
    
    init(name: String, gold: Bool, quantity: Int) {
        self.gold = gold
        
        if name == BOW || name == GBOW {
            self.type = TWOHAND
            self.ranged = true
            self.accuracy = 80
        } else if name == TSWORD || name == GTSWORD {
            self.type = ONEHAND
            self.accuracy = 50
        } else if name == SWORD || name == GSWORD {
            self.type = ONEHAND
            self.accuracy = 85
        } else if name == DAGGER || name == GDAGGER {
            self.type = ONEHAND
            self.accuracy = 75
        } else if name == AXE || name == GAXE {
            self.type = TWOHAND
            self.accuracy = 99
        } else if name == MACE || name == GMACE {
            self.type = ONEHAND
            self.accuracy = 95
        } else if name == SPEAR || name == GSPEAR {
            self.type = ONEHAND
            self.ranged = true
            self.accuracy = 60
        } else if name == STAFF || name == GSTAFF {
            self.type = ONEHAND
            self.ranged = true
            self.accuracy = 99
        } else if name == SSHIELD || name == GSSHIELD {
            self.type = ONEHANDARMOUR
            self.accuracy = 10
        } else if name == LSHIELD || name == GLSHIELD {
            self.type = ONEHANDARMOUR
            self.accuracy = 20
        } else if name == HELMET || name == GHELMET {
            self.type = HELMET
            self.accuracy = 10
        } else if name == BARMOUR || name == GBARMOUR {
            self.type = BARMOUR
            self.accuracy = 20
        }
        
        super.init(name: name, image: UIImage(contentsOfFile:name + ".png")!, quantity: quantity)
    }
    
    convenience init(parseWeapon: PFObject) {
        self.init(name: parseWeapon["name"] as String, gold: parseWeapon["gold"] as Bool, quantity: parseWeapon["quantity"] as Int)
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
    
    override func remove() { }
    
    override func delete() { }
}