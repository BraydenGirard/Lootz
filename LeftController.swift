//
//  LeftController.swift
//  Lootz
//
//  Created by Brayden Girard on 2015-01-24.
//  Copyright (c) 2015 Brayden Girard. All rights reserved.
//

import UIKit

class LeftController: UIViewController {
    
    let notificationCenter = NSNotificationCenter.defaultCenter()
    let transitionManager = TransitionManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.tag = 1;
        notificationCenter.addObserver(self, selector: "exit:", name: "exit", object: nil)
        
        //-----------left swipe gestures in view--------------//
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: Selector("leftSwiped"))
        swipeLeft.direction = UISwipeGestureRecognizerDirection.Left
        self.view.addGestureRecognizer(swipeLeft)
    }
    
    func exit(notification: NSNotification) {
        self.performSegueWithIdentifier("exitLeft", sender: nil)
    }
    
    func leftSwiped()
    {
        self.performSegueWithIdentifier("leftMain", sender: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        // this gets a reference to the screen that we're about to transition to
        let toViewController = segue.destinationViewController as UIViewController
        
        // instead of using the default transition animation, we'll ask
        // the segue to use our custom TransitionManager object to manage the transition animation
        toViewController.transitioningDelegate = self.transitionManager
        
    }
    
}