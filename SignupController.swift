//
//  SignupController.swift
//  Lootz
//
//  Created by Brayden Girard on 2014-12-05.
//  Copyright (c) 2014 Brayden Girard. All rights reserved.
//

import UIKit

class SignupController: UIViewController {
    
    @IBOutlet var encryptButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
    
}