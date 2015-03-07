//
//  RightController.swift
//  Lootz
//
//  Created by Brayden Girard on 2015-01-24.
//  Copyright (c) 2015 Brayden Girard. All rights reserved.
//

import UIKit

class RightController: UIViewController {
    
    let notificationCenter = NSNotificationCenter.defaultCenter()
    let transitionManager = TransitionManager()
    
    let TOTALBUTTONS = 20
    let TOTALINVBUTTONS = 16
    let BUTTONSTART = 100
    
    @IBOutlet var usernameLabel: UILabel!
    @IBOutlet var goldLabel: UILabel!
    
    @IBOutlet var actionBtn: UIButton!
    @IBOutlet var removeBtn: UIButton!
    @IBOutlet var headBtn: UIButton!
    @IBOutlet var offHandBtn: UIButton!
    @IBOutlet var chestBtn: UIButton!
    @IBOutlet var primaryHandBtn: UIButton!
    
    @IBOutlet var healthImg: UIImageView!
    @IBOutlet var energyImg: UIImageView!
    @IBOutlet var clarityImg: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        self.view.tag = -2;
        notificationCenter.addObserver(self, selector: "exit:", name: "exit", object: nil)
        notificationCenter.addObserver(self, selector: "refresh", name: "refresh", object: nil)
        
        
        //------------right swipe gestures in view--------------//
        let swipeRight = UISwipeGestureRecognizer(target: self, action: Selector("rightSwiped"))
        swipeRight.direction = UISwipeGestureRecognizerDirection.Right
        self.view.addGestureRecognizer(swipeRight)
        
        //------------static view setup--------------//
        
    }
    
    override func viewDidAppear(animated: Bool) {
        deselectButton(0)
        println("Hello")
        refresh()
        println("Goodbye")
    }
    
    func exit(notification: NSNotification) {
        self.performSegueWithIdentifier("exitRight", sender: nil)
    }
    
    func rightSwiped()
    {
        self.performSegueWithIdentifier("rightMain", sender: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        // this gets a reference to the screen that we're about to transition to
        let toViewController = segue.destinationViewController as UIViewController
        
        // instead of using the default transition animation, we'll ask
        // the segue to use our custom TransitionManager object to manage the transition animation
        toViewController.transitioningDelegate = self.transitionManager
        
    }
    @IBAction func actionBtnAction(sender: UIButton) {
        var selectedButton = getSelectedButton()
        
        if let theButton = selectedButton {
            //If less than 116 inventory is selected
            //do something with inventory
            if(theButton.tag < 116) {
                var inventory = DBFactory.execute().getUser().getInventory()
                    
                if((theButton.tag - BUTTONSTART) < inventory.count) {
                    var lootItem = inventory[theButton.tag - BUTTONSTART]
                    lootItem.use()
                }
            }
        }
    }
    @IBAction func removeBtnAction(sender: UIButton) {
        var selectedButton = getSelectedButton()
        
        if let theButton = selectedButton {
            //If less than 116 inventory is selected
            //else equipment is selected
            if(theButton.tag < 116) {
                var inventory = DBFactory.execute().getUser().getInventory()
                
                if((theButton.tag - BUTTONSTART) < inventory.count) {
                    let lootItem = inventory[theButton.tag - BUTTONSTART]
                    confirmRemove(lootItem)
                }
            } else {
                if(theButton.tag == 116) {
                    let helmet = DBFactory.execute().getUser().getEquipment(HELMET)
                    if let theHelmet = helmet {
                        DBFactory.execute().getUser().removeGear(theHelmet)
                        refresh()
                    }
                } else if(theButton.tag == 117) {
                    //Remove the shield if room in inventory
                } else if(theButton.tag == 118) {
                    //Remove the chest armour if room in inventory
                } else if(theButton.tag == 119) {
                    //Remove the sword if room in inventory
                }
            }
        }
    }
    @IBAction func equipmentBtnAction(sender: UIButton) {
        deselectButton(sender.tag)
        sender.selected = !sender.selected
    }
    @IBAction func invBtnAction(sender:UIButton) {
        deselectButton(sender.tag)
        sender.selected = !sender.selected
        
    }
    
    func deselectButton(senderTag: Int) {
        var button = getSelectedButton()
        
        if let theButton = button {
            if(theButton.tag == senderTag) {
                return
            }
            theButton.selected = false
        }
    }
    
    func getSelectedButton() -> UIButton? {
        for(var i=BUTTONSTART; i<BUTTONSTART + TOTALBUTTONS; i++) {
            
            var button = self.view.viewWithTag(i) as UIButton
            if(button.selected) {
                return button
            }
        }
        return nil
    }
    
    func setupInvButtons() {
        for(var i=BUTTONSTART; i<BUTTONSTART + TOTALINVBUTTONS; i++) {
            var button = self.view.viewWithTag(i) as UIButton
            button.setBackgroundImage(UIImage(named: "empty_slot_selected"), forState: UIControlState.Selected)
            var image = getInvImage(i)
            var imageSelected = getInvImageSelected(i)
            
            if(image != nil) {
                button.setImage(image, forState: UIControlState.Normal)
                button.setImage(imageSelected, forState: UIControlState.Selected)
            }
        }
    }
    
    func confirmRemove(lootItem: Loot) {
        let alertController = UIAlertController(
            title: "Remove Item",
            message: "Are you sure you want to remove 1 of this item from your inventory?",
            preferredStyle: .Alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (action) in
            
        }
        alertController.addAction(cancelAction)
        
        let removeAction = UIAlertAction(title: "Yes Remove", style: .Default) { (action) in
            var user = DBFactory.execute().getUser()
            user.removeInventory(lootItem)
            DBFactory.execute().saveUser(user)
        }
        alertController.addAction(removeAction)
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    func setupBars() {
        var health = DBFactory.execute().getUser().getHealth()
        var clarity = DBFactory.execute().getUser().getClarity()
        var energy = DBFactory.execute().getUser().getEnergy()
        
        switch health {
        case FULLHEALTH:
            healthImg.image = UIImage(named: "health_full")
        case 75:
            healthImg.image = UIImage(named: "health_75")
        case 50:
            healthImg.image = UIImage(named: "health_50")
        case 25:
            healthImg.image = UIImage(named: "health_25")
        default:
            healthImg.image = UIImage(named: "health_empty")
        }
        
        switch energy {
        case FULLENERGY:
            energyImg.image = UIImage(named: "energy_full")
        case 75:
            energyImg.image = UIImage(named: "energy_75")
        case 50:
            energyImg.image = UIImage(named: "energy_50")
        case 25:
            energyImg.image = UIImage(named: "energy_25")
        default:
            energyImg.image = UIImage(named: "energy_empty")
        }
        
        switch clarity {
        case FULLCLARITY:
            clarityImg.image = UIImage(named: "clarity_full")
        case 75:
            clarityImg.image = UIImage(named: "clarity_75")
        case 50:
            clarityImg.image = UIImage(named: "clarity_50")
        case 25:
            clarityImg.image = UIImage(named: "clarity_25")
        default:
            clarityImg.image = UIImage(named: "clarity_empty")
        }
    }
    
    func refresh() {
        setupInvButtons()
        setupBars()
        goldLabel.text = String(DBFactory.execute().getUser().getGold())
        usernameLabel.text = DBFactory.execute().getUser().getUsername()
        
        if let headImg = DBFactory.execute().getUser().getEquipment(HELMET)?.getImage() {
            headBtn.setImage(headImg, forState: UIControlState.Normal)
        }
        if let chestImg = DBFactory.execute().getUser().getEquipment(BARMOUR)?.getImage() {
            chestBtn.setImage(chestImg, forState: UIControlState.Normal)
        }
        if let offHandImg = DBFactory.execute().getUser().getEquipment(ONEHANDARMOUR)?.getImage() {
            headBtn.setImage(offHandImg, forState: UIControlState.Normal)
            if let primaryHandImg = DBFactory.execute().getUser().getEquipment(ONEHAND)?.getImage() {
                primaryHandBtn.setImage(primaryHandImg, forState: UIControlState.Normal)
            }
        }
        else {
            if let weapons = DBFactory.execute().getUser().getDualEquipment(ONEHAND) {
                if let primaryHandImg = weapons[0].getImage() as UIImage? {
                    primaryHandBtn.setImage(primaryHandImg, forState: UIControlState.Normal)
                }
                if let offHandImg = weapons[1].getImage() as UIImage? {
                    offHandBtn.setImage(offHandImg, forState: UIControlState.Normal)
                }
            }
        }

    }
    
    func getInvImage(currentIndex: Int) -> UIImage? {
        var invIndex = currentIndex - BUTTONSTART
        var inventory = DBFactory.execute().getUser().getInventory()
        
        if(invIndex < inventory.count) {
            let lootItem = inventory[invIndex]
            return lootItem.image
        }
        return nil
    }
    
    func getInvImageSelected(currentIndex: Int) -> UIImage? {
        var invIndex = currentIndex - BUTTONSTART
        var inventory = DBFactory.execute().getUser().getInventory()
        
        if(invIndex < inventory.count) {
            let lootItem = inventory[invIndex]
            return UIImage(named: lootItem.getName() + "_selected")
        }
        return nil
    }
}