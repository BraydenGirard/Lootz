//  Lootz App Delegate

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        //  Connects Parse framework to application
        Parse.setApplicationId("xMWHdAdDCH08EjLa8Ot10m8NHUF5Jib8TcJsvhL9", clientKey: "tGDyakqGqFly9qRJ3XrmxMEp5jaWtde5LWJrAODF")
        
        //  Connects Parse analytics to the applicaction
        PFAnalytics.trackAppOpenedWithLaunchOptionsInBackground(launchOptions, block: nil)
        
        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
        var storyboard = UIStoryboard(name: "Main", bundle: nil)
        var initialViewController: UIViewController
        
        //  Check if user is logged in, if so skip login controller
        if DBFactory.execute().checkAutoSignIn() {
            initialViewController = storyboard.instantiateViewControllerWithIdentifier("MainController") as UIViewController
        }
        else {
            initialViewController = storyboard.instantiateViewControllerWithIdentifier("LoginController") as UIViewController
        }
        
        self.window?.rootViewController = initialViewController
        self.window?.makeKeyAndVisible()
        
        if let launch = launchOptions {
            if let key = launch.indexForKey(UIApplicationLaunchOptionsLocationKey) {
                LocationController.sharedInstance.startBackgroundLocationServices()
            }
        }
        return true
    }

    func applicationDidEnterBackground(application: UIApplication) {
        //  On application background stop location updates
        //  and start significant location updates
        LocationController.sharedInstance.stopLocationServices()
        LocationController.sharedInstance.startBackgroundLocationServices()
    }

    func applicationDidBecomeActive(application: UIApplication) {
        //  On application background stop significant location updates
        //  and start location updates
        LocationController.sharedInstance.stopBackgroundLocationServices()
        LocationController.sharedInstance.startLocationServices()
    }

    func applicationWillTerminate(application: UIApplication) { }
    
    func applicationWillResignActive(application: UIApplication) { }
    
    func applicationWillEnterForeground(application: UIApplication) { }
}