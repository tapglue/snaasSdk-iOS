//
//  TapglueSims.swift
//  simsTest
//
//  Created by John Nilsen on 5/17/16.
//  Copyright © 2016 John Nilsen. All rights reserved.
//

import UIKit

open class TapglueSims : NSObject, SessionTokenListener {
    let appToken: String
    var sessionToken: String?
    var deviceToken: String?
    var api : SimsApi
    
    public convenience init(withConfiguration config: Configuration) {
        self.init(withConfiguration: config, environment: Environment.production)
    }
    
    public init(withConfiguration config: Configuration, environment: Environment) {
        self.appToken = config.appToken
        api = DefaultSimsApi(url: config.baseUrl, environment: environment)
        super.init()
        Router.sessionTokenListener = self
    }
    
    open func registerSimsNotificationSettings(_ application: UIApplication) {
        let notificationSettings = UIUserNotificationSettings(
            types: [.badge, .sound, .alert], categories: nil)
        application.registerUserNotificationSettings(notificationSettings)
    }
    
    open func registerDeviceToken(_ deviceToken: Data) {
        let tokenChars = (deviceToken as NSData).bytes.bindMemory(to: CChar.self, capacity: deviceToken.count)
        var tokenString = ""
        
        for i in 0..<deviceToken.count {
            tokenString += String(format: "%02.2hhx", arguments: [tokenChars[i]])
        }
        
        print("Device Token:", tokenString)
        self.deviceToken = tokenString
        registerSims()
    }
    
    func sessionTokenSet(_ sessionToken: String?) {
        print("sessionTokenSet: \(sessionToken ?? "no session token")")
        self.sessionToken = sessionToken
        registerSims()
    }
    
    fileprivate func registerSims() {
        if let deviceToken = deviceToken {
            if let sessionToken = sessionToken {
                registerDeviceOnApiWithAppToken(appToken, deviceToken: deviceToken, sessionToken: sessionToken)
            }
        }
    }
    
    fileprivate func registerDeviceOnApiWithAppToken(_ appToken: String, deviceToken: String, sessionToken: String) {
        api.registerDevice(appToken, deviceToken: deviceToken, sessionToken: sessionToken)
    }
}

public enum Environment: Int {
    case sandbox = 1
    case production = 2
}
