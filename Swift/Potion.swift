//  Subclass of Loot - Potions are consumable loot

import Foundation

class Potion: Loot {
    
    //  Initialize a potion
    init(name: String, lootId: String) {
        super.init(name: name, imageName: name, lootId:lootId)
    }
}