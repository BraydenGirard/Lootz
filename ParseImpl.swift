//
//  Parse.swift
//  Lootz
//
//  Created by Brayden Girard on 2014-12-08.
//  Copyright (c) 2014 Brayden Girard. All rights reserved.
//

import Foundation

class ParseImpl: DatabaseManager {
    
    func saveUser(user: User) -> Bool {
        return true;
    }
    
    func saveNewUser(newUser:User) {
       
        var user = PFUser()
        user.username = newUser.getUsername()
        user.password = newUser.getPassword()
        user.email = newUser.getEmail()
            
        user.signUpInBackgroundWithBlock {
            (succeeded: Bool!, error: NSError!) -> Void in
            if error == nil {
                // User signed up succesfully
                println("User created in parse")
                NSNotificationCenter.defaultCenter().postNotificationName("signUpSuccess", object: user)
            } else {
                let errorString = error.userInfo!["error"] as NSString
                // Show the errorString somewhere and let the user try again.
                println(errorString)
                NSNotificationCenter.defaultCenter().postNotificationName("signUpFail", object: errorString)
            }
        }
        
    }
    
    func signIn() -> Bool {
        return false;
    }
    
    func checkAutoSignIn() -> Bool {
        return true;
    }
}