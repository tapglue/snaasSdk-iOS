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
            let userData = UserDefaults(suiteName: UserStore.tapglueDefaults)?.data(forKey: UserStore.currentUserTag)
			let decoder = JSONDecoder()
			
            
            if let userData = userData,
				let user = try? decoder.decode(User.self, from: userData) {
                return user
            }
            return nil
        }
        set {
            if let user = newValue {
				let encoder = JSONEncoder()
				let encoded = try? encoder.encode(user)

                UserDefaults(suiteName: UserStore.tapglueDefaults)?.set(encoded, forKey: UserStore.currentUserTag)
            } else {
//                NSUserDefaults(suiteName: UserStore.tapglueDefaults)?
//                    .setObject(nil, forKey: UserStore.currentUserTag)
                UserDefaults(suiteName: UserStore.tapglueDefaults)?
                    .removeObject(forKey: UserStore.currentUserTag)
                
            }
        }
    }
}
