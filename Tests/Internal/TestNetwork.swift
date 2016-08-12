//
//  TestNetwork.swift
//  Tapglue
//
//  Created by John Nilsen on 8/2/16.
//  Copyright © 2016 Tapglue. All rights reserved.
//

import Foundation
import RxSwift
@testable import Tapglue

class TestNetwork: Network {
    
    
    let testUserId = "testUserId"
    let testUser: User
    let testPost: Post
    let testComment: Comment
    let testLike: Like
    let testLikeId = "testLikeId"
    let testConnection: Connection
    let testPostId = "testPostId"
    let testCommentId = "testCommentId"
    let testConnections: Connections
    let testActivity: Activity
    let testActivityId = "testActivityId"
    
    override init() {
        testUser = User()
        testConnection = Connection(toUserId: "213", type: .Follow, state: .Confirmed)
        testUser.id = testUserId
        testPost = Post(visibility: .Connections, attachments: [])
        testPost.id = testPostId
        testComment = Comment(contents: ["en":"myComment"], postId: testPostId)
        testComment.id = testCommentId
        testLike = Like(postId: testPostId)
        testLike.id = testLikeId
        testConnections = Connections()
        testConnections.incoming = [testConnection]
        testActivity = Activity()
        testActivity.id = testActivityId
    }
    
    override func loginUser(username: String, password: String) -> Observable<User> {
        return Observable.just(testUser)
    }

    override func loginUserWithEmail(email: String, password: String) -> Observable<User> {
        return Observable.just(testUser)
    }
    
    override func createUser(user: User) -> Observable<User> {
        return Observable.just(testUser)
    }
    
    override func refreshCurrentUser() -> Observable<User> {
        return Observable.just(testUser)
    }
    
    override func updateCurrentUser(user: User) -> Observable<User> {
        return Observable.just(testUser)
    }
    
    override func logout() -> Observable<Void> {
        return Observable.create { observer in
            observer.on(.Completed)
            return NopDisposable.instance
        }
    }
    
    override func deleteCurrentUser() -> Observable<Void> {
        return Observable.create { observer in
            observer.on(.Completed)
            return NopDisposable.instance
        }
    }
    
    override func retrieveUser(id: String) -> Observable<User> {
        return Observable.just(testUser)
    }
    
    override func searchUsers(forSearchTerm term: String) -> Observable<[User]> {
        return Observable.just([testUser])
    }
    
    override func searchEmails(emails: [String]) -> Observable<[User]> {
        return Observable.just([testUser])
    }
    
    override func searchSocialIds(ids: [String], onPlatform platform: String) ->
        Observable<[User]> {
            return Observable.just([testUser])
    }
    
    override func createConnection(connection: Connection) -> Observable<Connection> {
        return Observable.just(testConnection)
    }
    
    override func deleteConnection(toUserId userId: String, type: ConnectionType) -> Observable<Void> {
        return Observable.create {observer in
            observer.on(.Completed)
            return NopDisposable.instance
        }
    }

    override func createSocialConnections(socialConnections: SocialConnections) -> 
        Observable<[User]> {
        return Observable.just([testUser])
    }
    
    override func retrieveFollowers() -> Observable<[User]> {
        return Observable.just([testUser])
    }
    
    override func retrieveFollowings() -> Observable<[User]> {
        return Observable.just([testUser])
    }
    
    override func retrieveFollowersForUserId(id: String) -> Observable<[User]> {
        return Observable.just([testUser])
    }
    
    override func retrieveFollowingsForUserId(id: String) -> Observable<[User]> {
        return Observable.just([testUser])
    }
    
    override func retrieveFriendsForUserId(id: String) -> Observable<[User]> {
        return Observable.just([testUser])
    }
    
    override func retrieveFriends() -> Observable<[User]> {
        return Observable.just([testUser])
    }
    
    override func retrievePendingConnections() -> Observable<Connections> {
        return Observable.just(testConnections)
    }
    
    override func retrieveRejectedConnections() -> Observable<Connections> {
        return Observable.just(testConnections)
    }
    
    override func createPost(post: Post) -> Observable<Post> {
        return Observable.just(testPost)
    }
    
    override func retrievePost(id: String) -> Observable<Post> {
        return Observable.just(testPost)
    }
    
    override func updatePost(id: String, post: Post) -> Observable<Post> {
        return Observable.just(testPost)
    }
    
    override func deletePost(id: String) -> Observable<Void> {
        return Observable.create { observer in
            observer.on(.Completed)
            return NopDisposable.instance
        }
    }

    override func retrievePostsByUser(userId: String) -> Observable<[Post]> {
        return Observable.just([testPost])
    }

    override func retrieveAllPosts() -> Observable<[Post]> {
        return Observable.just([testPost])
    }

    override func filterPostsByTags(tags: [String]) -> Observable<[Post]> {
        return Observable.just([testPost])
    }
    
    override func createComment(comment: Comment) -> Observable<Comment> {
        return Observable.just(testComment)
    }
    
    override func retrieveComments(postId: String) -> Observable<[Comment]> {
        return Observable.just([testComment])
    }
    
    override func updateComment(postId: String, commentId: String, comment: Comment) -> Observable<Comment> {
        return Observable.just(testComment)
    }
    
    override func deleteComment(postId: String, commentId: String) -> Observable<Void> {
        return Observable.create { observer in
            observer.on(.Completed)
            return NopDisposable.instance
        }
    }
    
    override func createLike(forPostId postId: String) -> Observable<Like> {
        return Observable.just(testLike)
    }
    
    override func retrieveLikes(postId: String) -> Observable<[Like]> {
        return Observable.just([testLike])
    }
    
    override func deleteLike(forPostId postId: String) -> Observable<Void> {
        return Observable.create { observer in
            observer.on(.Completed)
            return NopDisposable.instance
        }
    }

    override func retrievePostFeed() -> Observable<[Post]> {
        return Observable.just([testPost])
    }

    override func retrieveActivityFeed() -> Observable<[Activity]> {
        return Observable.just([testActivity])
    }

    override func retrieveNewsFeed() -> Observable<NewsFeed> {
        let newsFeed = NewsFeed()
        newsFeed.activities = [testActivity]
        newsFeed.posts = [testPost]
        return Observable.just(newsFeed)
    }

    override func retrieveMeFeed() -> Observable<[Activity]> {
        return Observable.just([testActivity])
    }
}