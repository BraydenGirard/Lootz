//
//  User.swift
//  Lootz
//
//  Created by Brayden Girard on 2014-12-08.
//  Copyright (c) 2014 Brayden Girard. All rights reserved.
//

import Foundation

class User {
    
    enum UserClass {
        case Engineer, Miner, Herbalist
    }
    
    private var username: String?
    private var email: String?
    private var password: String?
    private var userClass: UserClass?
    
    init() {}
    
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
            if tempEmail.isEmpty {
                return (false, "email can not be empty")
            }
            email = tempEmail
           return (true, nil)
        }
        else {
            return (false, "must enter an email")
        }
    }
    
    func setPassword(input: String?) -> (success: Bool, error: String?) {
        if let tempPassword = input {
            if tempPassword.isEmpty {
                return (false, "password can not be empty")
            }
            password = tempPassword
            return (true, nil)
        }
        else {
            return (false, "must enter a password")
        }
    }
    
    func setUserClass(input: UserClass) -> (success: Bool, error: String?) {
        switch input {
            case .Engineer:
                userClass = UserClass.Engineer
            case .Miner:
                userClass = UserClass.Engineer
            case .Herbalist:
                userClass = UserClass.Engineer
            default:
                userClass = nil
        }
        
        return (true, nil)
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
    
    func getUserClass() -> UserClass {
        return userClass!
    }

}