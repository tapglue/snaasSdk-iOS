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

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
//        AppDelegate.config = Configuration()
//        AppDelegate.config.appToken = appToken
//        sims = TapglueSims(withConfiguration: AppDelegate.config, environment: .sandbox)
//        registerForPushNotifications(application)
//        
//        print(launchOptions)
        return true
    }
//    
//    func registerForPushNotifications(_ application: UIApplication) {
//        sims.registerSimsNotificationSettings(application)
//    }
//    
//    func application(_ application: UIApplication, didRegister notificationSettings: UIUserNotificationSettings) {
//        if notificationSettings.types != UIUserNotificationType() {
//            application.registerForRemoteNotifications()
//        }
//    }
//    
//    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
//        sims.registerDeviceToken(deviceToken)
//    }
//    
//    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
//        print("Failed to register:", error)
//    }
//    
//    func application(_ application: UIApplication, didReceiveRemoteNotification notificationSettings: [AnyHashable: Any]) {
//        print(notificationSettings)
//    }
}

