//
//  User.swift
//  Lootz
//
//  Created by Brayden Girard on 2014-12-08.
//  Copyright (c) 2014 Brayden Girard. All rights reserved.
//

import Foundation

class User {
    
    private var username:String?
    private var email:String?
    private var password:String?
    
    init() {
        
    }
    
    func setUsername(input: String?) -> (success: Bool, error: String?) {
        
        if let tempUsername = input {
            if tempUsername.isEmpty {
                return (false, "username can not be empty")
            }
            if countElements(tempUsername) > 20 {
                return (false, "username is to long (max 20 characters)")
            }
            if countElements(tempUsername) < 4 {
                return (false, "username is to short (min 4 characters)")
            }
        
            let letters = NSCharacterSet.letterCharacterSet()
            let digits = NSCharacterSet.decimalDigitCharacterSet()
        
            for uni in tempUsername.unicodeScalars {
                if !letters.longCharacterIsMember(uni.value) && !digits.longCharacterIsMember(uni.value) {
                    return (false, "username is invalid (can only contain letters and numbers)")
                }
            }
        
            username = tempUsername
            
            return (true, nil)
        }
        else {
            return (false, "must enter a username")
        }
    }
    
    func setEmail(input: String?) -> (success: Bool, error: String?) {
        if let tempEmail = input {
            return (true, nil)
        }
        else {
            return (false, "must enter an email")
        }
    }
    
    func setPassword(input: String?) -> (success: Bool, error: String?) {
        if let tempPassword = input {
            return (true, nil)
        }
        else {
            return (false, "must enter a password")
        }
    }
    
    func getUsername() -> String {
        return username!
    }
    
    func getEmail() -> String {
        return email!;
    }
    
    func getPassword() -> String {
        return password!;
    }

}