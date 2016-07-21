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

    let username = "PostTestUser1"
    let password = "PostTestPassword"
    let tapglue = RxTapglue(configuration: Configuration())
    var user = User()

    let attachment = Attachment(contents: ["en":"contents"], name: "userPost", type: .Text)
    var post: Post!
    
    override func setUp() {
        super.setUp()
        user.username = username
        user.password = password
        
        do {
            user = try tapglue.createUser(user).toBlocking().first()!
            user = try tapglue.loginUser(username, password: password).toBlocking().first()!

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
        let updatedPost = try tapglue.updatePost(createdPost).toBlocking().first()
        
        expect(updatedPost?.attachments?.count).to(equal(2))
    }
}
