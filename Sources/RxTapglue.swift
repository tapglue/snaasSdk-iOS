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
    
    var userStore = UserStore()
    
    var network: Network
    public private(set) var currentUser: User? {
        get {
            return userStore.user
        }
        set {
            userStore.user = newValue
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
        return network.loginUser(username, password: password).map(toCurrentUserMap)
    }

    public func updateCurrentUser(user: User) -> Observable<User> {
        return network.updateCurrentUser(user).map(toCurrentUserMap)
    }

    public func refreshCurrentUser() -> Observable<User> {
        return network.refreshCurrentUser().map(toCurrentUserMap)
    }

    public func logout() -> Observable<Void> {
        return network.logout().doOnCompleted {
            self.currentUser = nil
        }
    }
    
    public func deleteCurrentUser() -> Observable<Void> {
        return network.deleteCurrentUser().doOnCompleted {
            self.currentUser = nil
        }
    }

    public func retrieveFollowers() -> Observable<[User]> {
        return network.retrieveFollowers()
    }

    public func retrieveUser(id: String) -> Observable<User> {
        return network.retrieveUser(id)
    }

    private func toCurrentUserMap(user: User) -> User {
        currentUser = user
        return user
    }
}