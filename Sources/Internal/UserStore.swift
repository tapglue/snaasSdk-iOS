//
//  UserStore.swift
//  Tapglue
//
//  Created by John Nilsen on 7/20/16.
//  Copyright © 2016 Tapglue. All rights reserved.
//

import Foundation

class UserStore {
    static let tapglueDefaults = "tapglueDefaults"
    static let currentUserTag = "currentUser"
    
    var user: User? {
        get {
            let userDictionary = NSUserDefaults(suiteName: UserStore.tapglueDefaults)?.dictionaryForKey(UserStore.currentUserTag)
            
            if let userDictionary = userDictionary {
                return User(JSON: userDictionary)
            }
            return nil
        }
        set {
            if let user = newValue {
                NSUserDefaults(suiteName: UserStore.tapglueDefaults)?.setObject(user.toJSON(), forKey: UserStore.currentUserTag)
            } else {
//                NSUserDefaults(suiteName: UserStore.tapglueDefaults)?.setObject(nil, forKey: UserStore.currentUserTag)
                NSUserDefaults(suiteName: UserStore.tapglueDefaults)?.removeObjectForKey(UserStore.currentUserTag)
                
            }
        }
    }
}