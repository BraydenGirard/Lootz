//
//  Loot.swift
//  Lootz
//
//  Created by Brayden Girard on 2015-01-06.
//  Copyright (c) 2015 Brayden Girard. All rights reserved.
//

import Foundation

class Loot {
    private var image: UIImage = UIImage(named:"default.png")!
    private var rarity: Int = 0
    private var name: String = "Uknown"
    
    func getImage() -> UIImage {
      return image
    }
    
    func getRarity() -> Int {
        return rarity
    }
    
    func getName() -> String {
        return name
    }
    
    func getPrettyName() -> String {
        var splitName = name.componentsSeparatedByString("_")
        var prettyName: String = ""
        for i in 0...splitName.count - 1 {
            if i != splitName.count - 1 {
                prettyName += splitName[i] + " "
            }
            else {
                prettyName += splitName[i]
            }
        }
        return prettyName;
    }
    
}