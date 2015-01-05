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
        usernameText.delegate = self;
        emailText.delegate = self;
        passwordText.delegate = self;
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
        signUp(usernameText.text, email: emailText.text, password: passwordText.text)
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
    
    func signUp(username: String?, email: String?, password: String?) {
        var user = User()
        
        var result = user.setUsername(username)
        
        if !result.success {
            var alert = UIAlertController(title: "Username Error", message: result.error, preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Try again", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
            return
        }
        
        result = user.setEmail(email)
        
        if !result.success {
            var alert = UIAlertController(title: "Username Error", message: result.error, preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Try again", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
            return
        }
        
        result = user.setPassword(password)
        
        if !result.success {
            var alert = UIAlertController(title: "Username Error", message: result.error, preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Try again", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
            return
        }
        
        DBFactory.execute()?.saveNewUser(user)
    }
    
    func signUpFail(notification: NSNotification) {
        println("Failed signup")
        var alert = UIAlertController(title: "User Already Exists", message: "The username or email address already exists.", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Try again", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func signUpSuccess(notification: NSNotification) {
        println("Successful signup")
        //redirect to class selection
    }
}