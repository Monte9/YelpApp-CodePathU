//
//  AppDelegate.swift
//  Yelp
//
//  Created by Timothy Lee on 9/19/14.
//  Copyright (c) 2014 Timothy Lee. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        UIApplication.sharedApplication().statusBarStyle = .LightContent
        
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        // Set up the search View Controller
        let searchNavigationController = storyboard.instantiateViewControllerWithIdentifier("SearchNavigationController") as! UINavigationController
        let searchViewController = searchNavigationController.topViewController as! SearchViewController
        searchViewController.tabBarItem.title = "Search"
        searchViewController.tabBarItem.image = UIImage(named: "search")
        
        
        //Customize Popular navigation bar UI
        searchNavigationController.navigationBar.barTintColor = UIColor(red: 218/255, green: 56/255, blue: 40/255, alpha: 1)
        searchNavigationController.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        searchNavigationController.navigationBar.topItem?.title = "Search"
        
        
        
        
        // Set up the search View Controller
        let nearbyNavigationController = storyboard.instantiateViewControllerWithIdentifier("NearbyNavigationController") as! UINavigationController
        let nearbyViewController = nearbyNavigationController.topViewController
        nearbyViewController!.tabBarItem.title = "Nearby"
        nearbyViewController!.tabBarItem.image = UIImage(named: "nearby")
        
        
        //Customize Popular navigation bar UI
        nearbyNavigationController.navigationBar.barTintColor = UIColor(red: 218/255, green: 56/255, blue: 40/255, alpha: 1)
        nearbyNavigationController.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        nearbyNavigationController.navigationBar.topItem?.title = "Nearby"
        
        // Set up the Tab Bar Controller to have two tabs
        let tabBarController = UITabBarController()
        tabBarController.viewControllers = [searchNavigationController, nearbyNavigationController]
        UITabBar.appearance().tintColor = UIColor(red: 218/255, green: 56/255, blue: 40/255, alpha: 1)
    //    UITabBar.appearance().barTintColor = UIColor.blackColor()

        
        // Make the Tab Bar Controller the root view controller
        window?.rootViewController = tabBarController
        window?.makeKeyAndVisible()
        
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

