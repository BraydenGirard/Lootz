//
//  Map.swift
//  Lootz
//
//  Created by Brayden Girard on 2015-01-06.
//  Copyright (c) 2015 Brayden Girard. All rights reserved.
//

import Foundation

class Map: Loot {
    override init() {
        super.init(name: MAP, image: UIImage(contentsOfFile:MAP + ".png")!, rarity: MAPRARE, quantity: MAXMAP)
    }
}