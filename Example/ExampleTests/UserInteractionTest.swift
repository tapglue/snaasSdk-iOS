//
//  UserInteractionTest.swift
//  Example
//
//  Created by John Nilsen on 7/12/16.
//  Copyright © 2016 Tapglue. All rights reserved.
//

import XCTest
import Tapglue
import RxSwift
import Nimble
import RxBlocking

class UserInteractionTest: XCTestCase {
    
    let username = "UserInteractionTestUser1"
    let password = "UserInteractionTestPassword"
    let tapglue = RxTapglue(configuration: Configuration())

    var username2: String?
    var password2: String?

    var user = User()
    var user2: User? = nil

    override func setUp() {
        super.setUp()
        user.username = username
        user.password = password
        
        do {
            user = try tapglue.createUser(user).toBlocking().first()!
            user = try tapglue.loginUser(username, password: password).toBlocking().first()!
        } catch {
            fail("failed to create and login user for integration tests")
        }
    }
    
    override func tearDown() {
        super.tearDown()
        do {
            _ = try tapglue.loginUser(username, password: password).toBlocking().first()
            try tapglue.deleteCurrentUser().toBlocking().first()

            if let username2 = username2,
                let password2 = password2 {
                _ = try tapglue.loginUser(username2, password: password2).toBlocking().first()
                try tapglue.deleteCurrentUser().toBlocking().first()
            }

        } catch {
            fail("failed to login and delete user for integration tests")
        }
    }
    
    func testLogout() {
        var wasLoggedOut = false
        _ = tapglue.logout().subscribe(onCompleted: {
            wasLoggedOut = true
        })
        expect(wasLoggedOut).toEventually(beTrue())
    }
    
    func testRefreshCurrentUser() {
        var wasRefreshed = false
        _ = tapglue.refreshCurrentUser().subscribe(onNext: { user in
            wasRefreshed = true
        })
        expect(wasRefreshed).toEventually(beTrue())
    }
    
    func testCurrentUserPersistedAfterLogin() {
        expect(self.tapglue.currentUser).toNot(beNil())
    }
    
    func testDifferentInstanceReturnsCurrentUser() {
        let altInstance = RxTapglue(configuration: Configuration())
        expect(altInstance.currentUser).toNot(beNil())
        expect(altInstance.currentUser?.username).to(equal(tapglue.currentUser?.username))
    }
    
    func testLogoutDeletesCurrentUserProperty() throws {
        try tapglue.logout().toBlocking().first()
        expect(self.tapglue.currentUser).to(beNil())
    }
    
    func testUserLoginError() {
        var tapglueError: TapglueError?
        _ = tapglue.loginUser(username, password: "wrongPassword").subscribe(onError: { error in
            tapglueError = error as? TapglueError
        })
        
        expect(tapglueError?.code ?? -1).toEventually(equal(0))
    }
    
    func testRetrieveUser() {
        let user = tapglue.retrieveUser((tapglue.currentUser?.id)!)
        expect(user).toNot(beNil())
    }

    func testUpdateWithMetadata() throws {
        user.metadata = ["someKey": "someValue"]
        let updatedUser = try tapglue.updateCurrentUser(user).toBlocking().first()!
        expect(updatedUser.metadata).toNot(beNil())
        expect(updatedUser.metadata?["someKey"]).to(equal("someValue"))
    }

    func testCreateInvite() throws {
        var error: TapglueError?
        _ = tapglue.createInvite("invite_code", "asdf_1234").subscribe( onError: { (err) in
            error = err as? TapglueError
        })

        expect(error).toEventually(beNil())
    }

    func testCreateUserWithInvite() throws {
        let invitecode = "0xff66cc"
        _ = try tapglue.createInvite("invite_code", invitecode).toBlocking().first()

        username2 = "UserInteractionTestUser1335"
        password2 = "UserInteractionTestPassword"
        let u = User()
        u.username = username2
        u.password = password2
        u.socialIds = ["invite_code": invitecode]

        user2 = try tapglue.createUser(u, inviteConnections: "friend").toBlocking().first()!
        user2 = try tapglue.loginUser(username2!, password: password2!).toBlocking().first()!

        var friends: RxPage<User>
        friends = try tapglue.retrieveFriends().toBlocking().first()!

        expect(friends.data.count).to(equal(0))

        var connections: RxCompositePage<Connections>
        connections = try tapglue.retrievePendingConnections().toBlocking().first()!
        let incoming = connections.data.incoming
        expect(incoming?.count).to(equal(1))
        expect(incoming?.first?.userFrom?.id).to(equal(user.id))
    }
}
