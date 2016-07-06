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
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testCreateUser() {
        tapglue.createUser("paco", password: "1234")
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
}

class TestNetwork: Network {
    
    
    let testUserId = "testUserId"
    let testUser: User
    
    override init() {
        testUser = User()
        testUser.id = testUserId
    }
    
    override func loginUser(username: String, password: String) -> Observable<User> {
        return Observable.create({ observable -> Disposable in
            observable.on(.Next(self.testUser))
            observable.on(.Completed)
            return NopDisposable.instance
        })
    }
    
    override func refreshCurrentUser() -> Observable<User> {
        return Observable.create({ observable -> Disposable in
            observable.on(.Next(self.testUser))
            observable.on(.Completed)
            return NopDisposable.instance
        })
    }
}