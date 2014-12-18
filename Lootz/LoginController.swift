//
//  ViewController.swift
//  Lootz
//
//  Created by Brayden Girard on 2014-11-27.
//  Copyright (c) 2014 Brayden Girard. All rights reserved.
//

import UIKit

class LoginController: UIViewController {
    
    var offset: CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
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
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        self.view.endEditing(true)
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
}

