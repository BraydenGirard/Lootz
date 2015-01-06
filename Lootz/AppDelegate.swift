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
        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

