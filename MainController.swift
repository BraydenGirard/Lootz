import UIKit

class MainController: UIViewController {
    
    let notificationCenter = NSNotificationCenter.defaultCenter()
    let transitionManager = TransitionManager()
    
    @IBOutlet var darkView: UIView!
    @IBOutlet var lootzView: UIImageView!
    
    @IBOutlet var exploreText: UITextView!
    
    @IBOutlet var distanceLabel: UILabel!
    @IBOutlet var weaponLabel: UILabel!
    @IBOutlet var goldLabel: UILabel!
    @IBOutlet var itemLabel: UILabel!
    
    @IBOutlet var saveLocationBtn: UIButton!
    @IBOutlet var viewLocationBtn: UIButton!
    @IBOutlet var searchBtn: UIButton!
    @IBOutlet var lootBtn: UIButton!
    @IBOutlet var collectBtn: UIButton!
    
    @IBOutlet var eastImg: UIImageView!
    @IBOutlet var northImg: UIImageView!
    @IBOutlet var southImg: UIImageView!
    @IBOutlet var westImg: UIImageView!
    
    @IBOutlet var weaponImg: UIImageView!
    @IBOutlet var goldImg: UIImageView!
    @IBOutlet var itemImg: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hideLootzUI()

        notificationCenter.addObserver(self, selector: "exit:", name: "exit", object: nil)
        notificationCenter.addObserver(self, selector: "chestSearchComplete:", name: "chestSearchComplete", object: nil)
        
        //------------right  swipe gestures in view--------------//
        let swipeRight = UISwipeGestureRecognizer(target: self, action: Selector("rightSwiped"))
        swipeRight.direction = UISwipeGestureRecognizerDirection.Right
        self.view.addGestureRecognizer(swipeRight)
        
        //-----------left swipe gestures in view--------------//
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: Selector("leftSwiped"))
        swipeLeft.direction = UISwipeGestureRecognizerDirection.Left
        self.view.addGestureRecognizer(swipeLeft)
    }
    
    override func viewDidAppear(animated: Bool) {
        if(!LocationController.sharedInstance.startLocationServices()) {
            self.showLocationPermissionError()
        }
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
        let toViewController = segue.destinationViewController as UIViewController
        
        // instead of using the default transition animation, we'll ask
        // the segue to use our custom TransitionManager object to manage the transition animation
        toViewController.transitioningDelegate = self.transitionManager
        
    }

    @IBAction func saveLocationBtnAction(sender: UIButton) {
        
    }
    
    @IBAction func viewLocationBtnAction(sender: UIButton) {
        
    }
    
    @IBAction func searchBtnAction(sender: UIButton) {
        if let currentLocation = LocationController.sharedInstance.getCurrentLocation() {
            searchBtn.enabled = false
            var latitude = currentLocation.coordinate.latitude as Double
            var longitude = currentLocation.coordinate.longitude as Double
            var distance = DBFactory.execute().getUser().getClarityDistance()
            DBFactory.execute().findChests(latitude, lng: longitude, distance: distance)
        }
        else {
            showLocationError()
        }
    }
    
    @IBAction func lootBtnAction(sender: UIButton) {
        showLootzUI()
    }
    
    @IBAction func collectBtnAction(sender: UIButton) {
        hideLootzUI()
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
        let userInfo:Dictionary<String,[Chest]!> = notification.userInfo as Dictionary<String,[Chest]!>
        let chests = userInfo["chests"] as [Chest]!
        
        if chests.count != 0 {
            exploreText.text = "Found \(chests.count) chests in your area"
        }
        else {
            exploreText.text = "Did not find any chests"
        }
         searchBtn.enabled = true
    }
    
    func showLootzUI() {
        darkView.hidden = false
        lootzView.hidden = false
        collectBtn.hidden = false
        weaponLabel.hidden = false
        goldLabel.hidden = false
        itemLabel.hidden = false
        weaponImg.hidden = false
        goldImg.hidden = false
        itemImg.hidden = false
    }
    
    func hideLootzUI() {
        darkView.hidden = true
        lootzView.hidden = true
        collectBtn.hidden = true
        weaponLabel.hidden = true
        goldLabel.hidden = true
        itemLabel.hidden = true
        weaponImg.hidden = true
        goldImg.hidden = true
        itemImg.hidden = true
    }
}
