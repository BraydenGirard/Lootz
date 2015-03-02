//
//  LocationTuple.swift
//  Lootz
//
//  Created by Brayden Girard on 2015-03-01.
//  Copyright (c) 2015 Brayden Girard. All rights reserved.
//

import Foundation

class LocationTuple: NSObject {
    let tuple : (latitude: Double, longitude: Double)
    init(tuple : (latitude: Double, longitude: Double)) {
        self.tuple = tuple
    }
}