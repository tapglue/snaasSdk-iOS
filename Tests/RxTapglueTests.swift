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

    func testLoginWithEmail() {
        var networkUser = User()
        _ = tapglue.loginUserWithEmail("email@domain.com", password: "1234")
            .subscribeNext { user in
            networkUser = user
        }
        expect(networkUser.id).toEventually(equal(network.testUserId))
    }

    func testEmailLoginSetsCurrentUserToStore() {
        _ = tapglue.loginUserWithEmail("email@domain.com", password: "1234").subscribe()
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

    func testSearchUsers() {
        var networkUsers: [User]?
        _ = tapglue.searchUsersForSearchTerm("someTerm").subscribeNext { users in
            networkUsers = users
        }
        expect(networkUsers).toEventually(contain(network.testUser))
    }

    func testSearchEmails() {
        var networkUsers: [User]?
        _ = tapglue.searchEmails(["some@email.com"]).subscribeNext { users in
            networkUsers = users
        }
        expect(networkUsers).toEventually(contain(network.testUser))
    }

    func testSearchSocialIds() {
        var networkUsers: [User]?
        _ = tapglue.searchSocialIds(["someId"], onPlatform: "somePlatform").subscribeNext { 
            users in
            networkUsers = users
        }
        expect(networkUsers).toEventually(contain(network.testUser))
    }

    func testCreateConnection() {
        let connection = Connection(toUserId:"232", type: .Follow, state: .Confirmed)
        var networkConnection: Connection?
        _ = tapglue.createConnection(connection).subscribeNext { connection in
            networkConnection = connection
        }
        expect(networkConnection).toEventuallyNot(beNil())
    }

    func testDeleteConnection() {
        let userId = "2131"
        let type = ConnectionType.Follow
        var wasDeleted = false

        _ = tapglue.deleteConnection(toUserId: userId, type: type).subscribeCompleted {
            wasDeleted = true
        }

        expect(wasDeleted).toEventually(beTrue())
    }

    func testCreateSocialConnections() {
        var networkConnections: [User]?
        let connections = SocialConnections(platform: "f", type: .Friend, userSocialId: "s",
            socialIds: ["ids"])
        _ = tapglue.createSocialConnections(connections).subscribeNext { connections in
            networkConnections = connections
        }
        expect(networkConnections).toEventuallyNot(beNil())
    }

    func testRetrieveFollowers() {
        var networkFollowers = [User]()
        _ = tapglue.retrieveFollowers().subscribeNext { users in
            networkFollowers = users
        }
        expect(networkFollowers).to(contain(network.testUser))
    }

    func testRetrieveFollowings() {
        var networkFollowings = [User]()
        _ = tapglue.retrieveFollowings().subscribeNext { users in
            networkFollowings = users
        }
        expect(networkFollowings).to(contain(network.testUser))
    }

    func testRetrieveFollowersForUserId() {
        var networkFollowers = [User]()
        _ = tapglue.retrieveFollowersForUserId(network.testUserId).subscribeNext { users in
            networkFollowers = users
        }
        expect(networkFollowers).to(contain(network.testUser))
    }

    func testRetrieveFollowingsForUserId() {
        var networkFollowings = [User]()
        _ = tapglue.retrieveFollowingsForUserId(network.testUserId).subscribeNext { users in
            networkFollowings = users
        }
        expect(networkFollowings).to(contain(network.testUser))
    }

    func testRetrieveFriends() {
        var networkFriends = [User]()
        _ = tapglue.retrieveFriends().subscribeNext { users in
            networkFriends = users
        }
        expect(networkFriends).to(contain(network.testUser))
    }

    func testRetrieveFriendsForUserId() {
        var networkFriends = [User]()
        _ = tapglue.retrieveFriendsForUserId(network.testUserId).subscribeNext { users in
            networkFriends = users
        }
        expect(networkFriends).to(contain(network.testUser))
    }

    func testRetrievePendingConnections() {
        var networkConnections: Connections?
        _ = tapglue.retrievePendingConnections().subscribeNext { connections in
            networkConnections = connections
        }
        expect(networkConnections).toEventuallyNot(beNil())
    }

    func testRetrieveRejectedConnections() {
        var networkConnections: Connections?
        _ = tapglue.retrieveRejectedConnections().subscribeNext { connections in
            networkConnections = connections
        }
        expect(networkConnections).toEventuallyNot(beNil())
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
        _ = tapglue.updatePost("123", post: network.testPost).subscribeNext { post in
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

    func testRetrievePostsByUser() {
        var userPosts: [Post]?
        _ = tapglue.retrievePostsByUser("someUserId").subscribeNext { posts in
            userPosts = posts
        }
        expect(userPosts).toEventually(contain(network.testPost))
    }

    func testRetrieveAllPosts() {
        var networkPosts: [Post]?
        _ = tapglue.retrieveAllPosts().subscribeNext { posts in
            networkPosts = posts
        }
        expect(networkPosts).toEventually(contain(network.testPost))
    }

    func testFilterPostsByTags() {
        var networkPosts: [Post]?
        _ = tapglue.filterPostsByTags(["someTag"]).subscribeNext { posts in
            networkPosts = posts
        }
        expect(networkPosts).toEventuallyNot(beNil())
    }
    func testCreateComment() {
        let comment = Comment(contents: ["en":"content"], postId: "testPostId")
        var networkComment: Comment?
        _ = tapglue.createComment(comment).subscribeNext { comment in
            networkComment = comment
        }
        expect(networkComment?.id).toEventually(equal(network.testComment.id))
    }
    
    func testRetrieveComments() {
        var networkComments = [Comment]()
        _ = tapglue.retrieveComments(network.testPostId).subscribeNext { comments in
            networkComments = comments
        }
        expect(networkComments).to(contain(network.testComment))
    }
    
    func testUpdateComment() {
        var updatedComment = Comment(contents: ["en":"content"], postId: "testPostId")
        _ = tapglue.updateComment(network.testPostId, commentId: network.testCommentId, comment: network.testComment).subscribeNext { comment in
            updatedComment = comment
        }
        expect(updatedComment.id).to(equal(network.testComment.id))
    }
    
    func testDeleteComment() {
        var wasDeleted = false
        _ = tapglue.deleteComment(forPostId: "postId", commentId: "commentId").subscribeCompleted { void in
            wasDeleted = true
        }
        expect(wasDeleted).toEventually(beTruthy())
    }
    
    func testCreateLike() {
        var networkLike: Like?
        _ = tapglue.createLike(forPostId: "testPostId").subscribeNext { like in
            networkLike = like
        }
        expect(networkLike?.id).toEventually(equal(network.testLike.id))
    }
    
    func testRetrieveLikes() {
        var networkLikes = [Like]()
        _ = tapglue.retrieveLikes(network.testPostId).subscribeNext { likes in
            networkLikes = likes
        }
        expect(networkLikes).to(contain(network.testLike))
    }
    
    func testDeleteLike() {
        var wasDeleted = false
        _ = tapglue.deleteLike(forPostId: "postId").subscribeCompleted { void in
            wasDeleted = true
        }
        expect(wasDeleted).toEventually(beTruthy())
    }

    func testRetrievePostFeed() {
        var networkFeed: [Post]?
        _ = tapglue.retrievePostFeed().subscribeNext { posts in
            networkFeed = posts
        }
        expect(networkFeed).toEventually(contain(network.testPost))
    }

    func testRetrieveActivityFeed() {
        var networkFeed: [Activity]?
        _ = tapglue.retrieveActivityFeed().subscribeNext { events in
            networkFeed = events
        }
        expect(networkFeed).toEventually(contain(network.testActivity))
    }

    func testRetrieveNewsFeed() {
        var networkFeed: NewsFeed?
        _ = tapglue.retrieveNewsFeed().subscribeNext { feed in
            networkFeed = feed
        }
        expect(networkFeed).toEventuallyNot(beNil())
    }

    func testRetrieveMeFeed() {
        var networkFeed: [Activity]?
        _ = tapglue.retrieveMeFeed().subscribeNext { events in
            networkFeed = events
        }
        expect(networkFeed).toEventually(contain(network.testActivity))
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