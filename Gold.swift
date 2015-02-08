//
//  Gold.swift
//  Lootz
//
//  Created by Brayden Girard on 2015-01-06.
//  Copyright (c) 2015 Brayden Girard. All rights reserved.
//

import Foundation

class Gold: Loot {
    init(quantity: Int) {
        super.init(name: GOLD, image: UIImage(contentsOfFile:GOLD + ".png")!, quantity: quantity)
    }
    
    override func use() { }
    
    override func remove() { }
    
    override func delete() { }
}