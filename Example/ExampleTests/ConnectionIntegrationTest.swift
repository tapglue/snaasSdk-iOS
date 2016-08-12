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
    let socialId1 = "connectionTestSocialId1"
    let socialId2 = "connectionTestSocialId2"
    let password = "ConnectionInteractionTestPassword"
    let socialPlatform = "insta"
    let tapglue = RxTapglue(configuration: Configuration())
    var user1 = User()
    var user2 = User()
    
    override func setUp() {
        super.setUp()
        user1.username = username1
        user1.socialIds = [socialPlatform: socialId1]
        user1.password = password
        
        user2.username = username2
        user2.socialIds = [socialPlatform: socialId2]
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

    func testRetrieveFollowersForUser() throws {
        user1 = try tapglue.loginUser(username1, password: password).toBlocking().first()!
        _ = try tapglue.createConnection(Connection(toUserId: user2.id!, type: .Follow, state: .Confirmed)).toBlocking().first()

        let followers = try tapglue.retrieveFollowersForUserId(user2.id!).toBlocking().first()!
        
        expect(followers.count).to(equal(1))
        expect(followers[0].id).to(equal((user1.id!)))
        
        _ = try tapglue.deleteConnection(toUserId: user2.id!, type: .Follow).toBlocking().first()
    }

    func testRetrieveFollowingsForUser() throws {
        user1 = try tapglue.loginUser(username1, password: password).toBlocking().first()!
        _ = try tapglue.createConnection(Connection(toUserId: user2.id!, type: .Follow, state: .Confirmed)).toBlocking().first()

        let followings = try tapglue.retrieveFollowingsForUserId(user1.id!).toBlocking().first()!
        
        expect(followings.count).to(equal(1))
        expect(followings[0].id).to(equal((user2.id!)))
        
        _ = try tapglue.deleteConnection(toUserId: user2.id!, type: .Follow).toBlocking().first()
    }
    
    
    func testRetrieveFriendsForUser() throws {
        user1 = try tapglue.loginUser(username1, password: password).toBlocking().first()!
        _ = try tapglue.createConnection(Connection(toUserId: user2.id!, type: .Friend, state: .Confirmed)).toBlocking().first()
        
        let friends = try tapglue.retrieveFriends().toBlocking().first()!
        
        expect(friends.count).to(equal(1))
        expect(friends[0].id).to(equal((user2.id!)))
        
        _ = try tapglue.deleteConnection(toUserId: user2.id!, type: .Friend).toBlocking().first()
    }
    
    func testRetrieveFriendsForUserById() throws {
        user1 = try tapglue.loginUser(username1, password: password).toBlocking().first()!
        _ = try tapglue.createConnection(Connection(toUserId: user2.id!, type: .Friend, state: .Confirmed)).toBlocking().first()
        
        let friends = try tapglue.retrieveFriendsForUserId(user2.id!).toBlocking().first()!
        
        expect(friends.count).to(equal(1))
        expect(friends[0].id).to(equal((user1.id!)))
        
        _ = try tapglue.deleteConnection(toUserId: user2.id!, type: .Friend).toBlocking().first()
    }
    
    func testRetrievePendingConnectionsForIncoming() throws {
        user1 = try tapglue.loginUser(username1, password: password).toBlocking().first()!
        _ = try tapglue.createConnection(Connection(toUserId: user2.id!, type: .Friend, state: .Pending)).toBlocking().first()
        
        user2 = try tapglue.loginUser(username2, password: password).toBlocking().first()!
        let connections = try tapglue.retrievePendingConnections().toBlocking().first()!
        let incoming = connections.incoming
        expect(incoming?.count).to(equal(1))
        expect(incoming?.first?.userFrom?.id).to(equal(user1.id))
    }
    
    
    func testRespondToPendingConnection() throws {
        user1 = try tapglue.loginUser(username1, password: password).toBlocking().first()!
        _ = try tapglue.createConnection(Connection(toUserId: user2.id!, type: .Friend, state: .Pending)).toBlocking().first()
        
        user2 = try tapglue.loginUser(username2, password: password).toBlocking().first()!

        _ = try tapglue.createConnection(Connection(toUserId: user1.id!, type: .Friend, state: .Confirmed)).toBlocking().first()
        let connections = try tapglue.retrieveFriends().toBlocking().first()!
        expect(connections.first?.id).to(equal(user1.id))
    }
    
    func testRetrievePendingConnectionsForOutgoing() throws {
        user1 = try tapglue.loginUser(username1, password: password).toBlocking().first()!
        _ = try tapglue.createConnection(Connection(toUserId: user2.id!, type: .Friend, state: .Pending)).toBlocking().first()
        
        let connections = try tapglue.retrievePendingConnections().toBlocking().first()!
        let outgoing = connections.outgoing
        expect(outgoing?.count).to(equal(1))
        expect(outgoing?.first?.userTo?.id).to(equal(user2.id))
    }
    
    func testRetrieveRejectedConnectionsForIncoming() throws {
        user1 = try tapglue.loginUser(username1, password: password).toBlocking().first()!
        _ = try tapglue.createConnection(Connection(toUserId: user2.id!, type: .Friend, state: .Rejected)).toBlocking().first()
        
        user2 = try tapglue.loginUser(username2, password: password).toBlocking().first()!
        let connections = try tapglue.retrieveRejectedConnections().toBlocking().first()!
        let incoming = connections.incoming
        expect(incoming?.count).to(equal(1))
        expect(incoming?.first?.userFrom?.id).to(equal(user1.id))
    }
    
    func testRetrieveRejectedConnectionsForOutgoing() throws {
        user1 = try tapglue.loginUser(username1, password: password).toBlocking().first()!
        _ = try tapglue.createConnection(Connection(toUserId: user2.id!, type: .Friend, state: .Rejected)).toBlocking().first()
        
        let connections = try tapglue.retrieveRejectedConnections().toBlocking().first()!
        let outgoing = connections.outgoing
        expect(outgoing?.count).to(equal(1))
        expect(outgoing?.first?.userTo?.id).to(equal(user2.id))
    }

    func testCreateSocialConnections() throws {
        user1 = try tapglue.loginUser(username1, password: password).toBlocking().first()!
        let connections = SocialConnections(platform: socialPlatform, type: .Follow, 
            userSocialId: socialId1, socialIds: [socialId2])
        let users = try tapglue.createSocialConnections(connections).toBlocking().first()!
        expect(users.first?.username).to(equal(username2))
    }
}
