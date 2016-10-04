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
        let followers = try (tapglue.retrieveFollowers() as Observable<[User]>).toBlocking().first()!
        
        expect(followers.count).to(equal(0))
    }
    
    func testRetrieveFollowers() throws {
        user1 = try tapglue.loginUser(username1, password: password).toBlocking().first()!
        _ = try tapglue.createConnection(Connection(toUserId: user2.id!, type: .Follow, state: .Confirmed)).toBlocking().first()
        
        user2 = try tapglue.loginUser(username2, password: password).toBlocking().first()!
        let followers = try (tapglue.retrieveFollowers() as Observable<[User]>).toBlocking().first()!
        
        expect(followers.count).to(equal(1))
        expect(followers[0].id).to(equal((user1.id!)))
        
        _ = try tapglue.deleteConnection(toUserId: user2.id!, type: .Follow).toBlocking().first()
    }
    
    func testRetrieveFollowings() throws {
        user1 = try tapglue.loginUser(username1, password: password).toBlocking().first()!
        _ = try tapglue.createConnection(Connection(toUserId: user2.id!, type: .Follow, state: .Confirmed)).toBlocking().first()
        
        let followings = try (tapglue.retrieveFollowings() as Observable<[User]>).toBlocking().first()!
        
        expect(followings.count).toEventually(equal(1))
        expect(followings[0].id).toEventually(equal((user2.id!)))
        
        _ = try tapglue.deleteConnection(toUserId: user2.id!, type: .Follow).toBlocking().first()
    }

    func testRetrieveFollowersForUser() throws {
        user1 = try tapglue.loginUser(username1, password: password).toBlocking().first()!
        _ = try tapglue.createConnection(Connection(toUserId: user2.id!, type: .Follow, state: .Confirmed)).toBlocking().first()

        let followers = try (tapglue.retrieveFollowersForUserId(user2.id!) as Observable<[User]>).toBlocking().first()!
        
        expect(followers.count).to(equal(1))
        expect(followers[0].id).to(equal((user1.id!)))
        
        _ = try tapglue.deleteConnection(toUserId: user2.id!, type: .Follow).toBlocking().first()
    }

    func testRetrieveFollowingsForUser() throws {
        user1 = try tapglue.loginUser(username1, password: password).toBlocking().first()!
        _ = try tapglue.createConnection(Connection(toUserId: user2.id!, type: .Follow, state: .Confirmed)).toBlocking().first()

        let followings = try (tapglue.retrieveFollowingsForUserId(user1.id!) as Observable<[User]>).toBlocking().first()!
        
        expect(followings.count).to(equal(1))
        expect(followings[0].id).to(equal((user2.id!)))
        
        _ = try tapglue.deleteConnection(toUserId: user2.id!, type: .Follow).toBlocking().first()
    }
    
    
    func testRetrieveFriendsForUser() throws {
        user1 = try tapglue.loginUser(username1, password: password).toBlocking().first()!
        _ = try tapglue.createConnection(Connection(toUserId: user2.id!, type: .Friend, state: .Confirmed)).toBlocking().first()
        
        let friends = try (tapglue.retrieveFriends() as Observable<[User]>).toBlocking().first()!
        
        expect(friends.count).to(equal(1))
        expect(friends[0].id).to(equal((user2.id!)))
        
        _ = try tapglue.deleteConnection(toUserId: user2.id!, type: .Friend).toBlocking().first()
    }
    
    func testRetrieveFriendsForUserById() throws {
        user1 = try tapglue.loginUser(username1, password: password).toBlocking().first()!
        _ = try tapglue.createConnection(Connection(toUserId: user2.id!, type: .Friend, state: .Confirmed)).toBlocking().first()
        
        let friends = try (tapglue.retrieveFriendsForUserId(user2.id!) as Observable<[User]>).toBlocking().first()!
        
        expect(friends.count).to(equal(1))
        expect(friends[0].id).to(equal((user1.id!)))
        
        _ = try tapglue.deleteConnection(toUserId: user2.id!, type: .Friend).toBlocking().first()
    }
    
    func testRetrievePendingConnectionsForIncoming() throws {
        user1 = try tapglue.loginUser(username1, password: password).toBlocking().first()!
        _ = try tapglue.createConnection(Connection(toUserId: user2.id!, type: .Friend, state: .Pending)).toBlocking().first()
        
        user2 = try tapglue.loginUser(username2, password: password).toBlocking().first()!
        var connections: Connections
        connections = try tapglue.retrievePendingConnections().toBlocking().first()!
        let incoming = connections.incoming
        expect(incoming?.count).to(equal(1))
        expect(incoming?.first?.userFrom?.id).to(equal(user1.id))
    }
    
    
    func testRespondToPendingConnection() throws {
        user1 = try tapglue.loginUser(username1, password: password).toBlocking().first()!
        _ = try tapglue.createConnection(Connection(toUserId: user2.id!, type: .Friend, state: .Pending)).toBlocking().first()
        
        user2 = try tapglue.loginUser(username2, password: password).toBlocking().first()!

        _ = try tapglue.createConnection(Connection(toUserId: user1.id!, type: .Friend, state: .Confirmed)).toBlocking().first()
        let connections = try (tapglue.retrieveFriends() as Observable<[User]>).toBlocking().first()!
        expect(connections.first?.id).to(equal(user1.id))
    }
    
    func testRetrievePendingConnectionsForOutgoing() throws {
        user1 = try tapglue.loginUser(username1, password: password).toBlocking().first()!
        _ = try tapglue.createConnection(Connection(toUserId: user2.id!, type: .Friend, state: .Pending)).toBlocking().first()
        
        var connections: Connections
        connections = try tapglue.retrievePendingConnections().toBlocking().first()!
        let outgoing = connections.outgoing
        expect(outgoing?.count).to(equal(1))
        expect(outgoing?.first?.userTo?.id).to(equal(user2.id))
    }
    
    func testRetrieveRejectedConnectionsForIncoming() throws {
        user1 = try tapglue.loginUser(username1, password: password).toBlocking().first()!
        _ = try tapglue.createConnection(Connection(toUserId: user2.id!, type: .Friend, state: .Rejected)).toBlocking().first()
        
        user2 = try tapglue.loginUser(username2, password: password).toBlocking().first()!
        var connections: Connections
        connections = try tapglue.retrieveRejectedConnections().toBlocking().first()!
        let incoming = connections.incoming
        expect(incoming?.count).to(equal(1))
        expect(incoming?.first?.userFrom?.id).to(equal(user1.id))
    }
    
    func testRetrieveRejectedConnectionsForOutgoing() throws {
        user1 = try tapglue.loginUser(username1, password: password).toBlocking().first()!
        _ = try tapglue.createConnection(Connection(toUserId: user2.id!, type: .Friend, state: .Rejected)).toBlocking().first()
        
        var connections: Connections
        connections = try tapglue.retrieveRejectedConnections().toBlocking().first()!
        let outgoing = connections.outgoing
        expect(outgoing?.count).to(equal(1))
        expect(outgoing?.first?.userTo?.id).to(equal(user2.id))
    }

    func testCreateSocialConnections() throws {
        user1 = try tapglue.loginUser(username1, password: password).toBlocking().first()!
        let connections = SocialConnections(platform: socialPlatform, type: .Follow, 
            userSocialId: socialId1, socialIds: [socialId2])
        let users = try (tapglue.createSocialConnections(connections) 
            as Observable<[User]>).toBlocking().first()!
        expect(users.first?.username).to(equal(username2))
    }

    func testCreatePaginatedSocialConnections() throws {
        user1 = try tapglue.loginUser(username1, password: password).toBlocking().first()!
        let connections = SocialConnections(platform: socialPlatform, type: .Follow, 
            userSocialId: socialId1, socialIds: [socialId2])
        let page = try (tapglue.createSocialConnections(connections) 
            as Observable<RxPage<User>>).toBlocking().first()!
        expect(page.data.first?.username).to(equal(username2))
    }

    func testCreatePaginatedSocialConnectionsSecondPage() throws {
        user1 = try tapglue.loginUser(username1, password: password).toBlocking().first()!
        let connections = SocialConnections(platform: socialPlatform, type: .Follow, 
            userSocialId: socialId1, socialIds: [socialId2])
        let page = try (tapglue.createSocialConnections(connections) 
            as Observable<RxPage<User>>).toBlocking().first()!
        let secondPage = try page.previous.toBlocking().first()!
        expect(secondPage.data).toNot(beNil())
    }
    
    func testPaginatedFollowers() throws {
        user1 = try tapglue.loginUser(username1, password: password).toBlocking().first()!
        try tapglue.createConnection(Connection(toUserId: user2.id!, type: .Follow, state: .Confirmed)).toBlocking().first()
        user2 = try tapglue.loginUser(username2, password: password).toBlocking().first()!
        
        let page = try (tapglue.retrieveFollowers() as Observable<RxPage<User>>).toBlocking().first()!
        
        expect(page.data).toNot(beNil())
    }
    
    func testPaginatedFollowersWhenNone() throws {
        user1 = try tapglue.loginUser(username1, password: password).toBlocking().first()!
        
        let page = try (tapglue.retrieveFollowers() as Observable<RxPage<User>>).toBlocking().first()!
        
        expect(page.data.count).to(equal(0))
    }
    
    func testPaginatedFollowersPreviousPage() throws {
        user1 = try tapglue.loginUser(username1, password: password).toBlocking().first()!
        try tapglue.createConnection(Connection(toUserId: user2.id!, type: .Follow, state: .Confirmed)).toBlocking().first()
        user2 = try tapglue.loginUser(username2, password: password).toBlocking().first()!
        
        let page = try (tapglue.retrieveFollowers() as Observable<RxPage<User>>).toBlocking().first()!
        let prevPage = try page.previous.toBlocking().first()!
        
        expect(prevPage.data).toNot(beNil())
    }
    
    func testPaginatedFollowersCompletionHandler() throws {
        user1 = try tapglue.loginUser(username1, password: password).toBlocking().first()!
        try tapglue.createConnection(Connection(toUserId: user2.id!, type: .Follow, state: .Confirmed)).toBlocking().first()
        user2 = try tapglue.loginUser(username2, password: password).toBlocking().first()!
        
        let tg = Tapglue(configuration: Configuration())
        var networkPage: Page<User>?
        tg.retrieveFollowers() { (page:Page<User>?, error:ErrorType?) in
            networkPage = page
        }
        expect(networkPage).toEventuallyNot(beNil())
    }
    
    func testPaginatedFollowersPreviousPageCompletionHandler() throws {
        user1 = try tapglue.loginUser(username1, password: password).toBlocking().first()!
        try tapglue.createConnection(Connection(toUserId: user2.id!, type: .Follow, state: .Confirmed)).toBlocking().first()
        user2 = try tapglue.loginUser(username2, password: password).toBlocking().first()!
        
        let tg = Tapglue(configuration: Configuration())
        var secondPage: Page<User>?
        tg.retrieveFollowers() { (page: Page<User>?, error: ErrorType?) in
            page?.previous() { (page:Page<User>?, error: ErrorType?) in
                secondPage = page
            }
        }

        expect(secondPage).toEventuallyNot(beNil())
    }
    
    func testPaginatedFollowings() throws {
        user1 = try tapglue.loginUser(username1, password: password).toBlocking().first()!
        try tapglue.createConnection(Connection(toUserId: user2.id!, type: .Follow, state: .Confirmed)).toBlocking().first()
        
        let page = try (tapglue.retrieveFollowings() as Observable<RxPage<User>>)
            .toBlocking().first()!
        
        expect(page.data).toNot(beNil())
    }


    func testRetrievePaginatedFollowersForUser() throws {
        user1 = try tapglue.loginUser(username1, password: password).toBlocking().first()!
        _ = try tapglue.createConnection(Connection(toUserId: user2.id!, type: .Follow, state: .Confirmed)).toBlocking().first()

        let followers = try (tapglue.retrieveFollowersForUserId(user2.id!) 
            as Observable<RxPage<User>>).toBlocking().first()!
        
        expect(followers.data.count).to(equal(1))
        expect(followers.data[0].id).to(equal((user1.id!)))
        
        _ = try tapglue.deleteConnection(toUserId: user2.id!, type: .Follow).toBlocking().first()
    }

    func testRetrievePaginatedFollowingsForUser() throws {
        user1 = try tapglue.loginUser(username1, password: password).toBlocking().first()!
        _ = try tapglue.createConnection(Connection(toUserId: user2.id!, type: .Follow, state: .Confirmed)).toBlocking().first()

        let followings = try (tapglue.retrieveFollowingsForUserId(user1.id!) 
            as Observable<RxPage<User>>).toBlocking().first()!
        
        expect(followings.data.count).to(equal(1))
        expect(followings.data[0].id).to(equal((user2.id!)))
        
        _ = try tapglue.deleteConnection(toUserId: user2.id!, type: .Follow).toBlocking().first()
    }
    
    
    func testRetrievePaginatedFriendsForUser() throws {
        user1 = try tapglue.loginUser(username1, password: password).toBlocking().first()!
        _ = try tapglue.createConnection(Connection(toUserId: user2.id!, type: .Friend, state: .Confirmed)).toBlocking().first()
        
        let friends = try (tapglue.retrieveFriends() 
            as Observable<RxPage<User>>).toBlocking().first()!
        
        expect(friends.data.count).to(equal(1))
        expect(friends.data[0].id).to(equal((user2.id!)))
        
        _ = try tapglue.deleteConnection(toUserId: user2.id!, type: .Friend).toBlocking().first()
    }
    
    func testRetrievePaginatedFriendsForUserById() throws {
        user1 = try tapglue.loginUser(username1, password: password).toBlocking().first()!
        _ = try tapglue.createConnection(Connection(toUserId: user2.id!, type: .Friend, state: .Confirmed)).toBlocking().first()
        
        let friends = try (tapglue.retrieveFriendsForUserId(user2.id!) 
            as Observable<RxPage<User>>).toBlocking().first()!
        
        expect(friends.data.count).to(equal(1))
        expect(friends.data[0].id).to(equal((user1.id!)))
        
        _ = try tapglue.deleteConnection(toUserId: user2.id!, type: .Friend).toBlocking().first()
    }
    
    func testPaginatedRetrievePendingConnectionsForIncoming() throws {
        user1 = try tapglue.loginUser(username1, password: password).toBlocking().first()!
        _ = try tapglue.createConnection(Connection(toUserId: user2.id!, type: .Friend, state: .Pending)).toBlocking().first()
        
        user2 = try tapglue.loginUser(username2, password: password).toBlocking().first()!
        var connections: RxCompositePage<Connections>
        connections = try tapglue.retrievePendingConnections().toBlocking().first()!
        let incoming = connections.data.incoming
        expect(incoming?.count).to(equal(1))
        expect(incoming?.first?.userFrom?.id).to(equal(user1.id))
    }
    
    
    func testPaginatedRespondToPendingConnection() throws {
        user1 = try tapglue.loginUser(username1, password: password).toBlocking().first()!
        _ = try tapglue.createConnection(Connection(toUserId: user2.id!, type: .Friend, state: .Pending)).toBlocking().first()
        
        user2 = try tapglue.loginUser(username2, password: password).toBlocking().first()!

        _ = try tapglue.createConnection(Connection(toUserId: user1.id!, type: .Friend, state: .Confirmed)).toBlocking().first()
        let connections = try (tapglue.retrieveFriends() as Observable<[User]>).toBlocking().first()!
        expect(connections.first?.id).to(equal(user1.id))
    }
    
    func testPaginatedRetrievePendingConnectionsForOutgoing() throws {
        user1 = try tapglue.loginUser(username1, password: password).toBlocking().first()!
        _ = try tapglue.createConnection(Connection(toUserId: user2.id!, type: .Friend, state: .Pending)).toBlocking().first()
        
        var connections: RxCompositePage<Connections>
        connections = try tapglue.retrievePendingConnections().toBlocking().first()!
        let outgoing = connections.data.outgoing
        expect(outgoing?.count).to(equal(1))
        expect(outgoing?.first?.userTo?.id).to(equal(user2.id))
    }
    
    func testPaginatedRetrieveRejectedConnectionsForIncoming() throws {
        user1 = try tapglue.loginUser(username1, password: password).toBlocking().first()!
        _ = try tapglue.createConnection(Connection(toUserId: user2.id!, type: .Friend, state: .Rejected)).toBlocking().first()
        
        user2 = try tapglue.loginUser(username2, password: password).toBlocking().first()!
        var connections: RxCompositePage<Connections>
        connections = try tapglue.retrieveRejectedConnections().toBlocking().first()!
        let incoming = connections.data.incoming
        expect(incoming?.count).to(equal(1))
        expect(incoming?.first?.userFrom?.id).to(equal(user1.id))
    }
    
    func testPaginatedRetrieveRejectedConnectionsForOutgoing() throws {
        user1 = try tapglue.loginUser(username1, password: password).toBlocking().first()!
        _ = try tapglue.createConnection(Connection(toUserId: user2.id!, type: .Friend, state: .Rejected)).toBlocking().first()
        
        var connections: RxCompositePage<Connections>
        connections = try tapglue.retrieveRejectedConnections().toBlocking().first()!
        let outgoing = connections.data.outgoing
        expect(outgoing?.count).to(equal(1))
        expect(outgoing?.first?.userTo?.id).to(equal(user2.id))
    }
}
