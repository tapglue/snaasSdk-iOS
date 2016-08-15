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

/// Provides a RxSwift interface to the tapglue sdk
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
    
    /// Constructs instance of RxTapglue
    /// - parameter configuration: Configuration to be used
    public init(configuration: Configuration) {
        Router.configuration = configuration
        Log.isDebug = configuration.log
        network = Network()
        
        if let sessionToken = currentUser?.sessionToken {
            Router.sessionToken = sessionToken
        }
    }
    /// creates a user on tapglue
    /// - parameter user: user to be created
    /// - Note: username or email is required, password is required
    /// - Note: does not login user
    public func createUser(user: User) -> Observable<User> {
        return network.createUser(user)
    }
    /// logs in user on tapglue
    /// - parameter username: username of the user to be logged in
    /// - parameter password: password of the user to be logged in
    public func loginUser(username: String, password: String) -> Observable<User> {
        return network.loginUser(username, password: password).map(toCurrentUserMap)
    }
    /// logs in user on tapglue
    /// - parameter email: email of the user to be logged in
    /// - parameter password: password of the user to be logged in 
    public func loginUserWithEmail(email: String, password: String) -> Observable<User> {
        return network.loginUserWithEmail(email, password: password).map(toCurrentUserMap)
    }
    /// update information on the current user by providing a user entity
    /// - parameter user: entity with the information to be updated
    public func updateCurrentUser(user: User) -> Observable<User> {
        return network.updateCurrentUser(user).map(toCurrentUserMap)
    }
    /// refreshes locally stored copy of the current user
    public func refreshCurrentUser() -> Observable<User> {
        return network.refreshCurrentUser().map(toCurrentUserMap)
    }
    /// logs out the current user
    public func logout() -> Observable<Void> {
        return network.logout().doOnCompleted {
            self.currentUser = nil
        }
    }
    /// deletes current user from tapglue
    public func deleteCurrentUser() -> Observable<Void> {
        return network.deleteCurrentUser().doOnCompleted {
            self.currentUser = nil
        }
    }
    /// search for users on tapglue
    /// - parameter searchTerm: term to search for
    public func searchUsersForSearchTerm(term: String) -> Observable<[User]> {
        return network.searchUsers(forSearchTerm: term)
    }
    /// Search tapglue for users with emails
    /// - parameter emails: search tapglue for users with emails within this list
    public func searchEmails(emails: [String]) -> Observable<[User]> {
        return network.searchEmails(emails)
    }
    /// Search tapglue for users with social ids
    /// - parameter ids: list of ids to search for
    /// - parameter platform: platform name for which the search is performed
    public func searchSocialIds(ids: [String], onPlatform platform: String) ->
        Observable<[User]> {
        return network.searchSocialIds(ids, onPlatform: platform)
    }
    /// create connection on tapglue
    /// - parameter connection: connection to be created
    public func createConnection(connection: Connection) -> Observable<Connection> {
        return network.createConnection(connection)
    }
    /// delete connection on tapglue
    /// - parameter userId: user id of the user the connection is
    /// - parameter type: the type of connection to be deleted
    public func deleteConnection(toUserId userId: String, type: ConnectionType) 
        -> Observable<Void> {
        return network.deleteConnection(toUserId: userId, type: type)
    }
    /// create connections to users by using their ids from another platform
    /// - parameter socialConnections: contains the platform name and list of ids
    public func createSocialConnections(socialConnections: SocialConnections) ->
        Observable<[User]> {
        return network.createSocialConnections(socialConnections)
    }
    /// retrieves the followers of the current user
    public func retrieveFollowers() -> Observable<[User]> {
        return network.retrieveFollowers()
    }
    /// retrieves the users followed by the current user
    public func retrieveFollowings() -> Observable<[User]> {
        return network.retrieveFollowings()
    }
    /// retrieves followers for a given user
    /// - parameter id: followers of the user of the given id
    public func retrieveFollowersForUserId(id: String) -> Observable<[User]> {
        return network.retrieveFollowersForUserId(id)
    }
    /// retrieves users followed by a given user
    /// - parameter id: followings of the user of the given id
    public func retrieveFollowingsForUserId(id: String) -> Observable<[User]> {
        return network.retrieveFollowingsForUserId(id)
    }
    /// retrieve friends for current user
    public func retrieveFriends() -> Observable<[User]> {
        return network.retrieveFriends()
    }
    /// Retrieve friends for a given user
    /// - parameter id: friends of the user with the given id
    public func retrieveFriendsForUserId(id: String) -> Observable<[User]> {
        return network.retrieveFriendsForUserId(id)
    }
    /// retrieve pending connections
    public func retrievePendingConnections() -> Observable<Connections> {
        return network.retrievePendingConnections() 
    }
    /// retrieve rejected connections
    public func retrieveRejectedConnections() -> Observable<Connections> {
        return network.retrieveRejectedConnections()
    }
    /// retrieve a user
    /// - parameter id: id of the user to be retrieved
    public func retrieveUser(id: String) -> Observable<User> {
        return network.retrieveUser(id)
    }
    /// creates post
    /// - parameter post: post to be created
    public func createPost(post: Post) -> Observable<Post> {
        return network.createPost(post)
    }
    /// retrieve a post
    /// - parameter id: id of the post to be retrieved
    public func retrievePost(id: String) -> Observable<Post> {
        return network.retrievePost(id)
    }
    /// update post
    /// - parameter post: the post to replace the old one
    /// - note: post id must be set on the post object
    public func updatePost(id: String, post: Post) -> Observable<Post> {
        return network.updatePost(id, post: post)
    }
    /// delete post
    /// - parameter id: id of the post to be deleted
    public func deletePost(id: String) -> Observable<Void> {
        return network.deletePost(id)
    }
    /// retrieve posts created by a user
    /// - parameter userId: id of the user from whom the posts will be retrieved
    public func retrievePostsByUser(userId: String) -> Observable<[Post]> {
        return network.retrievePostsByUser(userId)
    }
    /// retrieves all public and global posts
    public func retrieveAllPosts() -> Observable<[Post]> {
        return network.retrieveAllPosts()
    }
    /// Retrieves posts that have all the tags in the tags list. The query behaves like a logical
    /// `and` operation
    /// - parameter tags: tags to filter
    public func filterPostsByTags(tags: [String]) -> Observable<[Post]> {
        return network.filterPostsByTags(tags)
    }
    /// Creates a comment on a post
    public func createComment(comment: Comment) -> Observable<Comment> {
        return network.createComment(comment)
    }
    /// retrieve comments on a post
    public func retrieveComments(postId: String) -> Observable<[Comment]> {
        return network.retrieveComments(postId)
    }
    /// updates comment
    /// - parameter postId: post to which the comment belongs
    /// - parameter commentId: id of the comment to be updated
    /// - parameter comment: the new comment to replace the old
    public func updateComment(postId: String, commentId: String, comment: Comment) ->
        Observable<Comment> {
        return network.updateComment(postId, commentId: commentId, comment: comment)
    }
    /// deletes comment
    /// - parameter postId: post to which the comment belongs
    /// - parameter commentId: id of the comment to be deleted
    public func deleteComment(forPostId postId: String, commentId: String) -> Observable<Void> {
        return network.deleteComment(postId, commentId: commentId)
    }
    /// creates like
    /// - parameter postId: post to be liked
    public func createLike(forPostId postId: String) -> Observable<Like> {
        return network.createLike(forPostId: postId)
    }
    /// retrieves likes on a post
    /// - parameter postId: id of the post
    public func retrieveLikes(postId: String) -> Observable<[Like]> {
        return network.retrieveLikes(postId)
    }
    /// delete like on a post
    /// - parameter postId: post that was liked
    public func deleteLike(forPostId postId: String) -> Observable<Void> {
        return network.deleteLike(forPostId: postId)
    }
    /// retrieves post feed
    public func retrievePostFeed() -> Observable<[Post]> {
        return network.retrievePostFeed()
    }
    /// retrieves activity feed
    /// - note: event feed on the api documentation
    public func retrieveActivityFeed() -> Observable<[Activity]> {
        return network.retrieveActivityFeed()
    }
    /// retrieves news feed
    public func retrieveNewsFeed() -> Observable<NewsFeed> {
        return network.retrieveNewsFeed()
    }
    /// retrieves a feed of activities tageting the current user
    public func retrieveMeFeed() -> Observable<[Activity]> {
        return network.retrieveMeFeed()
    }

    private func toCurrentUserMap(user: User) -> User {
        currentUser = user
        return user
    }
}