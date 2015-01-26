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
    
    override func viewDidLoad() {
        super.viewDidLoad()
         self.view.tag = 2;
        notificationCenter.addObserver(self, selector: "exit:", name: "exit", object: nil)
        
        //------------right  swipe gestures in view--------------//
        let swipeRight = UISwipeGestureRecognizer(target: self, action: Selector("rightSwiped"))
        swipeRight.direction = UISwipeGestureRecognizerDirection.Right
        self.view.addGestureRecognizer(swipeRight)
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
}