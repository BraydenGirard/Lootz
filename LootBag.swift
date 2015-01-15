//
//  LootBag.swift
//  Lootz
//
//  Created by Brayden Girard on 2015-01-06.
//  Copyright (c) 2015 Brayden Girard. All rights reserved.
//

import Foundation

class LootBag: Loot {
    
    private let items: [Loot]
    
    init(items: [Loot]) {
        self.items = items
        super.init(name: BAG, image: UIImage(contentsOfFile:BAG + ".png")!, rarity: BAGRARE, quantity: MAXBAG)
    }
    
    convenience init(parseBag: PFObject) {
        self.init(items: parseBag["bag"] as [Loot])
    }
    
    func openBag(user: User) {
        user.addInventory(<#item: Loot#>)
    }
    
    func giveBag(username: String) {
        
    }
}