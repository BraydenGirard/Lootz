//
//  Potion.swift
//  Lootz
//
//  Created by Brayden Girard on 2015-01-06.
//  Copyright (c) 2015 Brayden Girard. All rights reserved.
//

import Foundation

class Potion: Loot {
    init(name: String, lootId: String) {
        super.init(name: name, imageName: name, lootId:lootId)
    }
    
    override func use() { }
    
    override func getClassType() -> String {
        return TYPEPOTION
    }
}