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
    
    func setUsername(username: String) -> (success: Bool, error: String?) {
        if username.isEmpty {
            return (false, "username can not be empty")
        }
        if countElements(username) > 20 {
            return (false, "username is to long (max 20 characters)")
        }
        if countElements(username) < 4 {
            return (false, "username is to short (min 4 characters)")
        }
        
        let letters = NSCharacterSet.letterCharacterSet()
        let digits = NSCharacterSet.decimalDigitCharacterSet()
        
        for uni in username.unicodeScalars {
            if !letters.longCharacterIsMember(uni.value) || !digits.longCharacterIsMember(uni.value) {
                return (false, "username is invalid (can only contain letters and numbers)")
            }
        }
        
        return (true, nil)
    }
    
    func getUsername() -> String {
        return username!
    }

}