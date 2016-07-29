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
    
    func testCreateComment() throws {
        let comment = Comment(contents: ["en":"content"], postId: post.id!)
        let createdComment = try tapglue.createComment(comment).toBlocking().first()!
        expect(createdComment).toNot(beNil())
    }
    
    func testDeleteComment() throws {
        let comment = Comment(contents: ["en":"content"], postId: post.id!)
        let createdComment = try tapglue.createComment(comment).toBlocking().first()!
        var wasDeleted = false
        _ = tapglue.deleteComment(forPostId: createdComment.postId!, commentId: createdComment.id!).subscribeCompleted {
            wasDeleted = true
        }
        expect(wasDeleted).toEventually(beTrue())
    }
    
    func testUpdateComment() throws {
        let comment = Comment(contents: ["en":"content"], postId: post.id!)
        let createdComment = try tapglue.createComment(comment).toBlocking().first()!
        createdComment.contents!["es-ES"] = "contenidos"
        let updatedComment = try tapglue.updateComment(post.id!, commentId: createdComment.id!, comment: createdComment).toBlocking().first()!
        expect(updatedComment.contents!["es-ES"]).to(equal("contenidos"))
    }
    
    func testRetrieveComments() throws {
        let comment = Comment(contents: ["en":"content"], postId: post.id!)
        let createdComment = try tapglue.createComment(comment).toBlocking().first()!
        
        let comments = try tapglue.retrieveComments(post.id!).toBlocking().first()!
        
        expect(comments.count).to(equal(1))
        expect(comments.first?.id ?? "").to(equal(createdComment.id!))
    }
}
