//
//  TapglueTests.swift
//  TapglueTests
//
//  Created by John Nilsen on 6/27/16.
//  Copyright © 2016 Tapglue. All rights reserved.
//

import XCTest
import RxSwift
import Mockingjay
import Nimble
@testable import Tapglue

class RxTapglueTests: XCTestCase {
    
    let configuration = Configuration()
    var tapglue: RxTapglue!
    let network = TestNetwork()
    let userStore = TestUserStore()
    
    var analyticsSent = false
    
    override func setUp() {
        super.setUp()
        stub(http(.POST, uri: "/0.4/analytics"), builder: http(204))
        
        tapglue = RxTapglue(configuration: Configuration())
        tapglue.network = network
        tapglue.userStore = userStore
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
    
    func testLoginSetsCurrentUserToStore() {
        _ = tapglue.loginUser("paco", password: "1234").subscribe()
        expect(self.userStore.wasSet).toEventually(beTrue())
    }
    
    func testCurrentUserFetchFromStore() {
        let currentUser = tapglue.currentUser
        expect(currentUser?.username).toEventually(equal(self.userStore.testUserName))
    }
    
    func testRefreshCurrentUser() {
        var networkUser = User()
        _ = tapglue.refreshCurrentUser().subscribeNext { user in
            networkUser = user
        }
        expect(networkUser.id).toEventually(equal(network.testUserId))
    }

    func testRefreshCurrentUserSetsToStore() {
        _ = tapglue.refreshCurrentUser().subscribe()
        expect(self.userStore.wasSet).toEventually(beTrue())
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

    func testUpdateCurrentUserSetsToStore() {
        _ = tapglue.updateCurrentUser(User()).subscribe()
        expect(self.userStore.wasSet).toEventually(beTrue())
    }

    func testLogout() {
        var wasLoggedout = false
        _ = tapglue.logout().subscribeCompleted { _ in
            wasLoggedout = true
        }
        expect(wasLoggedout).toEventually(beTruthy())
    }

    func testLogoutResetsStore() {
        _ = tapglue.logout().subscribe()
        expect(self.userStore.wasReset).toEventually(beTrue())
    }

    func testDeleteUser() {
        var wasDeleted = false
        _ = tapglue.deleteCurrentUser().subscribeCompleted { void in
            wasDeleted = true
        }
        expect(wasDeleted).toEventually(beTruthy())
    }

    func testDeleteUserResetsStore() {
        _ = tapglue.deleteCurrentUser().subscribe()
        expect(self.userStore.wasReset).toEventually(beTrue())
    }

    func testRetrieveUser() {
        var networkUser = User()
        _ = tapglue.retrieveUser("1234").subscribeNext { user in
            networkUser = user
        }
        expect(networkUser.id).toEventually(equal(network.testUser.id))
    }

    func testRetrieveFollowers() {
        var networkFollowers = [User]()
        _ = tapglue.retrieveFollowers().subscribeNext { users in
            networkFollowers = users
        }
        expect(networkFollowers).to(contain(network.testUser))
    }
    
    func testCreatePost() {
        var createdPost = Post(visibility: .Public, attachments: [])
        _ = tapglue.createPost(network.testPost).subscribeNext { post in
            createdPost = post
        }
        expect(createdPost.id).toEventually(equal(network.testPost.id))
    }
    
    func testRetrievePost() {
        var networkPost = Post(visibility: .Private, attachments: [])
        _ = tapglue.retrievePost("1234").subscribeNext { post in
            networkPost = post
        }
        expect(networkPost.id).toEventually(equal(network.testPost.id))
    }
    
    func testUpdatePost() {
        var updatedPost = Post(visibility: .Connections, attachments: [])
        _ = tapglue.updatePost(network.testPost).subscribeNext { post in
            updatedPost = post
        }
        expect(updatedPost.id).to(equal(network.testPost.id))
    }
    
    func testDeletePost() {
        var wasDeleted = false
        _ = tapglue.deletePost("1234").subscribeCompleted { void in
            wasDeleted = true
        }
        expect(wasDeleted).toEventually(beTruthy())
    }
}

class TestNetwork: Network {
    
    
    let testUserId = "testUserId"
    let testUser: User
    let testPost: Post
    let testPostId = "testPostId"
    
    override init() {
        testUser = User()
        testUser.id = testUserId
        testPost = Post(visibility: .Connections, attachments: [])
        testPost.id = testPostId
    }
    
    override func loginUser(username: String, password: String) -> Observable<User> {
        return Observable.just(testUser)
    }

    override func createUser(user: User) -> Observable<User> {
        return Observable.just(testUser)
    }
    
    override func refreshCurrentUser() -> Observable<User> {
        return Observable.just(testUser)
    }
    
    override func updateCurrentUser(user: User) -> Observable<User> {
        return Observable.just(testUser)
    }

    override func logout() -> Observable<Void> {
        return Observable.create { observer in
            observer.on(.Completed)
            return NopDisposable.instance
        }
    }

    override func deleteCurrentUser() -> Observable<Void> {
        return Observable.create { observer in
            observer.on(.Completed)
            return NopDisposable.instance
        }
    }

    override func retrieveUser(id: String) -> Observable<User> {
        return Observable.just(testUser)
    }

    override func retrieveFollowers() -> Observable<[User]> {
        return Observable.just([testUser])
    }
    
    override func createPost(post: Post) -> Observable<Post> {
        return Observable.just(testPost)
    }

    override func retrievePost(id: String) -> Observable<Post> {
        return Observable.just(testPost)
    }

    override func updatePost(post: Post) -> Observable<Post> {
        return Observable.just(testPost)
    }

    override func deletePost(id: String) -> Observable<Void> {
        return Observable.create { observer in
            observer.on(.Completed)
            return NopDisposable.instance
        }
    }
}

class TestUserStore: UserStore {
    var wasSet = false
    var wasReset = false
    let testUserName = "TestUserStoreUsername"
    
    override var user: User? {
        get {
            let returnValue = User()
            returnValue.username = testUserName
            return returnValue
        }
        set {
            if newValue == nil {
                wasReset = true
            }
            wasSet = true
        }
    }
}