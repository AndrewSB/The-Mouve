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

    var window: UIWindow?
    
    // added as psuedo singletons; for restoration and memory management
    lazy var loginView = UIStoryboard.initialIn(.Login)
    lazy var homeView = HomeTabBarController()
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        Fabric.with([Crashlytics()])
        
        Parse.enableLocalDatastore()
        Parse.setApplicationId("GvHu9jcqgsGp2zZkgsXwLOQJXNWCzl5janz4FAj1",
            clientKey: "5SqHFJOslPl9TB9CPbuowXkCpidAOfoIKIXgSqU4")
        PFAnalytics.trackAppOpenedWithLaunchOptions(launchOptions)

        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
        window!.rootViewController = loggedIn ? homeView : loginView
        window!.makeKeyAndVisible()
        
        IQKeyboardManager.sharedManager().enable = true
        IQKeyboardManager.sharedManager().enableAutoToolbar = false
        
        tintNavBar()
        println("token is \(UserModel.sharedInstance.token)")
        
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
    func tintNavBar() {
        UINavigationBar.appearance().titleTextAttributes = [NSFontAttributeName : UIFont(name: "HalisGR-Regular", size: 14)!, NSForegroundColorAttributeName : UIColor.blackColor()]
        
        // Added code here to change Tab Bar Tint & Text Colour. Delete to restore default settings.
        UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.darkGrayColor() ], forState: .Selected)
        
        UITabBar.appearance().tintColor = UIColor.seaFoamGreen()
        
        //UITabBar.appearance().barTintColor = UIColor.darkGrayColor()
    }
    func startLogin(email: String, password: String) {
    
    }
    
    var loggedIn: Bool {
        get {
            return UserModel.sharedInstance.token != nil
        }
    }
    
    func checkLogin() {
        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
        window!.rootViewController = loggedIn ? homeView : loginView
        window!.makeKeyAndVisible()
    }

    func logOut() {

    }
}