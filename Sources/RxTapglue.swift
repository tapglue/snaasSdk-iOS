//
//  Tapglue.swift
//  Tapglue
//
//  Created by John Nilsen on 6/27/16.
//  Copyright © 2016 Tapglue. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireObjectMapper
import RxSwift

public class RxTapglue {
    
    static let tapglueDefaults = "tapglueDefaults"
    static let currentUserTag = "currentUser"
    
    var network: Network
    public private(set) var currentUser: User? {
        get {
            let userDictionary = NSUserDefaults(suiteName: RxTapglue.tapglueDefaults)?.dictionaryForKey(RxTapglue.currentUserTag)
            
            if let userDictionary = userDictionary {
                return User(JSON: userDictionary)
            }
            return nil
        }
        set {
            if let user = newValue {
                NSUserDefaults(suiteName: RxTapglue.tapglueDefaults)?.setObject(user.toJSON(), forKey: RxTapglue.currentUserTag)
            } else {
                NSUserDefaults(suiteName: RxTapglue.tapglueDefaults)?.removeObjectForKey(RxTapglue.currentUserTag)
            }
        }
    }
    
    public init(configuration: Configuration) {
        Router.configuration = configuration
        network = Network()
    }
    
    public func createUser(user: User) -> Observable<User> {
        return network.createUser(user)
    }
    
    public func loginUser(username: String, password: String) -> Observable<User> {
        return network.loginUser(username, password: password).map { user in
            self.currentUser = user
            return user
        }
    }

    public func updateCurrentUser(user: User) -> Observable<User> {
        return network.updateCurrentUser(user)
    }

    public func refreshCurrentUser() -> Observable<User> {
        return network.refreshCurrentUser()
    }

    public func logout() -> Observable<Void> {
        return network.logout()
    }
    
    public func deleteCurrentUser() -> Observable<Void> {
        return network.deleteCurrentUser()
    }

    public func retrieveFollowers() -> Observable<[User]> {
        return network.retrieveFollowers()
    }

    public func retrieveUser(id: String) -> Observable<User> {
        return network.retrieveUser(id)
    }
}