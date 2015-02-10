//
//  AppDelegate.swift
//  Lootz
//
//  Created by Brayden Girard on 2014-11-27.
//  Copyright (c) 2014 Brayden Girard. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        //Parse.enableLocalDatastore()
        Parse.setApplicationId("xMWHdAdDCH08EjLa8Ot10m8NHUF5Jib8TcJsvhL9", clientKey: "tGDyakqGqFly9qRJ3XrmxMEp5jaWtde5LWJrAODF")
        PFAnalytics.trackAppOpenedWithLaunchOptionsInBackground(launchOptions, block: nil)
        
        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
        
        var storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        var initialViewController: UIViewController
        
        if DBFactory.execute().checkAutoSignIn() {
            initialViewController = storyboard.instantiateViewControllerWithIdentifier("MainController") as UIViewController
        }
        else {
            initialViewController = storyboard.instantiateViewControllerWithIdentifier("LoginController") as UIViewController
        }
        self.window?.rootViewController = initialViewController
        self.window?.makeKeyAndVisible()
        
        println("Application launching before")
        if let launch = launchOptions {
            if let key = launch.indexForKey(UIApplicationLaunchOptionsLocationKey) {
                LocationController.sharedInstance.startBackgroundLocationServices()
            }
        }
        println("Application Launching after")
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
         println("Entered backgound mode before")
        LocationController.sharedInstance.stopLocationServices()
        LocationController.sharedInstance.startBackgroundLocationServices()
        println("Entered backgound mode after")
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        println("Application became active before")
        LocationController.sharedInstance.stopBackgroundLocationServices()
        LocationController.sharedInstance.startLocationServices()
        println("Application became active after")
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

