import UIKit

class MainController: UIViewController {
    
    let notificationCenter = NSNotificationCenter.defaultCenter()
    let transitionManager = TransitionManager()
    
    @IBOutlet var exploreText: UITextView!
    
    @IBOutlet var distanceLabel: UILabel!
    
    @IBOutlet var saveLocationBtn: UIButton!
    @IBOutlet var viewLocationBtn: UIButton!
    @IBOutlet var searchBtn: UIButton!
    @IBOutlet var lootBtn: UIButton!
    
    @IBOutlet var eastImg: UIImageView!
    @IBOutlet var northImg: UIImageView!
    @IBOutlet var southImg: UIImageView!
    @IBOutlet var westImg: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        notificationCenter.addObserver(self, selector: "exit:", name: "exit", object: nil)
        
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
        
    }
    
    @IBAction func lootBtnAction(sender: UIButton) {
        
    }
}
