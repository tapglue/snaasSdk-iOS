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

    public func createConnection(connection: Connection) -> Observable<Connection> {
        return network.createConnection(connection)
    }

    public func deleteConnection(toUserId userId: String, type: ConnectionType) 
                            -> Observable<Void> {
        return network.deleteConnection(toUserId: userId, type: type)
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
    
    public func createComment(comment: Comment) -> Observable<Comment> {
        return network.createComment(comment)
    }
    
    public func retrieveComments(postId: String) -> Observable<[Comment]> {
        return network.retrieveComments(postId)
    }
    
    public func updateComment(comment: Comment) -> Observable<Comment> {
        return network.updateComment(comment)
    }
    
    public func deleteComment(forPostId postId: String, commentId: String) -> Observable<Void> {
        return network.deleteComment(postId, commentId: commentId)
    }
}