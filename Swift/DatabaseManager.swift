//  Protocal to abstract networking

import Foundation

protocol DatabaseManager {
    func signUp(user: User)
    func login(username: String, password: String)
    func checkAutoSignIn() -> Bool
    func getUser() -> User
    func getUserByUsername(username: String) -> User
    func saveUser(user: User) -> Bool
    func saveUserLocation(location: CLLocation)
    func regenerateEnergy()
    func updateHome(home: Bool)
    func updateUser()
    func findChests(lat: Double, lng: Double, distance: Double)
    func removeLootFromServer(loot: Loot)
    func removeChestFromServer(chest: Chest)
    func getDiscoveredChests()
}