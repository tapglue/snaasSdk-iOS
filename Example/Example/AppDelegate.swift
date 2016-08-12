//
//  AppDelegate.swift
//  Example
//
//  Created by John Nilsen on 6/30/16.
//  Copyright © 2016 Tapglue. All rights reserved.
//

import UIKit
import Tapglue

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    static var config: Configuration!
    var window: UIWindow?
    let appToken = "2da2d79336c2773c630ce46f5d24cb76"
    let url = "https://api.tapglue.com"
    var sims: TapglueSims!

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        AppDelegate.config = Configuration()
        AppDelegate.config.appToken = appToken
//        sims = TapglueSims(withConfiguration: AppDelegate.config, environment: .Sandbox)
//        registerForPushNotifications(application)
        
        print(launchOptions)
        return true
    }
    
    func registerForPushNotifications(application: UIApplication) {
        sims.registerSimsNotificationSettings(application)
    }
    
    func application(application: UIApplication, didRegisterUserNotificationSettings notificationSettings: UIUserNotificationSettings) {
        if notificationSettings.types != .None {
            application.registerForRemoteNotifications()
        }
    }
    
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        sims.registerDeviceToken(deviceToken)
    }
    
    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
        print("Failed to register:", error)
    }
    
    func application(application: UIApplication, didReceiveRemoteNotification notificationSettings: [NSObject : AnyObject]) {
        print(notificationSettings)
    }
}

