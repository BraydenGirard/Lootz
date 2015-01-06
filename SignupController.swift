import UIKit

class SignupController: UIViewController, UITextFieldDelegate {
    
    let notificationCenter = NSNotificationCenter.defaultCenter()
    
    @IBOutlet var backButton: UIButton!
    @IBOutlet var usernameText: UITextField!
    @IBOutlet var emailText: UITextField!
    @IBOutlet var passwordText: UITextField!
    
    var offset:CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        usernameText.delegate = self
        emailText.delegate = self
        passwordText.delegate = self
        notificationCenter.addObserver(self, selector: "signUpFail:", name: "signUpFail", object: nil)
        notificationCenter.addObserver(self, selector: "signUpSuccess:", name: "signUpSuccess", object: nil)
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backPushed(sender: UIButton) {
       dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func signUpPushed(sender: UIButton) {
        if let error = checkSignUp(usernameText.text, email: emailText.text, password: passwordText.text) {
            var alert = UIAlertController(title: "Error", message: error, preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Try again", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
        else {
            DBFactory.execute()?.signUp(usernameText.text!, email: emailText.text!, password: passwordText.text!)
        }
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        self.view.endEditing(true)
    }
    
    //MARK: - UITextField Delegate Methods
    
    func textFieldDidBeginEditing(textField: UITextField!) {
        if textField.tag == 1 {
            offset = 75
        } else if textField.tag == 2 {
            offset = 100
        } else if textField.tag == 3 {
            offset = 110
        }
        self.view.frame.origin.y -= offset
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        self.view.frame.origin.y += offset
        offset = 0
    }
    
    func signUpFail(notification: NSNotification) {
        println("Failed signup")
        var alert = UIAlertController(title: "User Already Exists", message: "The username or email address already exists.", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Try again", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func signUpSuccess(notification: NSNotification) {
        println("Successful signup")
        
        self.performSegueWithIdentifier("signUpSegue", sender: nil)
    }
    
    //User validation
    
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
    
    func checkEmail (input: String?) -> String? {
        if let tempEmail = input {
            if tempEmail.isEmpty {
                return "email can not be empty"
            }
            return nil
        }
        else {
            return "must enter an email"
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
    
    func checkSignUp(username: String?, email: String?, password: String?) -> String? {
        if let result = checkUsername(username) {
            return result
        }
        if let result = checkEmail(email) {
            return result
        }
        if let result = checkPassword(password) {
            return result
        }
        return nil
    }
}