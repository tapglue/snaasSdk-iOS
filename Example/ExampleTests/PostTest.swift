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
    
    func testCreatePost() {
        let attachment = Attachment(contents: ["en":"contents"], name: "userPost", type: .Text)
        let post = Post(visibility: .Connections, attachments: [attachment])
        
        var networkPost: Post?
        _ = tapglue.createPost(post).subscribeNext { post in
            networkPost = post
        }
        
        expect(networkPost?.id).toEventuallyNot(beNil())
    }
    
    func testDeletePost() throws {
        let attachment = Attachment(contents: ["en":"contents"], name: "userPost", type: .Text)
        let post = Post(visibility: .Connections, attachments: [attachment])
        let networkPost = try tapglue.createPost(post).toBlocking().first()!

        var wasDeleted = false
        _ = tapglue.deletePost(networkPost.id!).subscribeCompleted {
            wasDeleted = true
        }

        expect(wasDeleted).toEventually(beTrue())
    }
    
}
