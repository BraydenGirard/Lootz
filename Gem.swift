//
//  Gem.swift
//  Lootz
//
//  Created by Brayden Girard on 2015-01-13.
//  Copyright (c) 2015 Brayden Girard. All rights reserved.
//

import Foundation

class Gem: Loot {
    init(name: String, quantity: Int) {
        super.init(name: name, image: UIImage(contentsOfFile:name + ".png")!, rarity: POTRARE, quantity: quantity)
    }
}