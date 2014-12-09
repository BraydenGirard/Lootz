//
//  SignupController.swift
//  Lootz
//
//  Created by Brayden Girard on 2014-12-05.
//  Copyright (c) 2014 Brayden Girard. All rights reserved.
//

import UIKit

class SignupController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var backButton: UIButton!
    @IBOutlet var usernameText: UITextField!
    @IBOutlet var emailText: UITextField!
    @IBOutlet var passwordText: UITextField!
    
    var offset:CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        usernameText.delegate = self;
        emailText.delegate = self;
        passwordText.delegate = self;
        
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backPushed(sender : UIButton) {
       dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        self.view.endEditing(true)
    }
    
    //MARK: - UITextField Delegate Methods
    
    func textFieldDidBeginEditing(textField: UITextField!) {
        if(textField.tag == 1) {
            offset = 75
        } else if(textField.tag == 2) {
            offset = 100
        } else if(textField.tag == 3) {
            offset = 110
        }
        self.view.frame.origin.y -= offset
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        self.view.frame.origin.y += offset
        offset = 0
    }
    
}