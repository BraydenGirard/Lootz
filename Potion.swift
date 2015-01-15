//
//  Potion.swift
//  Lootz
//
//  Created by Brayden Girard on 2015-01-06.
//  Copyright (c) 2015 Brayden Girard. All rights reserved.
//

import Foundation

class Potion: Loot {
    init(name: String, quantity: Int) {
        super.init(name: name, image: UIImage(contentsOfFile:name + ".png")!, rarity: POTRARE, quantity: quantity)
    }
}