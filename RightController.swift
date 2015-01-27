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
        
        self.view.tag = 2;
        notificationCenter.addObserver(self, selector: "exit:", name: "exit", object: nil)
        
        //------------right swipe gestures in view--------------//
        let swipeRight = UISwipeGestureRecognizer(target: self, action: Selector("rightSwiped"))
        swipeRight.direction = UISwipeGestureRecognizerDirection.Right
        self.view.addGestureRecognizer(swipeRight)
        
        //------------static view setup--------------//
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
    
    override func viewDidAppear(animated: Bool) {
        
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
    }
    @IBAction func removeBtnAction(sender: UIButton) {
    }
    @IBAction func headBtnAction(sender: UIButton) {
    }
    @IBAction func offHandBtnAction(sender: UIButton) {
    }
    @IBAction func chestBtnAction(sender: UIButton) {
    }
    @IBAction func primaryHandBtnAction(sender: UIButton) {
    }
    @IBAction func inv1BtnAction(sender:UIButton) {
    }
    @IBAction func inv2BtnAction(sender:UIButton) {
    }
    @IBAction func inv3BtnAction(sender:UIButton) {
    }
    @IBAction func inv4BtnAction(sender:UIButton) {
    }
    @IBAction func inv5BtnAction(sender:UIButton) {
    }
    @IBAction func inv6BtnAction(sender:UIButton) {
    }
    @IBAction func inv7BtnAction(sender:UIButton) {
    }
    @IBAction func inv8BtnAction(sender:UIButton) {
    }
    @IBAction func inv9BtnAction(sender:UIButton) {
    }
    @IBAction func inv10BtnAction(sender:UIButton) {
    }
    @IBAction func inv11BtnAction(sender:UIButton) {
    }
    @IBAction func inv12BtnAction(sender:UIButton) {
    }
    @IBAction func inv13BtnAction(sender:UIButton) {
    }
    @IBAction func inv14BtnAction(sender:UIButton) {
    }
    @IBAction func inv15BtnAction(sender:UIButton) {
    }
    @IBAction func inv16BtnAction(sender:UIButton) {
    }
}