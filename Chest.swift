//
//  Chest.swift
//  Lootz
//
//  Created by Brayden Girard on 2015-01-18.
//  Copyright (c) 2015 Brayden Girard. All rights reserved.
//

import Foundation

class Chest {
    
    private let latitude: Double
    private let longitude: Double
    private let lootz: [Loot]
    
    init(lootz: [Loot], latitude: Double, longitude: Double) {
        self.latitude = latitude
        self.longitude = longitude
        self.lootz = lootz
    }
    
    convenience init(parseChest: PFObject) {
        self.init(lootz: parseChest["lootz"] as [Loot], latitude: parseChest["latitude"] as Double, longitude: parseChest["longitude"] as Double)
    }
    
    func getLatitude() -> Double {
        return self.latitude
    }
    
    func getLongitude() -> Double {
        return self.longitude
    }
    
    func getLootz() -> [Loot] {
        return self.lootz
    }
}