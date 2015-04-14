import UIKit
import AVFoundation

class MainController: UIViewController {
    
    let notificationCenter = NSNotificationCenter.defaultCenter()
    let transitionManager = TransitionManager()
    var nearestChest: Chest? = nil
    var chestDistance: Int = 0
    var audioPlayer = AVAudioPlayer()
    
    @IBOutlet var errorLabel: UILabel!
    @IBOutlet var lootzView: UIImageView!
    
    @IBOutlet var exploreText: UITextView!
    
    @IBOutlet var distanceLabel: UILabel!
    @IBOutlet var weaponLabel: UILabel!
    @IBOutlet var goldLabel: UILabel!
    @IBOutlet var itemLabel: UILabel!
    
    @IBOutlet var exitBtn: UIButton!
    @IBOutlet var saveLocationBtn: UIButton!
    @IBOutlet var viewLocationBtn: UIButton!
    @IBOutlet var searchBtn: UIButton!
    @IBOutlet var lootBtn: UIButton!
    @IBOutlet var collectBtn: UIButton!
    
    @IBOutlet var weaponImg: UIImageView!
    @IBOutlet var goldImg: UIImageView!
    @IBOutlet var itemImg: UIImageView!
 
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    @IBOutlet var viewBlocker: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        activityIndicator.startAnimating()
        disableView()
        hideLootzUI()

        notificationCenter.addObserver(self, selector: "exit:", name: "exit", object: nil)
        notificationCenter.addObserver(self, selector: "chestSearchComplete:", name: "chestSearchComplete", object: nil)
        notificationCenter.addObserver(self, selector: "refresh", name: "refresh", object: nil)
        
        let successSound = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("success", ofType: "wav")!)
        var error:NSError?
        audioPlayer = AVAudioPlayer(contentsOfURL: successSound, error: &error)
        audioPlayer.prepareToPlay()
        
        DBFactory.execute().updateUser()
        
    }
    
    override func viewDidAppear(animated: Bool) {
        if(!LocationController.sharedInstance.startLocationServices()) {
            self.showLocationPermissionError()
        }
    }
    
    func refresh() {
        activityIndicator.stopAnimating()
        enableView()
    }
    
    func disableView() {
        viewBlocker.hidden = false
    }
    
    func enableView() {
        viewBlocker.hidden = true
        //------------right  swipe gestures in view--------------//
        let swipeRight = UISwipeGestureRecognizer(target: self, action: Selector("rightSwiped"))
        swipeRight.direction = UISwipeGestureRecognizerDirection.Right
        self.view.addGestureRecognizer(swipeRight)
        
        //-----------left swipe gestures in view--------------//
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: Selector("leftSwiped"))
        swipeLeft.direction = UISwipeGestureRecognizerDirection.Left
        self.view.addGestureRecognizer(swipeLeft)
    }
    
    func exit(notification: NSNotification) {
        self.performSegueWithIdentifier("exit", sender: nil)
    }
    
    func rightSwiped()
    {
        self.performSegueWithIdentifier("mainLeft", sender: nil)
    }
    
    func leftSwiped()
    {
        self.performSegueWithIdentifier("mainRight", sender: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        // this gets a reference to the screen that we're about to transition to
        let toViewController = segue.destinationViewController as! UIViewController
        
        // instead of using the default transition animation, we'll ask
        // the segue to use our custom TransitionManager object to manage the transition animation
        toViewController.transitioningDelegate = self.transitionManager
        
    }

    @IBAction func saveLocationBtnAction(sender: UIButton) {
        if let currentLocation = LocationController.sharedInstance.getCurrentLocation() {
            var latitude = currentLocation.coordinate.latitude as Double
            var longitude = currentLocation.coordinate.longitude as Double
            var user = DBFactory.execute().getUser()
            user.setHomeLat(latitude)
            user.setHomeLng(longitude)
            user.setHome(true)
            DBFactory.execute().saveUser(user)
        } else {
            showLocationError()
        }
    }
    
    @IBAction func viewLocationBtnAction(sender: UIButton) {
        
    }
    
    @IBAction func searchBtnAction(sender: UIButton) {
        var nearestChest: Chest? = nil
        exploreText.text = ""
        distanceLabel.hidden = true
        
        if let currentLocation = LocationController.sharedInstance.getCurrentLocation() {
            searchBtn.enabled = false
            var latitude = currentLocation.coordinate.latitude as Double
            var longitude = currentLocation.coordinate.longitude as Double
            var user = DBFactory.execute().getUser()
            var distance = user.getClarityDistance()
            DBFactory.execute().findChests(latitude, lng: longitude, distance: distance)
            DBFactory.execute().saveUser(user)
        }
        else {
            showLocationError()
        }
    }
    
    @IBAction func lootBtnAction(sender: UIButton) {
        if let chest = nearestChest {
            var currentLocation = LocationController.sharedInstance.getCurrentLocation()
            var chestLocation = CLLocation(latitude: chest.getLatitude(), longitude: chest.getLongitude())
            
            if let currLocation = currentLocation {
                chestDistance = Int(currLocation.distanceFromLocation(chestLocation))
                
                if(chestDistance < 50) {
                    showLootzUI(chest)
                }
                else
                {
                    exploreText.text = "You are not close enough to loot the chest"
                }

            }
            
        }
        else {
            exploreText.text = "There are no chests near by to loot"
        }
        
    }
    
    @IBAction func collectBtnAction(sender: UIButton) {
        var user = DBFactory.execute().getUser()
        var currentEnergy = user.getEnergy()
        
        if(currentEnergy - 25 >= 0) {
            let resultUser = nearestChest!.getLoot()
            if(resultUser.success) {
                resultUser.user.addGold(nearestChest!.getGold())
                
                if(!user.isHome()) {
                    resultUser.user.setEnergy(currentEnergy - 25)
                }
                audioPlayer.play()
                resultUser.user.gainXP(CHESTXP)
                DBFactory.execute().removeChestFromServer(nearestChest!)
                DBFactory.execute().saveUser(resultUser.user)
               
                hideLootzUI()
            } else {
                errorLabel.text = "Inventory too full"
                errorLabel.hidden = false;
            }
        } else {
            errorLabel.text = "Not enough energy to loot"
            errorLabel.hidden = false;
        }
        
        
    }
    
    func showLocationPermissionError() {
        let alertController = UIAlertController(
            title: "Background Location Access Disabled",
            message: "In order to play Lootz, please open this app's settings and set location access to 'Always'.",
            preferredStyle: .Alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (action) in
            self.performSegueWithIdentifier("exit", sender: nil)
        }
        alertController.addAction(cancelAction)
        
        let openAction = UIAlertAction(title: "Open Settings", style: .Default) { (action) in
            if let url = NSURL(string:UIApplicationOpenSettingsURLString) {
                UIApplication.sharedApplication().openURL(url)
            }
        }
        alertController.addAction(openAction)
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    func showLocationError() {
        let alertController = UIAlertController(
            title: "Location Unknown",
            message: "It must be a dead zone, we can't find your location. Please try and find an open area and try again.",
            preferredStyle: .Alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        let okAction = UIAlertAction(title: "Ok", style: .Default, handler: nil)
        alertController.addAction(okAction)
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    func chestSearchComplete(notification: NSNotification) {
        let userInfo:Dictionary<String,[Chest]!> = notification.userInfo as! Dictionary<String,[Chest]!>
        let chests = userInfo["chests"] as [Chest]!
        
        if chests.count != 0 {
            exploreText.text = "Found \(chests.count) chests in your area, now tracking closest chest \n"
            nearestChest = chests[0]
            
            if let chest = nearestChest {
                var currentLocation = LocationController.sharedInstance.getCurrentLocation()
                var chestLocation = CLLocation(latitude: chest.getLatitude(), longitude: chest.getLongitude())
    
                if let currLocation = currentLocation {
                    var distance = Int(currLocation.distanceFromLocation(chestLocation))
                    distanceLabel.hidden = false
                    distanceLabel.text = String(distance) + " m"
                }
                else {
                    println("Could not find distance to nearest chest")
                    exploreText.text.extend("Could not find distance to nearest chest")
                }
            }
            else {
                println("Could not find nearest chest")
                exploreText.text.extend("Could not find nearest chest")
            }
            
        }
        else {
            exploreText.text = "Did not find any chests"
        }
         searchBtn.enabled = true
    }
    
    func showLootzUI(chest: Chest) {
        
        if(chest.isGold()) {
            weaponImg.image = UIImage(named:chest.getWeapon() + "_Gold")
            weaponLabel.text = "Gold " + replaceUnderscores(chest.getWeapon())
        } else {
            weaponImg.image = UIImage(named:chest.getWeapon())
            weaponLabel.text = replaceUnderscores(chest.getWeapon())
        }
        
        let item = chest.getItem()
        
        if(item != "Empty") {
            itemImg.image = UIImage(named: item)
            itemLabel.text = replaceUnderscores(item)
        }
        
        goldImg.image = UIImage(named: "Gold")
        goldLabel.text = String(chest.getGold()) + " Gold"
        
        lootzView.hidden = false
        collectBtn.hidden = false
        weaponLabel.hidden = false
        goldLabel.hidden = false
        itemLabel.hidden = false
        weaponImg.hidden = false
        goldImg.hidden = false
        itemImg.hidden = false
        exitBtn.hidden = false
    }
    
    func hideLootzUI() {
        lootzView.hidden = true
        collectBtn.hidden = true
        weaponLabel.hidden = true
        goldLabel.hidden = true
        itemLabel.hidden = true
        weaponImg.hidden = true
        goldImg.hidden = true
        itemImg.hidden = true
        errorLabel.hidden = true
        exitBtn.hidden = true
    }
    
    @IBAction func exitBtnPushed(sender: AnyObject) {
        hideLootzUI()
    }
    
    func replaceUnderscores(theString: String) -> String {
        let letters = NSCharacterSet.letterCharacterSet()
        var finalString = ""
        for uni in theString.unicodeScalars {
            if !letters.longCharacterIsMember(uni.value) {
                finalString += " "
            }
            else {
                finalString += "\(uni)"
            }
        }
        return finalString
    }
}