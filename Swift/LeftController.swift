//  Left side controller
//  Chest discovered history

import UIKit

class LeftController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let notificationCenter = NSNotificationCenter.defaultCenter()
    
    let transitionManager = TransitionManager()
    
    var chests: [Chest] = []
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var errorLabel: UILabel!
    
    //  MARK: View management
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        //  Tag view for custom transition manager
        self.view.tag = -1;
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.backgroundView = nil
        self.tableView.backgroundColor = UIColor.clearColor()
        
        //  Add notifications for asynchronous networking
        notificationCenter.addObserver(self, selector: "exit:", name: "exit", object: nil)
        notificationCenter.addObserver(self, selector: "chestDiscoveryComplete:", name: "chestDiscoveryComplete", object: nil)
        notificationCenter.addObserver(self, selector: "refresh", name: "refresh", object: nil)
        
        //  Add swipe left gesture listener
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: Selector("leftSwiped"))
        swipeLeft.direction = UISwipeGestureRecognizerDirection.Left
        self.view.addGestureRecognizer(swipeLeft)
    }
    
    override func viewDidAppear(animated: Bool) {
        DBFactory.execute().getDiscoveredChests()
    }
    
    //  Use the custom transition manager to animate the swipe transition
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let toViewController = segue.destinationViewController as UIViewController
        toViewController.transitioningDelegate = self.transitionManager
    }
    
    //  MARK: Notification listeners
    
    //  Pops to login view if user is not signed in
    func exit(notification: NSNotification) {
        self.performSegueWithIdentifier("exitLeft", sender: nil)
    }
    
    //  Populates the table view when chests discovered query is complete
    func chestDiscoveryComplete(notification: NSNotification) {
        let userInfo:Dictionary<String,[Chest]!> = notification.userInfo as Dictionary<String,[Chest]!>
        chests = userInfo["chests"] as [Chest]!
       
        self.tableView.reloadData()
    }
    
    //  Refreshes the view when the user is updated
    func refresh() {
        DBFactory.execute().getDiscoveredChests()
    }
    
    //  MARK: Swipe gesture listener
    
    func leftSwiped()
    {
        self.performSegueWithIdentifier("leftMain", sender: nil)
    }
    
    //  MARK: Table view delegate methods
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.chests.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell : UITableViewCell = tableView.dequeueReusableCellWithIdentifier("chestCell", forIndexPath: indexPath) as UITableViewCell
        cell.backgroundColor = UIColor.clearColor();
        cell.textLabel?.text = "Chest \(indexPath.row)"
        
        var currentLocation = LocationController.sharedInstance.getCurrentLocation()
        var chestLocation = CLLocation(latitude: chests[indexPath.row].getLatitude(), longitude: chests[indexPath.row].getLongitude())
        
        if let currLocation = currentLocation {
            var distance = Int(currLocation.distanceFromLocation(chestLocation))
            cell.detailTextLabel?.text = String(distance) + " m"
            cell.detailTextLabel?.textColor = UIColor.redColor()
        }

        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        var user = DBFactory.execute().getUser()
        
        if(user.getEnergy() - 50 >= 0) {
                confirmLoot(chests[indexPath.row])
        } else {
            errorLabel.text = "Not enough energy to loot"
            errorLabel.hidden = false;
        }
    }
    
    //  MARK: Alert views
    
    //  Confrim looting of discovered chest alert view
    func confirmLoot(chest: Chest) {
        let alertController = UIAlertController(
            title: "Loot Chest",
            message: "Are you sure you want to loot this chest, it will cost 50 energy and contents are unkown?",
            preferredStyle: .Alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (action) in  }
        alertController.addAction(cancelAction)
        
        let lootAction = UIAlertAction(title: "Yes Loot", style: .Default) { (action) in
            self.doWork(chest)
        }
        alertController.addAction(lootAction)
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    //  MARK: Helper methods
    
    func doWork(chest: Chest) {
        let resultUser = chest.getLoot()
        if(resultUser.success) {
            resultUser.user.addGold(chest.getGold())
            
            if(!resultUser.user.isHome()) {
                resultUser.user.setEnergy(resultUser.user.getEnergy() - 50)
            }
            
            resultUser.user.gainXP(CHESTXP)
            DBFactory.execute().removeChestFromServer(chest)
            for var i=0; i<resultUser.user.getInventory().count; i++ {
                var loot = resultUser.user.getInventory()[i]
            }
            DBFactory.execute().saveUser(resultUser.user)
        } else {
            self.errorLabel.text = "Inventory too full"
            self.errorLabel.hidden = false;
        }
    }

}