//
//  Tapglue.swift
//  Tapglue
//
//  Created by John Nilsen on 6/27/16.
//  Copyright © 2016 Tapglue. All rights reserved.
//

import Foundation
import Alamofire
import RxSwift

public class RxTapglue {
    
    var userStore = UserStore()
    
    var network: Network
    public private(set) var currentUser: User? {
        get {
            return userStore.user
        }
        set {
            userStore.user = newValue
        }
    }
    
    public init(configuration: Configuration) {
        Router.configuration = configuration
        network = Network()
        
        if let sessionToken = currentUser?.sessionToken {
            Router.sessionToken = sessionToken
        }
    }
    
    public func createUser(user: User) -> Observable<User> {
        return network.createUser(user)
    }
    
    public func loginUser(username: String, password: String) -> Observable<User> {
        return network.loginUser(username, password: password).map(toCurrentUserMap)
    }

    public func updateCurrentUser(user: User) -> Observable<User> {
        return network.updateCurrentUser(user).map(toCurrentUserMap)
    }

    public func refreshCurrentUser() -> Observable<User> {
        return network.refreshCurrentUser().map(toCurrentUserMap)
    }

    public func logout() -> Observable<Void> {
        return network.logout().doOnCompleted {
            self.currentUser = nil
        }
    }
    
    public func deleteCurrentUser() -> Observable<Void> {
        return network.deleteCurrentUser().doOnCompleted {
            self.currentUser = nil
        }
    }

    public func searchUsers(forSearchTerm term: String) -> Observable<[User]> {
        return network.searchUsers(forSearchTerm: term)
    }

    public func searchEmails(emails: [String]) -> Observable<[User]> {
        return network.searchEmails(emails)
    }

    public func searchSocialIds(ids: [String], onPlatform platform: String) ->
        Observable<[User]> {
        return network.searchSocialIds(ids, onPlatform: platform)
    }

    public func createConnection(connection: Connection) -> Observable<Connection> {
        return network.createConnection(connection)
    }

    public func deleteConnection(toUserId userId: String, type: ConnectionType) 
        -> Observable<Void> {
        return network.deleteConnection(toUserId: userId, type: type)
    }

    public func createSocialConnections(socialConnections: SocialConnections) ->
        Observable<[User]> {
        return network.createSocialConnections(socialConnections)
    }

    public func retrieveFollowers() -> Observable<[User]> {
        return network.retrieveFollowers()
    }

    public func retrieveFollowings() -> Observable<[User]> {
        return network.retrieveFollowings()
    }

    public func retrieveFollowersForUserId(id: String) -> Observable<[User]> {
        return network.retrieveFollowersForUserId(id)
    }

    public func retrieveFollowingsForUserId(id: String) -> Observable<[User]> {
        return network.retrieveFollowingsForUserId(id)
    }

    public func retrieveFriends() -> Observable<[User]> {
        return network.retrieveFriends()
    }

    public func retrieveFriendsForUserId(id: String) -> Observable<[User]> {
        return network.retrieveFriendsForUserId(id)
    }

    public func retrievePendingConnections() -> Observable<Connections> {
        return network.retrievePendingConnections()
    }

    public func retrieveRejectedConnections() -> Observable<Connections> {
        return network.retrieveRejectedConnections()
    }

    public func retrieveUser(id: String) -> Observable<User> {
        return network.retrieveUser(id)
    }

    private func toCurrentUserMap(user: User) -> User {
        currentUser = user
        return user
    }
    
    public func createPost(post: Post) -> Observable<Post> {
        return network.createPost(post)
    }
    
    public func retrievePost(id: String) -> Observable<Post> {
        return network.retrievePost(id)
    }
    
    public func updatePost(post: Post) -> Observable<Post> {
        return network.updatePost(post)
    }
    
    public func deletePost(id: String) -> Observable<Void> {
        return network.deletePost(id)
    }

    public func retrievePostsByUser(userId: String) -> Observable<[Post]> {
        return network.retrievePostsByUser(userId)
    }

    public func retrieveAllPosts() -> Observable<[Post]> {
        return network.retrieveAllPosts()
    }
    
    public func createComment(comment: Comment) -> Observable<Comment> {
        return network.createComment(comment)
    }
    
    public func retrieveComments(postId: String) -> Observable<[Comment]> {
        return network.retrieveComments(postId)
    }
    
    public func updateComment(postId: String, commentId: String, comment: Comment) ->
        Observable<Comment> {
        return network.updateComment(postId, commentId: commentId, comment: comment)
    }
    
    public func deleteComment(forPostId postId: String, commentId: String) -> Observable<Void> {
        return network.deleteComment(postId, commentId: commentId)
    }
    
    public func createLike(forPostId postId: String) -> Observable<Like> {
        return network.createLike(forPostId: postId)
    }
    
    public func retrieveLikes(postId: String) -> Observable<[Like]> {
        return network.retrieveLikes(postId)
    }
    
    public func deleteLike(forPostId postId: String) -> Observable<Void> {
        return network.deleteLike(forPostId: postId)
    }

    public func retrievePostFeed() -> Observable<[Post]> {
        return network.retrievePostFeed()
    }

    public func retrieveActivityFeed() -> Observable<[Activity]> {
        return network.retrieveActivityFeed()
    }
}