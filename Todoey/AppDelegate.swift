//
//  AppDelegate.swift
//  Todoey
//
//  Created by Hannie Kim on 6/29/18.
//  Copyright © 2018 Hannie Kim. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    // runs first. Before the viewDidLoad()
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        return true
    }

    // what to be done with user's data if they get a call or cancel out of the app
    func applicationWillResignActive(_ application: UIApplication) {
       
    }

    // when user clicks home button or open a different app. When it enters the background
    func applicationDidEnterBackground(_ application: UIApplication) {
        print("applicationDidEnterBackground")
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    // when app is terminated. When there's a resource intensive app, it may terminate the apps in the background
    func applicationWillTerminate(_ application: UIApplication) {
        print("applicationWillTerminate")
    }


}

