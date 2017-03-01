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
            post = try tapglue.createPost(Post(visibility: .connections, attachments: [attachment]))
                .toBlocking().first()!
            
        } catch {
            fail("failed to create and login user for integration tests")
        }
    }
    
    override func tearDown() {
        super.tearDown()
        do {
            _ = try tapglue.loginUser(username, password: password).toBlocking().first()
            
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

    func testCreateLikeReaction() throws {
        var wasLiked = false
        _ = tapglue.createReaction(.like, forPostId: post.id!).subscribe(onCompleted: {
            wasLiked = true
        })
        expect(wasLiked).toEventually(beTrue())
    }

    func testCreateLoveReaction() throws {
        var wasLiked = false
        _ = tapglue.createReaction(.love, forPostId: post.id!).subscribe(onCompleted: {
            wasLiked = true
        })
        expect(wasLiked).toEventually(beTrue())
    }

    func testCreateHahaReaction() throws {
        var wasLiked = false
        _ = tapglue.createReaction(.haha, forPostId: post.id!).subscribe(onCompleted: {
            wasLiked = true
        })
        expect(wasLiked).toEventually(beTrue())
    }

    func testCreateAngryReaction() throws {
        var wasLiked = false
        _ = tapglue.createReaction(.angry, forPostId: post.id!).subscribe(onCompleted: {
            wasLiked = true
        })
        expect(wasLiked).toEventually(beTrue())
    }
    
    func testReactionParsedInPost() throws {
        var wasLiked = false
        _ = tapglue.createReaction(.love, forPostId: post.id!).subscribe(onCompleted: {
            wasLiked = true
        })
        expect(wasLiked).toEventually(beTrue())
        let retrievedPost = try tapglue.retrievePost(post.id!).toBlocking().first()!
        expect(retrievedPost.reactions?[.love]).to(equal(1))
    }

    func testCreateSadReaction() throws {
        var wasLiked = false
        _ = tapglue.createReaction(.sad, forPostId: post.id!).subscribe(onCompleted: {
            wasLiked = true
        })
        expect(wasLiked).toEventually(beTrue())
    }

    func testCreateWowReaction() throws {
        var wasLiked = false
        _ = tapglue.createReaction(.wow, forPostId: post.id!).subscribe(onCompleted: {
            wasLiked = true
        })
        expect(wasLiked).toEventually(beTrue())
    }

    func testSetUserReactionLocally() throws {
        post.setUserReactionLocally(.wow, true)
        expect(self.post.hasReacted?[.wow]).toEventually(beTrue())
    }

    func testIncreaseReactionCountLocally() throws {
        post.increaseReactionCountLocally(.wow)
        expect(self.post.reactions?[.wow]).to(equal(1))
    }

    func testIncreaseReactionCountLocallyTwice() throws {
        post.increaseReactionCountLocally(.wow)
        post.increaseReactionCountLocally(.wow)
        expect(self.post.reactions?[.wow]).to(equal(2))
    }

    func testDecreaseReactionCountLocally() throws {
        post.decreaseReactionCountLocally(.wow)
        expect(self.post.reactions?[.wow]).to(equal(0))
    }

    func testDecreaseReactionCountLocallyIncrease() throws {
        post.increaseReactionCountLocally(.wow)
        post.decreaseReactionCountLocally(.wow)
        expect(self.post.reactions?[.wow]).to(equal(0))
    }

    func testDecreaseReactionCountLocallyIncreaseTwice() throws {
        post.increaseReactionCountLocally(.wow)
        post.increaseReactionCountLocally(.wow)
        post.decreaseReactionCountLocally(.wow)
        expect(self.post.reactions?[.wow]).to(equal(1))
    }

    func testDeleteLikeReaction() throws {
        var wasDeleted = false
        _ = try tapglue.createReaction(.like, forPostId: post.id!).toBlocking().first()
        _ = tapglue.deleteReaction(.like, forPostId: post.id!).subscribe(onCompleted: {
            wasDeleted = true
        })
        expect(wasDeleted).toEventually(beTrue())
    }
    
    func testLikeCount() throws {
        _ = try tapglue.createLike(forPostId: post.id!).toBlocking().first()!
        post = try tapglue.retrievePost(post.id!).toBlocking().first()!
        expect(self.post.likeCount).to(equal(1))
    }
    
    func testDeleteLike() throws {
        let createdLike = try tapglue.createLike(forPostId: post.id!).toBlocking().first()!
        var wasDeleted = false
        _ = tapglue.deleteLike(forPostId: createdLike.postId!).subscribe(onCompleted: {
            wasDeleted = true
        })
        expect(wasDeleted).toEventually(beTrue())
    }
    
    func testRetrieveLikes() throws {
        let createdLike = try tapglue.createLike(forPostId: post.id!).toBlocking().first()!
        var likes: [Like]
        likes = try tapglue.retrieveLikes(post.id!).toBlocking().first()!
        
        expect(likes.count).to(equal(1))
        expect(likes.first?.id ?? "").to(equal(createdLike.id!))
    }
    
    func testRetrieveLikesByUser() throws {
        let createdLike = try tapglue.createLike(forPostId: post.id!).toBlocking().first()!
        var likes: [Like]
        likes = try tapglue.retrieveLikesByUser(user.id!).toBlocking().first()!
        
        expect(likes.count).to(equal(1))
        expect(likes.first?.id ?? "").to(equal(createdLike.id!))
    }
    
    func testRetrieveLikesByUserMapsUser() throws {
        _ = try tapglue.createLike(forPostId: post.id!).toBlocking().first()!
        var likes: [Like]
        likes = try tapglue.retrieveLikesByUser(user.id!).toBlocking().first()!
        
        expect(likes.first?.user?.id).to(equal(user.id))
    }
    
    func testRetrieveLikesByUserMapsPost() throws {
        _ = try tapglue.createLike(forPostId: post.id!).toBlocking().first()!
        var likes: [Like]
        likes = try tapglue.retrieveLikesByUser(user.id!).toBlocking().first()!
        
        expect(likes.first?.post?.id).to(equal(post.id))
    }
    
    func testPaginatedRetrieveLikes() throws {
        let createdLike = try tapglue.createLike(forPostId: post.id!).toBlocking().first()!
        var likes: RxPage<Like>
        likes = try tapglue.retrieveLikes(post.id!).toBlocking().first()!
        
        expect(likes.data.count).to(equal(1))
        expect(likes.data.first?.id ?? "").to(equal(createdLike.id!))
    }
    
    func testPaginatedRetrieveLikesByUser() throws {
        let createdLike = try tapglue.createLike(forPostId: post.id!).toBlocking().first()!
        var likes: RxPage<Like>
        likes = try tapglue.retrieveLikesByUser(user.id!).toBlocking().first()!
        
        expect(likes.data.count).to(equal(1))
        expect(likes.data.first?.id ?? "").to(equal(createdLike.id!))
    }
    
    func testPaginatedRetrieveLikesByUserMapsUser() throws {
        _ = try tapglue.createLike(forPostId: post.id!).toBlocking().first()!
        var likes: RxPage<Like>
        likes = try tapglue.retrieveLikesByUser(user.id!).toBlocking().first()!
        
        expect(likes.data.first?.user?.id).to(equal(user.id))
    }
}
