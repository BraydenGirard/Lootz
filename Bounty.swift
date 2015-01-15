//
//  Bounty.swift
//  Lootz
//
//  Created by Brayden Girard on 2015-01-06.
//  Copyright (c) 2015 Brayden Girard. All rights reserved.
//

import Foundation

class Bounty: Loot {
    
    override init() {
        super.init(name: BOUNTY, image: UIImage(contentsOfFile:BOUNTY + ".png")!, rarity: BOUNTYRARE, quantity: MAXBOUNTY)
    }
}