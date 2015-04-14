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
    @IBOutlet var lvlLabel: UILabel!
    @IBOutlet var xpLabel: UILabel!
    
    
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
        
    }
    
    override func viewDidAppear(animated: Bool) {
        refresh()
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
        let toViewController = segue.destinationViewController as! UIViewController
        
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
                    var selectedGear = inventory[theButton.tag - BUTTONSTART] as? Gear
                    var selectedPotion = inventory[theButton.tag - BUTTONSTART] as? Potion
                    
                    if let loot = selectedGear {
                        var user = DBFactory.execute().getUser()
                        user.equipGear(loot)
                        
                        DBFactory.execute().saveUser(user)
                    
                    } else if let loot = selectedPotion {
                        var user = DBFactory.execute().getUser()
                        if(loot.getName() == CLARITYPOT) {
                            user.setClarity(FULLCLARITY)
                        } else if (loot.getName() == ENERGYPOT) {
                            user.setEnergy(FULLENERGY)
                        } else if (loot.getName() == HEALTHPOT) {
                            user.setHealth(FULLHEALTH)
                        }
                      
                        user.removeInventory(loot)
                        DBFactory.execute().saveUser(user)
                    }
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
                        var user = DBFactory.execute().getUser()
                        user.removeGear(theHelmet)
                        DBFactory.execute().saveUser(user)
                    }
                } else if(theButton.tag == 117) {
                    let armour = DBFactory.execute().getUser().getEquipment(ONEHANDARMOUR)
                    if let theArmour = armour {
                        var user = DBFactory.execute().getUser()
                        user.removeGear(theArmour)
                        DBFactory.execute().saveUser(user)
                    } else {
               
                        let weapon = DBFactory.execute().getUser().getEquipment(ONEHAND)
                        if let theWeapon = weapon {
                            var user = DBFactory.execute().getUser()
                            user.removeGear(theWeapon)
                            DBFactory.execute().saveUser(user)
                        }
                    }
                } else if(theButton.tag == 118) {
                    //Remove the chest armour if room in inventory
                    let chest = DBFactory.execute().getUser().getEquipment(BARMOUR)
                    if let theChest = chest {
                        var user = DBFactory.execute().getUser()
                        user.removeGear(theChest)
                        DBFactory.execute().saveUser(user)
                    }
                } else if(theButton.tag == 119) {
                    
                    let weapon = DBFactory.execute().getUser().getEquipment(ONEHAND)
                    if let theWeapon = weapon {
                        var user = DBFactory.execute().getUser()
                        user.removeGear(theWeapon)
                        DBFactory.execute().saveUser(user)
                    } else {
                        let twoHandWeapon = DBFactory.execute().getUser().getEquipment(TWOHAND)
                        if let theTwoHandWeapon = twoHandWeapon {
                            var user = DBFactory.execute().getUser()
                            user.removeGear(theTwoHandWeapon)
                            DBFactory.execute().saveUser(user)
                        }
                    }
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
    
    func resetInvButtons() {
        for(var i=BUTTONSTART; i<BUTTONSTART + TOTALINVBUTTONS; i++) {
            var button = self.view.viewWithTag(i) as! UIButton
            //button.setBackgroundImage(UIImage(named: "empty_slot_selected"), forState: UIControlState.Selected)
            //button.setBackgroundImage(UIImage(named: "empty_slot"), forState: UIControlState.Normal)
            button.setImage(UIImage(named: "empty_slot_selected"), forState: UIControlState.Selected)
            button.setImage(UIImage(named: "empty_slot"), forState: UIControlState.Normal)
        }
    }
    
    func resetEqpButtons() {
        //Reset equipment buttons
    }
    
    func getSelectedButton() -> UIButton? {
        for(var i=BUTTONSTART; i<BUTTONSTART + TOTALBUTTONS; i++) {
            
            var button = self.view.viewWithTag(i) as! UIButton
            if(button.selected) {
                return button
            }
        }
        return nil
    }
    
    func setupInvButtons() {
        for(var i=BUTTONSTART; i<BUTTONSTART + TOTALINVBUTTONS; i++) {
            var button = self.view.viewWithTag(i) as! UIButton
            button.setBackgroundImage(UIImage(named: "empty_slot_selected"), forState: UIControlState.Selected)
            var image = getInvImage(i)
            var imageSelected = getInvImageSelected(i)
            
            if(image != nil) {
                button.setImage(image, forState: UIControlState.Normal)
                button.setImage(imageSelected, forState: UIControlState.Selected)
            }
        }
    }
    
    func setupEqpButtons() {
        if let headImg = DBFactory.execute().getUser().getEquipment(HELMET)?.getName() {
            headBtn.setImage(UIImage(named: headImg), forState: UIControlState.Normal)
            headBtn.setImage(UIImage(named: headImg + "_selected"), forState: UIControlState.Selected)
            headBtn.setBackgroundImage(UIImage(named: "helmet_slot"), forState: UIControlState.Normal)
            headBtn.setBackgroundImage(UIImage(named: "helmet_slot_selected"), forState: UIControlState.Selected)
        } else {
            headBtn.setImage(UIImage(named: "helmet_slot"), forState: UIControlState.Normal)
            headBtn.setImage(UIImage(named: "helmet_slot_selected"), forState: UIControlState.Selected)
        }
        if let chestImg = DBFactory.execute().getUser().getEquipment(BARMOUR)?.getName() {
            chestBtn.setImage(UIImage(named:chestImg), forState: UIControlState.Normal)
            chestBtn.setImage(UIImage(named:chestImg + "_selected"), forState: UIControlState.Selected)
            chestBtn.setBackgroundImage(UIImage(named: "armour_slot"), forState: UIControlState.Normal)
            chestBtn.setBackgroundImage(UIImage(named: "armour_slot_selected"), forState: UIControlState.Selected)
        } else {
            chestBtn.setImage(UIImage(named:"armour_slot"), forState: UIControlState.Normal)
            chestBtn.setImage(UIImage(named:"armour_slot_selected"), forState: UIControlState.Selected)
        }
        if let offHandImg = DBFactory.execute().getUser().getEquipment(ONEHANDARMOUR)?.getName() {
            offHandBtn.setImage(UIImage(named:offHandImg), forState: UIControlState.Normal)
            offHandBtn.setImage(UIImage(named:offHandImg + "_selected"), forState: UIControlState.Selected)
            offHandBtn.setBackgroundImage(UIImage(named: "sheild_slot"), forState: UIControlState.Normal)
            offHandBtn.setBackgroundImage(UIImage(named: "sheild_slot_selected"), forState: UIControlState.Selected)
            if let primaryHandImg = DBFactory.execute().getUser().getEquipment(ONEHAND)?.getName() {
                primaryHandBtn.setImage(UIImage(named:primaryHandImg), forState: UIControlState.Normal)
                primaryHandBtn.setImage(UIImage(named:primaryHandImg + "_selected"), forState: UIControlState.Selected)
                primaryHandBtn.setBackgroundImage(UIImage(named: "weapon_slot"), forState: UIControlState.Normal)
                primaryHandBtn.setBackgroundImage(UIImage(named: "weapon_slot_selected"), forState: UIControlState.Selected)
                
            }
        } else {
            primaryHandBtn.setImage(UIImage(named:"weapon_slot"), forState: UIControlState.Normal)
            primaryHandBtn.setImage(UIImage(named: "weapon_slot_selected"), forState: UIControlState.Selected)
            offHandBtn.setImage(UIImage(named:"sheild_slot"), forState: UIControlState.Normal)
            offHandBtn.setImage(UIImage(named:"sheild_slot_selected"), forState: UIControlState.Selected)
            
            if let weapons = DBFactory.execute().getUser().getDualEquipment(ONEHAND) {
                if let primaryHandWep = weapons[0] as Loot? {
                    var primaryHandImg = primaryHandWep.getName()
                    primaryHandBtn.setImage(UIImage(named:primaryHandImg), forState: UIControlState.Normal)
                    primaryHandBtn.setImage(UIImage(named:primaryHandImg + "_selected"), forState: UIControlState.Selected)
                    primaryHandBtn.setBackgroundImage(UIImage(named: "weapon_slot"), forState: UIControlState.Normal)
                    primaryHandBtn.setBackgroundImage(UIImage(named: "weapon_slot_selected"), forState: UIControlState.Selected)
                }
                if(weapons.count > 1) {
                    if let offHandWep = weapons[1] as Loot? {
                        var offHandImg = offHandWep.getName()
                        offHandBtn.setImage(UIImage(named:offHandImg), forState: UIControlState.Normal)
                        offHandBtn.setImage(UIImage(named:offHandImg + "_selected"), forState: UIControlState.Selected)
                        offHandBtn.setBackgroundImage(UIImage(named: "sheild_slot"), forState: UIControlState.Normal)
                        offHandBtn.setBackgroundImage(UIImage(named: "sheild_slot_selected"), forState: UIControlState.Selected)
                    }
                }
            } else if let primaryHandImg = DBFactory.execute().getUser().getEquipment(TWOHAND)?.getName() {
                primaryHandBtn.setImage(UIImage(named:primaryHandImg), forState: UIControlState.Normal)
                primaryHandBtn.setImage(UIImage(named:primaryHandImg + "_selected"), forState: UIControlState.Selected)
                primaryHandBtn.setBackgroundImage(UIImage(named: "weapon_slot"), forState: UIControlState.Normal)
                primaryHandBtn.setBackgroundImage(UIImage(named: "weapon_slot_selected"), forState: UIControlState.Selected)
                
            }
        }
    }
    
    func confirmRemove(lootItem: Loot) {
        let alertController = UIAlertController(
            title: "Remove Item",
            message: "Are you sure you want to remove this item from your inventory?",
            preferredStyle: .Alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (action) in
            
        }
        alertController.addAction(cancelAction)
        
        let removeAction = UIAlertAction(title: "Yes Remove", style: .Default) { (action) in
           self.doRemove(lootItem)
        }
        alertController.addAction(removeAction)
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    func doRemove(lootItem: Loot) {
        var loot = lootItem
        var user = DBFactory.execute().getUser()
        user.removeInventory(loot)
        DBFactory.execute().saveUser(user)
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
        if let button = getSelectedButton() {
            button.selected = false
        }
        resetInvButtons()
        setupInvButtons()
        setupEqpButtons()
        setupBars()
        
        var user = DBFactory.execute().getUser()
        goldLabel.text = String(user.getGold())
        usernameLabel.text = user.getUsername()
        lvlLabel.text = user.getLvl()
        xpLabel.text = String(user.getXP())
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