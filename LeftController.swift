//
//  LeftController.swift
//  Lootz
//
//  Created by Brayden Girard on 2015-01-24.
//  Copyright (c) 2015 Brayden Girard. All rights reserved.
//

import UIKit

class LeftController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let notificationCenter = NSNotificationCenter.defaultCenter()
    let transitionManager = TransitionManager()
    
    var chests: [Chest] = []
    
    @IBOutlet var tableView: UITableView!
    
    @IBOutlet var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.tag = -1;
        notificationCenter.addObserver(self, selector: "exit:", name: "exit", object: nil)
        
        //-----------left swipe gestures in view--------------//
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: Selector("leftSwiped"))
        swipeLeft.direction = UISwipeGestureRecognizerDirection.Left
        self.view.addGestureRecognizer(swipeLeft)
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
         notificationCenter.addObserver(self, selector: "chestDiscoveryComplete:", name: "chestDiscoveryComplete", object: nil)
         notificationCenter.addObserver(self, selector: "refresh", name: "refresh", object: nil)
    }
    
    override func viewDidAppear(animated: Bool) {
        DBFactory.execute().getDiscoveredChests()
    }
    
    func exit(notification: NSNotification) {
        self.performSegueWithIdentifier("exitLeft", sender: nil)
    }
    
    func leftSwiped()
    {
        self.performSegueWithIdentifier("leftMain", sender: nil)
    }
    
    func chestDiscoveryComplete(notification: NSNotification) {
        println("Chest discovery complete")
        let userInfo:Dictionary<String,[Chest]!> = notification.userInfo as Dictionary<String,[Chest]!>
        chests = userInfo["chests"] as [Chest]!
       
        self.tableView.reloadData()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        // this gets a reference to the screen that we're about to transition to
        let toViewController = segue.destinationViewController as UIViewController
        
        // instead of using the default transition animation, we'll ask
        // the segue to use our custom TransitionManager object to manage the transition animation
        toViewController.transitioningDelegate = self.transitionManager
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.chests.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell : UITableViewCell = tableView.dequeueReusableCellWithIdentifier("chestCell", forIndexPath: indexPath) as UITableViewCell
        
        cell.textLabel?.text = "Chest \(indexPath.row)"
        
        var currentLocation = LocationController.sharedInstance.getCurrentLocation()
        var chestLocation = CLLocation(latitude: chests[indexPath.row].getLatitude(), longitude: chests[indexPath.row].getLongitude())
        
        if let currLocation = currentLocation {
            var distance = Int(currLocation.distanceFromLocation(chestLocation))
            cell.detailTextLabel?.text = String(distance) + " m"
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
        

        println("Touched cell \(indexPath.row)")
    }
    
    func confirmLoot(chest: Chest) {
        let alertController = UIAlertController(
            title: "Loot Chest",
            message: "Are you sure you want to loot this chest, it will cost 50 energy and contents are unkown?",
            preferredStyle: .Alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (action) in
            
        }
        alertController.addAction(cancelAction)
        
        let lootAction = UIAlertAction(title: "Yes Loot", style: .Default) { (action) in
            self.doWork(chest)
        }
        alertController.addAction(lootAction)
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    func refresh() {
        DBFactory.execute().getDiscoveredChests()
    }
    
    func doWork(chest: Chest) {
        let resultUser = chest.getLoot()
        if(resultUser.success) {
            resultUser.user.addGold(chest.getGold())
            
            resultUser.user.setEnergy(resultUser.user.getEnergy() - 50)
            
            resultUser.user.gainXP(CHESTXP)
            DBFactory.execute().removeChestFromServer(chest)
            for var i=0; i<resultUser.user.getInventory().count; i++ {
                var loot = resultUser.user.getInventory()[i]
                println(loot.getId())
            }
            DBFactory.execute().saveUser(resultUser.user)
        } else {
            self.errorLabel.text = "Inventory too full"
            self.errorLabel.hidden = false;
        }
    }
}