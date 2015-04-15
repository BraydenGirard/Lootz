// Login view controller

import UIKit

class LoginController: UIViewController, UITextFieldDelegate {
    
    var offset: CGFloat = 0
    
    let notificationCenter = NSNotificationCenter.defaultCenter()
    
    @IBOutlet var usernameText: UITextField!
    @IBOutlet var passwordText: UITextField!
    
    //  MARK: View management
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        usernameText.delegate = self
        passwordText.delegate = self
        
        //  Add notifications for asynchronous networking
        notificationCenter.addObserver(self, selector: "loginFail:", name: "loginFail", object: nil)
        notificationCenter.addObserver(self, selector: "loginSuccess:", name: "loginSuccess", object: nil)
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
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        self.view.endEditing(true)
    }
    
    //  MARK: Button Listeners
    
    //  Checks the login for valid characters and attempts to log the user in
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
    
    //  MARK: Notification listeners
    
    //  If the login fails display an alert with an error
    func loginFail(notification: NSNotification) {
        println("Failed login")
        var alert = UIAlertController(title: "Error", message: "Incorrect username or password", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Error", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    //  If the login is succesful push the main view
    func loginSuccess(notification: NSNotification) {
        println("Successful login")
        self.performSegueWithIdentifier("loginSegue", sender: nil)
    }
    
    
    //  MARK: Keyboard management methods
    
    // Registers notifications for adjusting view based on keyboard
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
    
    //  Move the view up by the height of the keyboard
    func keyboardWillBeShown(sender: NSNotification) {
        if(offset == 0) {
            offset = 100
            self.view.frame.origin.y -= offset
        }
    }
    
    //  Moves the view down by the height of the keyboard
    func keyboardWillBeHidden(sender: NSNotification) {
        if(offset == 100) {
            self.view.frame.origin.y += offset
            offset = 0
        }
    }
    
    //  MARK: User validation
    
    //  Checks for a valid username
    func checkUsername(input: String?) -> String? {
        if let tempUsername = input {
            if tempUsername.isEmpty {
                return "username can not be empty"
            }
            if countElements(tempUsername) > 20 {
                return "username is to long (max 20 characters)"
            }
            if countElements(tempUsername) < 4 {
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
    
    //  Checks for a valid password
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
    
    //  Calls all validation methods
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

