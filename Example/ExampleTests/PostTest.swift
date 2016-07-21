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
            try tapglue.loginUser(username, password: password).toBlocking().first()
            try tapglue.deleteCurrentUser().toBlocking().first()
        } catch {
            fail("failed to login and delete user for integration tests")
        }
    }
    
    func testPostCreate() {
        var post = Post()
        post.visibility = 10
        var attachment = Attachment()
        attachment.name = "my attachment"
        attachment.type = "text"
        attachment.contents = ["en":"contet"]
        post.attachments = [attachment]
        
        var networkPost = Post()
        tapglue.createPost(post).subscribeNext { post in
            networkPost = post
        }
        
        expect(networkPost.id).toEventuallyNot(beNil())
    }
}
