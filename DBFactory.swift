//
//  DatabaseFactory.swift
//  Lootz
//
//  Created by Brayden Girard on 2014-12-08.
//  Copyright (c) 2014 Brayden Girard. All rights reserved.
//

import Foundation

class DBFactory {
    class func execute() -> DatabaseManager? {
        return ParseImpl()
    }
}