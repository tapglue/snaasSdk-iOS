//
//  TapglueTests.swift
//  TapglueTests
//
//  Created by John Nilsen on 6/27/16.
//  Copyright © 2016 Tapglue. All rights reserved.
//

import XCTest
import RxSwift
import Nimble
@testable import Tapglue

class TapglueTests: XCTestCase {
    
    let tapglue = Tapglue()
    let network = TestNetwork()
    
    override func setUp() {
        super.setUp()
        tapglue.network = network
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testLoginUser() {
        var networkUser =  User()
        _ = tapglue.loginUser("paco", password: "1234").subscribeNext({ user in
            networkUser = user
        })
        expect(networkUser.id).toEventually(equal(network.testUserId))
    }
    
    func testRefreshCurrentUser() {
        var networkUser = User()
        _ = tapglue.refreshCurrentUser().subscribeNext { user in
            networkUser = user
        }
        expect(networkUser.id).toEventually(equal(network.testUserId))
    }

    func testRetrieveFollowers() {
        var networkFollowers = [User]()
        _ = tapglue.retrieveFollowers().subscribeNext { users in
            networkFollowers = users
        }
        expect(networkFollowers).to(contain(network.testUser))
    }

    func testCreateUser() {
        var createdUser = User()
        _ = tapglue.createUser(network.testUser).subscribeNext { user in
            createdUser = user
        }
        expect(createdUser.id).toEventually(equal(network.testUser.id))
    }

    func testUpdateUser() {
        var updatedUser = User()
        _ = tapglue.updateCurrentUser(network.testUser).subscribeNext { user in
            updatedUser = user
        }
        expect(updatedUser.id).to(equal(network.testUser.id))
    }
}

class TestNetwork: Network {
    
    
    let testUserId = "testUserId"
    let testUser: User
    
    override init() {
        testUser = User()
        testUser.id = testUserId
    }
    
    override func loginUser(username: String, password: String) -> Observable<User> {
        return Observable.create { observer in
            observer.on(.Next(self.testUser))
            observer.on(.Completed)
            return NopDisposable.instance
        }
    }

    override func createUser(user: User) -> Observable<User> {
        return Observable.create { observer in
            observer.on(.Next(self.testUser))
            observer.on(.Completed)
            return NopDisposable.instance
        }

    }
    
    override func refreshCurrentUser() -> Observable<User> {
        return Observable.create { observer in
            observer.on(.Next(self.testUser))
            observer.on(.Completed)
            return NopDisposable.instance
        }
    }
    
    override func updateCurrentUser(user: User) -> Observable<User> {
        return Observable.create { observer in
            observer.on(.Next(self.testUser))
            observer.on(.Completed)
            return NopDisposable.instance
        }
    }

    override func retrieveFollowers() -> Observable<[User]> {
        return Observable.create { observer in
            observer.on(.Next([self.testUser]))
            observer.on(.Completed)
            return NopDisposable.instance
        }
    }
}