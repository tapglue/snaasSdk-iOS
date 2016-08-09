//
//  FeedTest.swift
//  Example
//
//  Created by John Nilsen on 8/3/16.
//  Copyright © 2016 Tapglue. All rights reserved.
//

import XCTest
import Nimble
import RxSwift
@testable import Tapglue

class FeedTest: XCTestCase {

    let username1 = "FeedTestUser1"
    let username2 = "FeedTestUser2"
    let socialId1 = "FeedTestSocialId1"
    let socialId2 = "FeedTestSocialId2"
    let password = "FeedTestPassword"
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
    
    func testRetrievePostFeed() throws {
        // login user 1 and create connection to user 2
        user1 = try tapglue.loginUser(username1, password: password).toBlocking().first()!
        _ = try tapglue.createConnection(Connection(toUserId: user2.id!, type: .Follow,
            state: .Confirmed)).toBlocking().first()

        // login as user 2 and create post
        user2 = try tapglue.loginUser(username2, password: password).toBlocking().first()!
        let attachment = Attachment(contents: ["en":"contents"], name: "userPost", type: .Text)
        var post = Post(visibility: .Connections, attachments: [attachment])
        post = try tapglue.createPost(post).toBlocking().first()!

        // login as user 1 and read post feed
        user1 = try tapglue.loginUser(username1, password: password).toBlocking().first()!
        let postFeed = try tapglue.retrievePostFeed().toBlocking().first()!

        expect(postFeed.first?.id).to(equal(post.id))
    }
    
    func testRetrieveActivityFeed() throws {
        // login user 1 and create connection to user 2
        user1 = try tapglue.loginUser(username1, password: password).toBlocking().first()!
        _ = try tapglue.createConnection(Connection(toUserId: user2.id!, type: .Follow,
            state: .Confirmed)).toBlocking().first()
        
        // login as user 2 and retrieve activity feed
        user2 = try tapglue.loginUser(username2, password: password).toBlocking().first()!

        let activityFeed = try tapglue.retrieveActivityFeed().toBlocking().first()!
        expect(activityFeed.first!.type).to(equal("tg_follow"))
    }
    
    func testRetrieveActivityFeedLikeContainsPost() throws {
        // login user 1, create connection to user 2, create post
        user1 = try tapglue.loginUser(username1, password: password).toBlocking().first()!
        _ = try tapglue.createConnection(Connection(toUserId: user2.id!, type: .Follow,
            state: .Confirmed)).toBlocking().first()
        let attachment = Attachment(contents: ["en":"contents"], name: "userPost", type: .Text)
        var post = Post(visibility: .Connections, attachments: [attachment])
        post = try tapglue.createPost(post).toBlocking().first()!
        
        // login as user 2, like post of user 1
        user2 = try tapglue.loginUser(username2, password: password).toBlocking().first()!
        _ = try tapglue.createConnection(Connection(toUserId: user1.id!, type: .Follow,
            state: .Confirmed)).toBlocking().first()
        try tapglue.createLike(forPostId: post.id!).toBlocking().first()!
        
        // login as user 1 and read activity feed
        user1 = try tapglue.loginUser(username1, password: password).toBlocking().first()!
        let activityFeed = try tapglue.retrieveActivityFeed().toBlocking().first()!
        
        expect(activityFeed.first?.post?.id).to(equal(post.id))
    }
    
    func testRetrieveNewsFeed() throws {
        // login user 1 and create connection to user 2
        user1 = try tapglue.loginUser(username1, password: password).toBlocking().first()!
        _ = try tapglue.createConnection(Connection(toUserId: user2.id!, type: .Follow,
            state: .Confirmed)).toBlocking().first()
        
        // login as user 2 and create post and follows user 1
        user2 = try tapglue.loginUser(username2, password: password).toBlocking().first()!
        _ = try tapglue.createConnection(Connection(toUserId: user1.id!, type: .Follow,
            state: .Confirmed)).toBlocking().first()
        let attachment = Attachment(contents: ["en":"contents"], name: "userPost", type: .Text)
        var post = Post(visibility: .Connections, attachments: [attachment])
        post = try tapglue.createPost(post).toBlocking().first()!
        
        // login as user 1 and read post feed
        user1 = try tapglue.loginUser(username1, password: password).toBlocking().first()!
        let newsFeed = try tapglue.retrieveNewsFeed().toBlocking().first()!
        
        expect(newsFeed.posts?.first?.id).to(equal(post.id))
        expect(newsFeed.activities?.first?.type).to(equal("tg_follow"))
    }
    
    func testRetrieveNewsFeedLikeContainsPost() throws {
        // login user 1, create connection to user 2, create post
        user1 = try tapglue.loginUser(username1, password: password).toBlocking().first()!
        _ = try tapglue.createConnection(Connection(toUserId: user2.id!, type: .Follow,
            state: .Confirmed)).toBlocking().first()
        let attachment = Attachment(contents: ["en":"contents"], name: "userPost", type: .Text)
        var post = Post(visibility: .Connections, attachments: [attachment])
        post = try tapglue.createPost(post).toBlocking().first()!
        
        // login as user 2, like post of user 1
        user2 = try tapglue.loginUser(username2, password: password).toBlocking().first()!
        _ = try tapglue.createConnection(Connection(toUserId: user1.id!, type: .Follow,
            state: .Confirmed)).toBlocking().first()
        try tapglue.createLike(forPostId: post.id!).toBlocking().first()!
        
        // login as user 1 and read news feed
        user1 = try tapglue.loginUser(username1, password: password).toBlocking().first()!
        let newsFeed = try tapglue.retrieveNewsFeed().toBlocking().first()!
        
        expect(newsFeed.activities?.first?.post?.id).to(equal(post.id))
    }
    
    func testRetrieveMeFeed() throws {
        // login user 1 and create connection to user 2
        user1 = try tapglue.loginUser(username1, password: password).toBlocking().first()!
        _ = try tapglue.createConnection(Connection(toUserId: user2.id!, type: .Follow,
            state: .Confirmed)).toBlocking().first()
        
        // login as user 2 and retrieve activity feed
        user2 = try tapglue.loginUser(username2, password: password).toBlocking().first()!

        let activityFeed = try tapglue.retrieveMeFeed().toBlocking().first()!
        expect(activityFeed.first!.type).to(equal("tg_follow"))
    }
}
