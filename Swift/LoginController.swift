//
//  ViewController.swift
//  Lootz
//
//  Created by Brayden Girard on 2014-11-27.
//  Copyright (c) 2014 Brayden Girard. All rights reserved.
//

import UIKit

class LoginController: UIViewController, UITextFieldDelegate {
    
    var offset: CGFloat = 0
    let notificationCenter = NSNotificationCenter.defaultCenter()
    
    @IBOutlet var usernameText: UITextField!
    @IBOutlet var passwordText: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        usernameText.delegate = self
        passwordText.delegate = self
        notificationCenter.addObserver(self, selector: "loginFail:", name: "loginFail", object: nil)
        notificationCenter.addObserver(self, selector: "loginSuccess:", name: "loginSuccess", object: nil)

        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.registerForKeyboardNotifications()
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        NSNotificationCenter.defaultCenter().removeObserver(self)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        self.view.endEditing(true)
    }
    
    @IBAction func loginButtonPushed(sender: UIButton) {
        if let error = checkLogin(usernameText.text, password: passwordText.text) {
            var alert = UIAlertController(title: "Error", message: error, preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Try again", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
        else {
            DBFactory.execute().login(usernameText.text!, password: passwordText.text!)
        }

    }
    
    func loginFail(notification: NSNotification) {
        println("Failed login")
        var alert = UIAlertController(title: "Error", message: "Incorrect username or password", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Error", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func loginSuccess(notification: NSNotification) {
        println("Successful login")
        self.performSegueWithIdentifier("loginSegue", sender: nil)
    }
    
    
    //MARK: - Keyboard Management Methods
    
    // Call this method somewhere in your view controller setup code.
    func registerForKeyboardNotifications() {
        let notificationCenter = NSNotificationCenter.defaultCenter()
        notificationCenter.addObserver(self,
            selector: "keyboardWillBeShown:",
            name: UIKeyboardWillShowNotification,
            object: nil)
        notificationCenter.addObserver(self,
            selector: "keyboardWillBeHidden:",
            name: UIKeyboardWillHideNotification,
            object: nil)
    }
    
    func keyboardWillBeShown(sender: NSNotification) {
        if(offset == 0) {
            offset = 100
            self.view.frame.origin.y -= offset
        }
    }
    func keyboardWillBeHidden(sender: NSNotification) {
        if(offset == 100) {
            self.view.frame.origin.y += offset
            offset = 0
        }
    }
    
    //User validation
    
    func checkUsername(input: String?) -> String? {
        if let tempUsername = input {
            if tempUsername.isEmpty {
                return "username can not be empty"
            }
            if count(tempUsername) > 20 {
                return "username is to long (max 20 characters)"
            }
            if count(tempUsername) < 4 {
                return "username is to short (min 4 characters)"
            }
            
            let letters = NSCharacterSet.letterCharacterSet()
            let digits = NSCharacterSet.decimalDigitCharacterSet()
            
            for uni in tempUsername.unicodeScalars {
                if !letters.longCharacterIsMember(uni.value) && !digits.longCharacterIsMember(uni.value) {
                    return "username is invalid (can only contain letters and numbers)"
                }
            }
            return nil
        }
        else {
            return "must enter a username"
        }
    }
    
    func checkPassword(input: String?) -> String? {
        if let tempPassword = input {
            if tempPassword.isEmpty {
                return "password can not be empty"
            }
            return nil
        }
        else {
            return "must enter a password"
        }
    }
    
    func checkLogin(username: String?, password: String?) -> String? {
        if let result = checkUsername(username) {
            return result
        }
        if let result = checkPassword(password) {
            return result
        }
        return nil
    }
}

