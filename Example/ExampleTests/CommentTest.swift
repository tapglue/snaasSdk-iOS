//
//  CommentTest.swift
//  Example
//
//  Created by Onur Akpolat on 28/07/16.
//  Copyright © 2016 Tapglue. All rights reserved.
//

import XCTest
import Tapglue
import RxSwift
import Nimble
import RxBlocking

class CommentTest: XCTestCase {

    let username = "CommentTestUser1"
    let password = "CommentTestPassword"
    let tapglue = RxTapglue(configuration: Configuration())
    var user = User()
    
    let attachment = Attachment(contents: ["en":"contents"], name: "userPost", type: .Text)
    var post: Post!
    var comment: Comment!
    
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
    
    //TODO: Create Comment Test
    //    func testCreateComment() {
    //
    //    }
    
    //TODO: Retrieve Comments Test
    //    func testRetrieveComments() throws {
    //
    //    }
    
    func testUpdateComment() throws {
        _ = try tapglue.createPost(post).toBlocking().first()!
        let createdComment = try tapglue.createComment(comment).toBlocking().first()!
        
        createdComment.contents! = ["es":"contenidos"]
        let updatedComment = try tapglue.updateComment(createdComment).toBlocking().first()
        
        expect(updatedComment?.contents).toNot(beNil())
    }
    
    func testDeleteComment() throws {
        _ = try tapglue.createPost(post).toBlocking().first()!
        _ = try tapglue.createComment(comment).toBlocking().first()!
        
        var wasDeleted = false
        _ = tapglue.deleteComment(comment).subscribeCompleted {
            wasDeleted = true
        }
        
        expect(wasDeleted).toEventually(beTrue())
    }
}
