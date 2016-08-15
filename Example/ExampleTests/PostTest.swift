//
//  PostTest.swift
//  Example
//
//  Created by Onur Akpolat on 21/07/16.
//  Copyright © 2016 Tapglue. All rights reserved.
//

import XCTest
import Tapglue
import RxSwift
import Nimble
import RxBlocking

class PostTest: XCTestCase {

    let tag1 =  "someTag"
    let username = "PostTestUser1"
    let password = "PostTestPassword"
    let tapglue = RxTapglue(configuration: Configuration())
    var user1 = User()

    let attachment = Attachment(contents: ["en":"contents"], name: "userPost", type: .Text)
    var post: Post!
    
    override func setUp() {
        super.setUp()
        user1.username = username
        user1.password = password
        
        do {
            user1 = try tapglue.createUser(user1).toBlocking().first()!
            user1 = try tapglue.loginUser(username, password: password).toBlocking().first()!

            post = Post(visibility: .Connections, attachments: [attachment])
        } catch {
            fail("failed to create and login user for integration tests")
        }
    }
    
    override func tearDown() {
        super.tearDown()
        do {
            try tapglue.loginUser(username, password: password).toBlocking().first()
            try tapglue.deleteCurrentUser().toBlocking().first()
        } catch {
            fail("failed to login and delete user for integration tests")
        }
    }
    
    func testCreatePost() {
        var networkPost: Post?
        _ = tapglue.createPost(post).subscribeNext { post in
            networkPost = post
        }
        
        expect(networkPost?.id).toEventuallyNot(beNil())
    }
    
    func testDeletePost() throws {
        let networkPost = try tapglue.createPost(post).toBlocking().first()!

        var wasDeleted = false
        _ = tapglue.deletePost(networkPost.id!).subscribeCompleted {
            wasDeleted = true
        }

        expect(wasDeleted).toEventually(beTrue())
    }

    func testRetrievePost() throws {
        let createdPost = try tapglue.createPost(post).toBlocking().first()!
        let retrievedPost = try tapglue.retrievePost(createdPost.id!).toBlocking().first()!
        expect(createdPost.id!).to(equal(retrievedPost.id!))
    }

    func testUpdatePost() throws {
        let createdPost = try tapglue.createPost(post).toBlocking().first()!
        createdPost.attachments!.append(Attachment(contents: ["es":"contenidos"], name: "spanish", type: .Text))
        let updatedPost = try tapglue.updatePost(createdPost.id!, post: createdPost).toBlocking().first()
        
        expect(updatedPost?.attachments?.count).to(equal(2))
    }
    
    func testRetrievePostsByUser() throws {
        let createdPost = try tapglue.createPost(post).toBlocking().first()!
        let retrievedPosts = try tapglue.retrievePostsByUser(user1.id!).toBlocking().first()!
        
        expect(retrievedPosts.first?.id).to(equal(createdPost.id))
    }
    
    func testRetrievePostsByUserMapsUsersToPosts() throws {
        _ = try tapglue.createPost(post).toBlocking().first()!
        let retrievedPosts = try tapglue.retrievePostsByUser(user1.id!).toBlocking().first()!
        
        expect(retrievedPosts.first?.user?.id).to(equal(user1.id))
    }

    func testRetrieveAllPosts() throws {
        post.visibility = .Public
        let createdPost = try tapglue.createPost(post).toBlocking().first()!

        var user2 = User()
        user2.username = "postTestUser2"
        user2.password = password
        user2 = try tapglue.createUser(user2).toBlocking().first()!
        user2 = try tapglue.loginUser(user2.username!, password: password).toBlocking().first()!

        let retrievedPosts = try tapglue.retrieveAllPosts().toBlocking().first()!
        
        expect(retrievedPosts.first?.id).to(equal(createdPost.id))
        
        try tapglue.deleteCurrentUser().toBlocking().first()
    }
    
    func testRetrieveAllPostsMapsUsersToPosts() throws {
        post.visibility = .Public
        _ = try tapglue.createPost(post).toBlocking().first()!
        
        var user2 = User()
        user2.username = "postTestUser2"
        user2.password = password
        user2 = try tapglue.createUser(user2).toBlocking().first()!
        user2 = try tapglue.loginUser(user2.username!, password: password).toBlocking().first()!
        
        let retrievedPosts = try tapglue.retrieveAllPosts().toBlocking().first()!
        
        expect(retrievedPosts.first?.user?.id).to(equal(user1.id))
        
        try tapglue.deleteCurrentUser().toBlocking().first()
    }

    func testFilterPostsByTag() throws {
        post.tags = [tag1]
        post.visibility = .Public
        let createdPost = try tapglue.createPost(post).toBlocking().first()!

        let retrievedPosts = try tapglue.filterPostsByTags([tag1]).toBlocking().first()!

        expect(retrievedPosts.first?.id).to(equal(createdPost.id))

        try tapglue.deletePost(createdPost.id!).toBlocking().first()
    }
}
