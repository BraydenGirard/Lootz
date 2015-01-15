//
//  LootBag.swift
//  Lootz
//
//  Created by Brayden Girard on 2015-01-06.
//  Copyright (c) 2015 Brayden Girard. All rights reserved.
//

import Foundation

class LootBag: Loot {
    override init() {
        super.init(name: BAG, image: UIImage(contentsOfFile:BAG + ".png")!, rarity: BAGRARE, quantity: MAXBAG)
    }
}