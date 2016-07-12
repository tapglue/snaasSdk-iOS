//
//  TapglueTest.swift
//  Tapglue
//
//  Created by John Nilsen on 7/12/16.
//  Copyright © 2016 Tapglue. All rights reserved.
//

import XCTest
import Nimble
@testable import Tapglue

class TapglueTest: XCTestCase {

    let userId = "testUserId"
    let tapglue = Tapglue(configuration: Configuration())
    let network = TestNetwork()

    override func setUp() {
        super.setUp()
        tapglue.rxTapglue.network = network
    }
    
    override func tearDown() {
        super.tearDown()
    }

    func testLogin() {
        var callbackUser = User()
        tapglue.loginUser("user1", password: "1234") { user, error in
            callbackUser = user!
        }
        
        expect(callbackUser.id).toEventually(equal(userId))
    }

    func testCreateUser() {
        var callbackUser = User()
        tapglue.createUser(User()) { user, error in
            callbackUser = user!
        }
        expect(callbackUser.id).toEventually(equal(userId))
    }

    func testUpdateCurrentUser() {
        var callbackUser = User()
        tapglue.updateCurrentUser(User()) { user, error in
            callbackUser = user!
        }
        expect(callbackUser.id).toEventually(equal(userId))
    }

    func testRefreshCurrentUser() {
        var callbackUser = User()
        tapglue.refreshCurrentUser() { user, error in
            callbackUser = user!
        }
        expect(callbackUser.id).toEventually(equal(userId))
    }

    func testLogout() {
        var wasLoggedOut = false
        tapglue.logout() { success, error in 
            wasLoggedOut = success
        }
        expect(wasLoggedOut).toEventually(beTrue())
    }

    func testDeleteUser() {
        var wasDeleted = false
        tapglue.deleteCurrentUser() { success, error in
            wasDeleted = true
        }
        expect(wasDeleted).toEventually(beTrue())
    }

    func testRetrieveUser() {
        var callbackUser = User()
        tapglue.retrieveUser("id") { user, error in
            callbackUser = user!
        }
        expect(callbackUser.id).toEventually(equal(userId))
    }

    func testRetrieveFollowers() {
        var callbackUsers = [User]()
        tapglue.retrieveFollowers() { users, error in
            callbackUsers = users!
        }
        expect(callbackUsers).toEventually(contain(network.testUser))
    }
}
