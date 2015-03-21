//
//  DatabaseManager.swift
//  Lootz
//
//  Created by Brayden Girard on 2014-12-08.
//  Copyright (c) 2014 Brayden Girard. All rights reserved.
//

import Foundation

protocol DatabaseManager {
    func signUp(user: User)
    func login(username: String, password: String)
    func checkAutoSignIn() -> Bool
    func getUser() -> User
    func getUserByUsername(username: String) -> User
    func saveUser(user: User) -> Bool
    func saveUserLocation(location: CLLocation)
    func updateUser()
    func findChests(lat: Double, lng: Double, distance: Double)
    func removeLootFromServer(loot: Loot)
    func removeChestFromServer(chest: Chest)
}