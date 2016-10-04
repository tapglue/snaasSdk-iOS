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
            let userDictionary = UserDefaults(suiteName: UserStore.tapglueDefaults)?.dictionary(forKey: UserStore.currentUserTag)
            
            if let userDictionary = userDictionary {
                return User(JSON: userDictionary)
            }
            return nil
        }
        set {
            if let user = newValue {
                UserDefaults(suiteName: UserStore.tapglueDefaults)?.set(user.toJSON(), forKey: UserStore.currentUserTag)
            } else {
//                NSUserDefaults(suiteName: UserStore.tapglueDefaults)?
//                    .setObject(nil, forKey: UserStore.currentUserTag)
                UserDefaults(suiteName: UserStore.tapglueDefaults)?
                    .removeObject(forKey: UserStore.currentUserTag)
                
            }
        }
    }
}
