//
//  LikeTest.swift
//  Example
//
//  Created by Onur Akpolat on 29/07/16.
//  Copyright © 2016 Tapglue. All rights reserved.
//

import XCTest
import Tapglue
import RxSwift
import Nimble
import RxBlocking

class LikeTest: XCTestCase {
    
    let username = "LikeTestUser1"
    let password = "LikeTestPassword"
    let tapglue = RxTapglue(configuration: Configuration())
    var user = User()
    
    let attachment = Attachment(contents: ["en":"contents"], name: "userPost", type: .Text)
    var post: Post!
    var like: Like!
    
    override func setUp() {
        super.setUp()
        user.username = username
        user.password = password
        
        do {
            user = try tapglue.createUser(user).toBlocking().first()!
            user = try tapglue.loginUser(username, password: password).toBlocking().first()!
            post = try tapglue.createPost(Post(visibility: .Connections, attachments: [attachment]))
                .toBlocking().first()!
            
        } catch {
            fail("failed to create and login user for integration tests")
        }
    }
    
    override func tearDown() {
        super.tearDown()
        do {
            try tapglue.loginUser(username, password: password).toBlocking().first()
            
            try tapglue.deletePost(post.id!).toBlocking().first()
            
            try tapglue.deleteCurrentUser().toBlocking().first()
        } catch {
            fail("failed to login and delete user for integration tests")
        }
    }
    
    func testCreateLike() throws {
        let createdLike = try tapglue.createLike(forPostId: post.id!).toBlocking().first()!
        expect(createdLike).toNot(beNil())
    }
    
    func testDeleteLike() throws {
        let createdLike = try tapglue.createLike(forPostId: post.id!).toBlocking().first()!
        var wasDeleted = false
        _ = tapglue.deleteLike(forPostId: createdLike.postId!).subscribeCompleted {
            wasDeleted = true
        }
        expect(wasDeleted).toEventually(beTrue())
    }
    
    func testRetrieveLikes() throws {
        let createdLike = try tapglue.createLike(forPostId: post.id!).toBlocking().first()!
        let likes = try tapglue.retrieveLikes(post.id!).toBlocking().first()!
        
        expect(likes.count).to(equal(1))
        expect(likes.first?.id ?? "").to(equal(createdLike.id!))
    }
}
