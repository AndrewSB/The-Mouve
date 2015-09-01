//
//  AppDelegate.swift
//  The Mouve
//
//  Created by Andrew Breckenridge on 4/12/15.
//  Copyright (c) 2015 Andrew Breckenridge. All rights reserved.
//

import UIKit
import Parse
import Bolts
import Fabric
import Crashlytics

let appDel = UIApplication.sharedApplication().delegate as! AppDelegate
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var currentUser: PFUser?
    var window: UIWindow?
    var location = Location()
    let placeHolderBg = UIImage(named: "addImage.png")
    let pendingOperations = PendingOperations()


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        Fabric.with([Crashlytics()])
        
        AERecord.loadCoreDataStack()
        Parse.enableLocalDatastore()
        Parse.setApplicationId("h5smZAkhhQ8MYAFJY3P4U9rFs6kjz0MLSurD76tL",
            clientKey: "8A4eqYwOATOIxM634S2Hf3oTVvbbjnUYclcFjhrT")
        PFAnalytics.trackAppOpenedWithLaunchOptions(launchOptions)
        
        let loggedIn = PFUser.currentUser() != nil
        self.currentUser = PFUser.currentUser()
        
        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
        window!.rootViewController = (UIStoryboard(name: loggedIn ? "Main" : "Login", bundle: NSBundle.mainBundle()).instantiateInitialViewController()) as? UIViewController
        window!.makeKeyAndVisible()
        
        IQKeyboardManager.sharedManager().enable = true
        IQKeyboardManager.sharedManager().enableAutoToolbar = false
        
        changeNavBar()
        
        
        return FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
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
        FBSDKAppEvents.activateApp()
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
}

extension AppDelegate {
    func changeNavBar() {
        UINavigationBar.appearance().titleTextAttributes = [NSFontAttributeName : UIFont(name: "HalisGR-Regular", size: 14)!, NSForegroundColorAttributeName : UIColor.blackColor()]
        
        // Added code here to change Tab Bar Tint & Text Colour. Delete to restore default settings.
        UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.darkGrayColor() ], forState: .Selected)
        
        UITabBar.appearance().tintColor = UIColor.seaFoamGreen()
        
        //UITabBar.appearance().barTintColor = UIColor.darkGrayColor()
    }
    func startLogin(email: String, password: String) {
    
    }
    
    func checkLogin() {
        let loggedIn = PFUser.currentUser() != nil
        
        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
        window!.rootViewController = (UIStoryboard(name: loggedIn ? "Main" : "Login", bundle: NSBundle.mainBundle()).instantiateInitialViewController()) as? UIViewController
        window!.makeKeyAndVisible()
    }
    func logOut() {
//        UserDefaults.resetUD()
        PFUser.logOut()
//        LocalMessage.deallocLM()
        self.checkLogin()
    }
}