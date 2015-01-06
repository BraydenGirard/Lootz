//
//  DatabaseManager.swift
//  Lootz
//
//  Created by Brayden Girard on 2014-12-08.
//  Copyright (c) 2014 Brayden Girard. All rights reserved.
//

import Foundation

protocol DatabaseManager {
    func signUp(username: String, email: String, password: String)
    func login(username: String, password: String)
    func checkAutoSignIn() -> Bool
    func saveUser(User) -> Bool
    func getUser() -> User
}