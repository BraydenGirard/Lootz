//
//  Parse.swift
//  Lootz
//
//  Created by Brayden Girard on 2014-12-08.
//  Copyright (c) 2014 Brayden Girard. All rights reserved.
//

import Foundation

class ParseImpl: DatabaseManager {
    
    func signUp(user: User) {
       
        var parseUser = self.convertUser(user)
            
        parseUser.signUpInBackgroundWithBlock {
            (succeeded: Bool!, error: NSError!) -> Void in
            if error == nil {
                NSNotificationCenter.defaultCenter().postNotificationName("signUpSuccess", object: nil)
            } else {
                let errorString = error.userInfo!["error"] as NSString
                println(errorString)
                
                NSNotificationCenter.defaultCenter().postNotificationName("signUpFail", object: nil)
            }
        }
    }
    
    func login(username: String, password: String) {
        PFUser.logInWithUsernameInBackground(username, password:password) {
            (user: PFUser!, error: NSError!) -> Void in
            if user != nil {
                NSNotificationCenter.defaultCenter().postNotificationName("loginSuccess", object: nil)
            } else {
                let errorString = error.userInfo!["error"] as NSString
                println(errorString)
                
                NSNotificationCenter.defaultCenter().postNotificationName("loginFail", object: nil)
            }
        }
    }
    
    func checkAutoSignIn() -> Bool {
        var currentUser = PFUser.currentUser()
        if currentUser != nil {
            return true
        } else {
            return false
        }
    }
    
    func getUser() -> User {
        var currentUser = PFUser.currentUser()
        if currentUser != nil {
            var user = User(parseUser: currentUser)
            return user
        } else {
            NSNotificationCenter.defaultCenter().postNotificationName("exit", object: nil)
            var user = User()
            return user
        }
    }
    
    func getUserByUsername(username: String) -> User {
        var query = PFUser.query()
        query.whereKey("username", equalTo:username)
        return User(parseUser: query.getFirstObject())
    }

    func saveUser(user: User) -> Bool {
        self.convertUser(user).saveEventually()
        return true
    }
    
    func convertUser(user: User) -> PFUser {
        var parseUser = PFUser()
        parseUser.username = user.getUsername()
        parseUser.email = user.getEmail()
        parseUser.password = user.getPassword()
        parseUser["health"] = user.getHealth()
        parseUser["energy"] = user.getEnergy()
        parseUser["clarity"] = user.getClarity()
        parseUser["inventory"] = user.getInventory()
        parseUser["equipment"] = user.getEquipment()
        
        return parseUser
    }
}