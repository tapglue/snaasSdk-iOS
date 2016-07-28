//
//  TapglueSims.swift
//  simsTest
//
//  Created by John Nilsen on 5/17/16.
//  Copyright © 2016 John Nilsen. All rights reserved.
//

import UIKit

public class TapglueSims : NSObject, SessionTokenListener {
    let appToken: String
    var sessionToken: String?
    var deviceToken: String?
    var api : SimsApi
    
    public convenience init(withConfiguration config: Configuration) {
        self.init(withConfiguration: config, environment: Environment.Production)
    }
    
    public init(withConfiguration config: Configuration, environment: Environment) {
        self.appToken = config.appToken
        api = DefaultSimsApi(url: config.baseUrl, environment: environment)
        super.init()
        Router.sessionTokenListener = self
    }
    
    public func registerSimsNotificationSettings(application: UIApplication) {
        let notificationSettings = UIUserNotificationSettings(
            forTypes: [.Badge, .Sound, .Alert], categories: nil)
        application.registerUserNotificationSettings(notificationSettings)
    }
    
    public func registerDeviceToken(deviceToken: NSData) {
        let tokenChars = UnsafePointer<CChar>(deviceToken.bytes)
        var tokenString = ""
        
        for i in 0..<deviceToken.length {
            tokenString += String(format: "%02.2hhx", arguments: [tokenChars[i]])
        }
        
        print("Device Token:", tokenString)
        self.deviceToken = tokenString
        registerSims()
    }
    
    func sessionTokenSet(sessionToken: String?) {
        print("sessionTokenSet: \(sessionToken)")
        self.sessionToken = sessionToken
        registerSims()
    }
    
    private func registerSims() {
        if let deviceToken = deviceToken {
            if let sessionToken = sessionToken {
                registerDeviceOnApiWithAppToken(appToken, deviceToken: deviceToken, sessionToken: sessionToken)
            }
        }
    }
    
    private func registerDeviceOnApiWithAppToken(appToken: String, deviceToken: String, sessionToken: String) {
        api.registerDevice(appToken, deviceToken: deviceToken, sessionToken: sessionToken)
    }
}

public enum Environment: Int {
    case Sandbox = 1
    case Production = 2
}