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
open class RxTapglue {
    
    var userStore = UserStore()
    
    var network: Network
    open fileprivate(set) var currentUser: User? {
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
    open func createUser(_ user: User) -> Observable<User> {
        return network.createUser(user)
    }
    /// logs in user on tapglue
    /// - parameter username: username of the user to be logged in
    /// - parameter password: password of the user to be logged in
    open func loginUser(_ username: String, password: String) -> Observable<User> {
        return network.loginUser(username, password: password).map(toCurrentUserMap)
    }
    /// logs in user on tapglue
    /// - parameter email: email of the user to be logged in
    /// - parameter password: password of the user to be logged in 
    open func loginUserWithEmail(_ email: String, password: String) -> Observable<User> {
        return network.loginUserWithEmail(email, password: password).map(toCurrentUserMap)
    }
    /// update information on the current user by providing a user entity
    /// - parameter user: entity with the information to be updated
    open func updateCurrentUser(_ user: User) -> Observable<User> {
        return network.updateCurrentUser(user).map(toCurrentUserMap)
    }
    /// refreshes locally stored copy of the current user
    open func refreshCurrentUser() -> Observable<User> {
        return network.refreshCurrentUser().map(toCurrentUserMap)
    }
    /// logs out the current user
    open func logout() -> Observable<Void> {
        return network.logout().doOnCompleted {
            self.currentUser = nil
        }
    }
    /// deletes current user from tapglue
    open func deleteCurrentUser() -> Observable<Void> {
        return network.deleteCurrentUser().doOnCompleted {
            self.currentUser = nil
        }
    }
    /// search for users on tapglue
    /// - parameter searchTerm: term to search for
    open func searchUsersForSearchTerm(_ term: String) -> Observable<[User]> {
        return network.searchUsers(forSearchTerm: term)
    }
    /// Search tapglue for users with emails
    /// - parameter emails: search tapglue for users with emails within this list
    open func searchEmails(_ emails: [String]) -> Observable<[User]> {
        return network.searchEmails(emails)
    }
    /// Search tapglue for users with social ids
    /// - parameter ids: list of ids to search for
    /// - parameter platform: platform name for which the search is performed
    open func searchSocialIds(_ ids: [String], onPlatform platform: String) ->
        Observable<[User]> {
        return network.searchSocialIds(ids, onPlatform: platform)
    }
    /// create connection on tapglue
    /// - parameter connection: connection to be created
    open func createConnection(_ connection: Connection) -> Observable<Connection> {
        return network.createConnection(connection)
    }
    /// delete connection on tapglue
    /// - parameter userId: user id of the user the connection is
    /// - parameter type: the type of connection to be deleted
    open func deleteConnection(toUserId userId: String, type: ConnectionType) 
        -> Observable<Void> {
        return network.deleteConnection(toUserId: userId, type: type)
    }
    /// create connections to users by using their ids from another platform
    /// - parameter socialConnections: contains the platform name and list of ids
    open func createSocialConnections(_ socialConnections: SocialConnections) ->
        Observable<[User]> {
        return network.createSocialConnections(socialConnections)
    }
    /// retrieves the followers of the current user
    open func retrieveFollowers() -> Observable<[User]> {
        return network.retrieveFollowers()
    }
    /// retrieves the users followed by the current user
    open func retrieveFollowings() -> Observable<[User]> {
        return network.retrieveFollowings()
    }
    /// retrieves followers for a given user
    /// - parameter id: followers of the user of the given id
    open func retrieveFollowersForUserId(_ id: String) -> Observable<[User]> {
        return network.retrieveFollowersForUserId(id)
    }
    /// retrieves users followed by a given user
    /// - parameter id: followings of the user of the given id
    open func retrieveFollowingsForUserId(_ id: String) -> Observable<[User]> {
        return network.retrieveFollowingsForUserId(id)
    }
    /// retrieve friends for current user
    open func retrieveFriends() -> Observable<[User]> {
        return network.retrieveFriends()
    }
    /// Retrieve friends for a given user
    /// - parameter id: friends of the user with the given id
    open func retrieveFriendsForUserId(_ id: String) -> Observable<[User]> {
        return network.retrieveFriendsForUserId(id)
    }
    /// retrieve pending connections
    open func retrievePendingConnections() -> Observable<Connections> {
        return network.retrievePendingConnections() 
    }
    /// retrieve rejected connections
    open func retrieveRejectedConnections() -> Observable<Connections> {
        return network.retrieveRejectedConnections()
    }
    /// retrieve a user
    /// - parameter id: id of the user to be retrieved
    open func retrieveUser(_ id: String) -> Observable<User> {
        return network.retrieveUser(id)
    }
    /// creates post
    /// - parameter post: post to be created
    open func createPost(_ post: Post) -> Observable<Post> {
        return network.createPost(post)
    }
    /// retrieve a post
    /// - parameter id: id of the post to be retrieved
    open func retrievePost(_ id: String) -> Observable<Post> {
        return network.retrievePost(id)
    }
    /// update post
    /// - parameter post: the post to replace the old one
    /// - note: post id must be set on the post object
    open func updatePost(_ id: String, post: Post) -> Observable<Post> {
        return network.updatePost(id, post: post)
    }
    /// delete post
    /// - parameter id: id of the post to be deleted
    open func deletePost(_ id: String) -> Observable<Void> {
        return network.deletePost(id)
    }
    /// retrieve posts created by a user
    /// - parameter userId: id of the user from whom the posts will be retrieved
    open func retrievePostsByUser(_ userId: String) -> Observable<[Post]> {
        return network.retrievePostsByUser(userId)
    }
    /// retrieves all public and global posts
    open func retrieveAllPosts() -> Observable<[Post]> {
        return network.retrieveAllPosts()
    }
    /// Retrieves posts that have all the tags in the tags list. The query behaves like a logical
    /// `and` operation
    /// - parameter tags: tags to filter
    open func filterPostsByTags(_ tags: [String]) -> Observable<[Post]> {
        return network.filterPostsByTags(tags)
    }
    /// Creates a comment on a post
    open func createComment(_ comment: Comment) -> Observable<Comment> {
        return network.createComment(comment)
    }
    /// retrieve comments on a post
    open func retrieveComments(_ postId: String) -> Observable<[Comment]> {
        return network.retrieveComments(postId)
    }
    /// updates comment
    /// - parameter postId: post to which the comment belongs
    /// - parameter commentId: id of the comment to be updated
    /// - parameter comment: the new comment to replace the old
    open func updateComment(_ postId: String, commentId: String, comment: Comment) ->
        Observable<Comment> {
        return network.updateComment(postId, commentId: commentId, comment: comment)
    }
    /// deletes comment
    /// - parameter postId: post to which the comment belongs
    /// - parameter commentId: id of the comment to be deleted
    open func deleteComment(forPostId postId: String, commentId: String) -> Observable<Void> {
        return network.deleteComment(postId, commentId: commentId)
    }
    /// creates like
    /// - parameter postId: post to be liked
    open func createLike(forPostId postId: String) -> Observable<Like> {
        return network.createLike(forPostId: postId)
    }
    /// retrieves likes on a post
    /// - parameter postId: id of the post
    open func retrieveLikes(_ postId: String) -> Observable<[Like]> {
        return network.retrieveLikes(postId)
    }
    /// delete like on a post
    /// - parameter postId: post that was liked
    open func deleteLike(forPostId postId: String) -> Observable<Void> {
        return network.deleteLike(forPostId: postId)
    }

    open func retrieveLikesByUser(_ userId: String) -> Observable<[Like]> {
        return network.retrieveLikesByUser(userId)
    }
    /// Retrieves activities created by a user
    /// - parameter userId: user from whom you want the activities
    open func retrieveActivitiesByUser(_ userId: String) -> Observable<[Activity]> {
        return network.retrieveActivitiesByUser(userId)
    }
    /// retrieves post feed
    open func retrievePostFeed() -> Observable<[Post]> {
        return network.retrievePostFeed()
    }
    /// retrieves activity feed
    /// - note: event feed on the api documentation
    open func retrieveActivityFeed() -> Observable<[Activity]> {
        return network.retrieveActivityFeed()
    }
    /// retrieves news feed
    open func retrieveNewsFeed() -> Observable<NewsFeed> {
        return network.retrieveNewsFeed()
    }
    /// retrieves a feed of activities tageting the current user
    open func retrieveMeFeed() -> Observable<[Activity]> {
        return network.retrieveMeFeed()
    }

    fileprivate func toCurrentUserMap(_ user: User) -> User {
        currentUser = user
        return user
    }
}
