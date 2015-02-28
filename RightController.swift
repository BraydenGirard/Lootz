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
    let BUTTONSTART = 100
    
    @IBOutlet var usernameLabel: UILabel!
    @IBOutlet var goldLabel: UILabel!
    
    @IBOutlet var actionBtn: UIButton!
    @IBOutlet var removeBtn: UIButton!
    @IBOutlet var headBtn: UIButton!
    @IBOutlet var offHandBtn: UIButton!
    @IBOutlet var chestBtn: UIButton!
    @IBOutlet var primaryHandBtn: UIButton!
    @IBOutlet var inv1Btn: UIButton!
    @IBOutlet var inv2Btn: UIButton!
    @IBOutlet var inv3Btn: UIButton!
    @IBOutlet var inv4Btn: UIButton!
    @IBOutlet var inv5Btn: UIButton!
    @IBOutlet var inv6Btn: UIButton!
    @IBOutlet var inv7Btn: UIButton!
    @IBOutlet var inv8Btn: UIButton!
    @IBOutlet var inv9Btn: UIButton!
    @IBOutlet var inv10Btn: UIButton!
    @IBOutlet var inv11Btn: UIButton!
    @IBOutlet var inv12Btn: UIButton!
    @IBOutlet var inv13Btn: UIButton!
    @IBOutlet var inv14Btn: UIButton!
    @IBOutlet var inv15Btn: UIButton!
    @IBOutlet var inv16Btn: UIButton!
    
    @IBOutlet var healthImg: UIImageView!
    @IBOutlet var energyImg: UIImageView!
    @IBOutlet var clarityImg: UIImageView!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.tag = -2;
        notificationCenter.addObserver(self, selector: "exit:", name: "exit", object: nil)
        
        //------------right swipe gestures in view--------------//
        let swipeRight = UISwipeGestureRecognizer(target: self, action: Selector("rightSwiped"))
        swipeRight.direction = UISwipeGestureRecognizerDirection.Right
        self.view.addGestureRecognizer(swipeRight)
        
        //------------static view setup--------------//
        usernameLabel.text = DBFactory.execute().getUser().getUsername()
        
        inv1Btn.setBackgroundImage(UIImage (named:"empty_slot_selected.png")!, forState: UIControlState.Selected)
        inv2Btn.setBackgroundImage(UIImage (named:"empty_slot_selected.png")!, forState: UIControlState.Selected)
        inv3Btn.setBackgroundImage(UIImage (named:"empty_slot_selected.png")!, forState: UIControlState.Selected)
        inv4Btn.setBackgroundImage(UIImage (named:"empty_slot_selected.png")!, forState: UIControlState.Selected)
        inv5Btn.setBackgroundImage(UIImage (named:"empty_slot_selected.png")!, forState: UIControlState.Selected)
        inv6Btn.setBackgroundImage(UIImage (named:"empty_slot_selected.png")!, forState: UIControlState.Selected)
        inv7Btn.setBackgroundImage(UIImage (named:"empty_slot_selected.png")!, forState: UIControlState.Selected)
        inv8Btn.setBackgroundImage(UIImage (named:"empty_slot_selected.png")!, forState: UIControlState.Selected)
        inv9Btn.setBackgroundImage(UIImage (named:"empty_slot_selected.png")!, forState: UIControlState.Selected)
        inv10Btn.setBackgroundImage(UIImage (named:"empty_slot_selected.png")!, forState: UIControlState.Selected)
        inv11Btn.setBackgroundImage(UIImage (named:"empty_slot_selected.png")!, forState: UIControlState.Selected)
        inv12Btn.setBackgroundImage(UIImage (named:"empty_slot_selected.png")!, forState: UIControlState.Selected)
        inv13Btn.setBackgroundImage(UIImage (named:"empty_slot_selected.png")!, forState: UIControlState.Selected)
        inv14Btn.setBackgroundImage(UIImage (named:"empty_slot_selected.png")!, forState: UIControlState.Selected)
        inv15Btn.setBackgroundImage(UIImage (named:"empty_slot_selected.png")!, forState: UIControlState.Selected)
        inv16Btn.setBackgroundImage(UIImage (named:"empty_slot_selected.png")!, forState: UIControlState.Selected)
    }
    
    override func viewDidAppear(animated: Bool) {
        deselectButton(0)
        
        
        //goldLabel.text = DBFactory.execute().getUser().getGold() as String
        
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
                    var lootItem = inventory[theButton.tag - BUTTONSTART]
                    confirmRemove(lootItem)
                }
            } else {
                if(theButton.tag == 116) {
                    //Remove the head piece if room in inventory
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
    
    func confirmRemove(lootItem: Loot) {
        let alertController = UIAlertController(
            title: "Remove Item",
            message: "Are you sure you want to remove 1 of this item from your inventory?",
            preferredStyle: .Alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (action) in
            
        }
        alertController.addAction(cancelAction)
        
        let removeAction = UIAlertAction(title: "Yes Remove", style: .Default) { (action) in
            DBFactory.execute().getUser().removeInventory(lootItem)
        }
        alertController.addAction(removeAction)
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    

}