//
//  ConnectionIntegrationTest.swift
//  Example
//
//  Created by John Nilsen on 7/26/16.
//  Copyright © 2016 Tapglue. All rights reserved.
//

import XCTest

import XCTest
import Tapglue
import RxSwift
import Nimble
import RxBlocking

class ConnectionIntegrationTest: XCTestCase {
    
    let username1 = "ConnectionInteractionTestUser1"
    let username2 = "ConnectionInteractionTestUser2"
    let password = "ConnectionInteractionTestPassword"
    let tapglue = RxTapglue(configuration: Configuration())
    var user1 = User()
    var user2 = User()
    
    override func setUp() {
        super.setUp()
        user1.username = username1
        user1.password = password
        
        user2.username = username2
        user2.password = password
        
        do {
            user1 = try tapglue.createUser(user1).toBlocking().first()!
            user2 = try tapglue.createUser(user2).toBlocking().first()!
        } catch {
            fail("failed to create and login user for integration tests")
        }
    }
    
    override func tearDown() {
        super.tearDown()
        do {
            try tapglue.loginUser(username1, password: password).toBlocking().first()
            try tapglue.deleteCurrentUser().toBlocking().first()
            
            try tapglue.loginUser(username2, password: password).toBlocking().first()
            try tapglue.deleteCurrentUser().toBlocking().first()
        } catch {
            fail("failed to login and delete user for integration tests")
        }
    }
    
    func testCreateAndDeleteConnection() throws {
        user1 = try tapglue.loginUser(username1, password: password).toBlocking().first()!
        let connection = try tapglue.createConnection(Connection(toUserId: user2.id!, type: .Follow, state: .Confirmed)).toBlocking().first()
        expect(connection).toEventuallyNot(beNil())
        
        var wasDeleted = false
        _ = tapglue.deleteConnection(toUserId: user2.id!, type: .Follow).subscribeCompleted {
            wasDeleted = true
        }
        expect(wasDeleted).toEventually(beTrue())
    }
    
    func testRetrieveFollowersWhenNone() throws {
        user1 = try tapglue.loginUser(username1, password: password).toBlocking().first()!
        let followers = try tapglue.retrieveFollowers().toBlocking().first()!
        
        expect(followers.count).to(equal(0))
    }
    
    func testRetrieveFollowers() throws {
        user1 = try tapglue.loginUser(username1, password: password).toBlocking().first()!
        _ = try tapglue.createConnection(Connection(toUserId: user2.id!, type: .Follow, state: .Confirmed)).toBlocking().first()
        
        user2 = try tapglue.loginUser(username2, password: password).toBlocking().first()!
        let followers = try tapglue.retrieveFollowers().toBlocking().first()!
        
        expect(followers.count).to(equal(1))
        expect(followers[0].id).to(equal((user1.id!)))
        
        _ = try tapglue.deleteConnection(toUserId: user2.id!, type: .Follow).toBlocking().first()
    }
    
    func testRetrieveFollowings() throws {
        user1 = try tapglue.loginUser(username1, password: password).toBlocking().first()!
        _ = try tapglue.createConnection(Connection(toUserId: user2.id!, type: .Follow, state: .Confirmed)).toBlocking().first()
        
        let followings = try tapglue.retrieveFollowings().toBlocking().first()!
        
        expect(followings.count).toEventually(equal(1))
        expect(followings[0].id).toEventually(equal((user2.id!)))
        
        _ = try tapglue.deleteConnection(toUserId: user2.id!, type: .Follow).toBlocking().first()
    }
}
