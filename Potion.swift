//
//  Potion.swift
//  Lootz
//
//  Created by Brayden Girard on 2015-01-06.
//  Copyright (c) 2015 Brayden Girard. All rights reserved.
//

import Foundation

class Potion: Loot {
    init(name: String, id: Int) {
        super.init(name: name, imageName: name, id:id)
    }
    
    override func use() { }
    
    override func getClassType() -> String {
        return TYPEPOTION
    }
}