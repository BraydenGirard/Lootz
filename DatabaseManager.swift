//
//  DatabaseManager.swift
//  Lootz
//
//  Created by Brayden Girard on 2014-12-08.
//  Copyright (c) 2014 Brayden Girard. All rights reserved.
//

import Foundation

protocol DatabaseManager {
    func saveNewUser(User)
    func signIn() -> Bool
    func checkAutoSignIn() -> Bool
    func saveUser(User) -> Bool
}