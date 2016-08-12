//
//  File.swift
//  Tapglue
//
//  Created by John Nilsen on 7/12/16.
//  Copyright © 2016 Tapglue. All rights reserved.
//

import Foundation
import RxSwift

/// Main interface to the taplgue SDK
public class Tapglue {
    let disposeBag = DisposeBag()
    let rxTapglue: RxTapglue
    
    var currentUser: User? {
        get {
            return rxTapglue.currentUser
        }
    }
    
    /// Constructs instance of Tapglue
    /// - parameter configuration: Configuration to be used
    public init(configuration: Configuration) {
        rxTapglue = RxTapglue(configuration: configuration)
    }
    
    /// logs in user on tapglue
    /// - parameter username: username of the user to be logged in
    /// - parameter password: password of the user to be logged in
    /// - parameter completionHander: where the callbacks will be made
    public func loginUser(username: String, password: String, completionHandler: 
        (user: User?, error: ErrorType?) -> ()) {
        rxTapglue.loginUser(username, password: password).unwrap(completionHandler)
    }

    /// logs in user on tapglue
    /// - parameter email: email of the user to be logged in
    /// - parameter password: password of the user to be logged in 
    /// - parameter completionHander: where the callbacks will be made
    public func loginUserWithEmail(email: String, password: String, completionHandler: 
        (user: User?, error: ErrorType?) -> ()) {
        rxTapglue.loginUserWithEmail(email, password: password).unwrap(completionHandler)
    }

    /// creates a user on tapglue
    /// - parameter user: user to be created
    /// - parameter completionHander: where the callbacks will be made
    /// - parameter completionHander: where the callbacks will be made
    /// - Note: username or email is required, password is required
    /// - Note: does not login user
    public func createUser(user: User, completionHandler: (user: User?, error: ErrorType?) -> ()) {
        rxTapglue.createUser(user).unwrap(completionHandler)
    }

    /// update information on the current user by providing a user entity
    /// - parameter user: entity with the information to be updated
    /// - parameter completionHander: where the callbacks will be made
    public func updateCurrentUser(user: User, completionHandler: (user: User?, error: ErrorType?) -> ()) {
        rxTapglue.updateCurrentUser(user).unwrap(completionHandler)
    }

    /// refreshes locally stored copy of the current user
    /// - parameter completionHander: where the callbacks will be made
    public func refreshCurrentUser(completionHandler: (user: User?, error: ErrorType?) -> ()) {
        rxTapglue.refreshCurrentUser().unwrap(completionHandler)
    }

    /// logs out the current user
    /// - parameter completionHander: where the callbacks will be made
    public func logout(completionHandler: (success:Bool, error:ErrorType?) -> ()) {
        rxTapglue.logout().unwrap(completionHandler)
    }

    /// deletes current user from tapglue
    /// - parameter completionHander: where the callbacks will be made
    public func deleteCurrentUser(completionHandler: (success:Bool, error:ErrorType?) -> ()) {
        rxTapglue.deleteCurrentUser().unwrap(completionHandler)
    }

    /// retrieve a user
    /// - parameter id: id of the user to be retrieved
    /// - parameter completionHander: where the callbacks will be made
    public func retrieveUser(id: String, completionHandler: (user:User?, error: ErrorType?) -> ()) {
        rxTapglue.retrieveUser(id).unwrap(completionHandler)
    }

    /// search for users on tapglue
    /// - parameter searchTerm: term to search for
    /// - parameter completionHander: where the callbacks will be made
    public func searchUsersForSearchTerm(term: String, completionHandler: (result: [User]?,
        error: ErrorType?) -> ()) {
        rxTapglue.searchUsersForSearchTerm(term).unwrap(completionHandler)
    }

    /// Search tapglue for users with emails
    /// - parameter emails: search tapglue for users with emails within this list
    /// - parameter completionHander: where the callbacks will be made
    public func searchEmails(emails: [String], completionHandler:(result: [User]?, error:
        ErrorType?) -> ()) {
        rxTapglue.searchEmails(emails).unwrap(completionHandler)
    }

    /// Search tapglue for users with social ids
    /// - parameter ids: list of ids to search for
    /// - parameter platform: platform name for which the search is performed
    /// - parameter completionHander: where the callbacks will be made
    public func searchSocialIds(ids: [String], onPlatform platform: String,
        completionHandler: (result: [User]?, error:ErrorType?) -> ()) {
        rxTapglue.searchSocialIds(ids, onPlatform: platform).unwrap(completionHandler)
    }

    /// create connection on tapglue
    /// - parameter connection: connection to be created
    /// - parameter completionHander: where the callbacks will be made
    public func createConnection(connection: Connection, 
            completionHandler: (connection: Connection?, error: ErrorType?) -> ()) {
        rxTapglue.createConnection(connection).unwrap(completionHandler)
    }

    /// delete connection on tapglue
    /// - parameter userId: user id of the user the connection is
    /// - parameter type: the type of connection to be deleted
    /// - parameter completionHander: where the callbacks will be made
    public func deleteConnection(toUserId userId: String, type: 
            ConnectionType, completionHandler: (success: Bool, error: ErrorType?) -> ()) {
        rxTapglue.deleteConnection(toUserId: userId, type: type).unwrap(completionHandler)
    }

    /// create connections to users by using their ids from another platform
    /// - parameter socialConnections: contains the platform name and list of ids
    /// - parameter completionHander: where the callbacks will be made
    public func createSocialConnections(socialConnections: SocialConnections, 
        completionHandler: (users: [User]?, error: ErrorType?) -> ()) {
        rxTapglue.createSocialConnections(socialConnections).unwrap(completionHandler)
    }

    /// retrieves the followers of the current user
    /// - parameter completionHander: where the callbacks will be made
    public func retrieveFollowers(completionHandler: (users: [User]?, error: ErrorType?) -> ()) {
        rxTapglue.retrieveFollowers().unwrap(completionHandler)
    }

    /// retrieves the users followed by the current user
    /// - parameter completionHander: where the callbacks will be made
    public func retrieveFollowings(completionHandler: (users: [User]?, error: ErrorType?) -> ()) {
        rxTapglue.retrieveFollowings().unwrap(completionHandler)
    }

    /// retrieves followers for a given user
    /// - parameter id: followers of the user of the given id
    /// - parameter completionHander: where the callbacks will be made
    public func retrieveFollowersForUserId(id: String, 
            completionHandler: (users: [User]?, error:ErrorType?) -> ()) {
        rxTapglue.retrieveFollowersForUserId(id).unwrap(completionHandler)
    }

    /// retrieves users followed by a given user
    /// - parameter id: followings of the user of the given id
    /// - parameter completionHander: where the callbacks will be made
    public func retrieveFollowingsForUserId(id: String, 
            completionHandler: (users: [User]?, error: ErrorType?) -> ()) {
        rxTapglue.retrieveFollowingsForUserId(id).unwrap(completionHandler)
    }

    /// retrieve friends for current user
    /// - parameter completionHander: where the callbacks will be made
    public func retrieveFriends(completionHandler: (users: [User]?, error: ErrorType?) -> ()) {
        rxTapglue.retrieveFriends().unwrap(completionHandler)
    }

    /// Retrieve friends for a given user
    /// - parameter id: friends of the user with the given id
    /// - parameter completionHander: where the callbacks will be made
    public func retrieveFriendsForUserId(id: String,
            completionHandler:(users: [User]?, error: ErrorType?) -> ()) {
        rxTapglue.retrieveFriendsForUserId(id).unwrap(completionHandler)
    }

    /// retrieve pending connections
    /// - parameter completionHander: where the callbacks will be made
    public func retrievePendingConnections(completionHandler: (connections: Connections?, 
            error: ErrorType?) -> ()) {
        rxTapglue.retrievePendingConnections().unwrap(completionHandler)
    }

    /// retrieve rejected connections
    /// - parameter completionHander: where the callbacks will be made
    public func retrieveRejectedConnections(completionHandler: (connections: Connections?,
            error:ErrorType?) -> ()) {
        rxTapglue.retrieveRejectedConnections().unwrap(completionHandler)
    }

    /// creates post
    /// - parameter post: post to be created
    /// - parameter completionHander: where the callbacks will be made
    public func createPost(post: Post, completionHandler: (post: Post?, error: ErrorType?) -> ()) {
        rxTapglue.createPost(post).unwrap(completionHandler)
    }

    /// retrieve a post
    /// - parameter id: id of the post to be retrieved
    /// - parameter completionHander: where the callbacks will be made
    public func retrievePost(id: String, completionHandler: (post: Post?, error: ErrorType?) -> ()) {
        rxTapglue.retrievePost(id).unwrap(completionHandler)
    }

    /// update post
    /// - parameter post: the post to replace the old one
    /// - note: post id must be set on the post object
    /// - parameter completionHander: where the callbacks will be made
    public func updatePost(id: String, post: Post, completionHandler: (post: Post?, error: ErrorType?) -> ()) {
        rxTapglue.updatePost(id, post: post).unwrap(completionHandler)
    }

    /// delete post
    /// - parameter id: id of the post to be deleted
    /// - parameter completionHander: where the callbacks will be made
    public func deletePost(id: String, completionHandler: (success: Bool, error: ErrorType?) -> ()) {
        rxTapglue.deletePost(id).unwrap(completionHandler)
    }

    /// retrieve posts created by a user
    /// - parameter userId: id of the user from whom the posts will be retrieved
    /// - parameter completionHander: where the callbacks will be made
    public func retrievePostsByUser(userId: String, completionHandler: 
        (post: [Post]?, error: ErrorType?) -> ()) {
        rxTapglue.retrievePostsByUser(userId).unwrap(completionHandler)
    }

    /// retrieves all public and global posts
    /// - parameter completionHander: where the callbacks will be made
    public func retrieveAllPosts(completionHandler: (posts: [Post]?, error: ErrorType?) -> ()) {
        rxTapglue.retrieveAllPosts().unwrap(completionHandler)
    }

    /// Retrieves posts that have all the tags in the tags list. The query behaves like a logical
    /// `and` operation
    /// - parameter tags: tags to filter
    public func filterPostsByTags(tags: [String], 
        completionHandler: (posts: [Post]?, error: ErrorType?) -> ()) {
        rxTapglue.filterPostsByTags(tags).unwrap(completionHandler)
    }
    
    /// Creates a comment on a post
    /// - parameter completionHander: where the callbacks will be made
    public func createComment(comment: Comment, completionHandler: (comment: Comment?, error: ErrorType?) -> ()) {
        rxTapglue.createComment(comment).unwrap(completionHandler)
    }

    /// retrieve comments on a post
    /// - parameter completionHander: where the callbacks will be made
    public func retrieveComments(postId: String, completionHandler: (comments: [Comment]?, error: ErrorType?) -> ()) {
        rxTapglue.retrieveComments(postId).unwrap(completionHandler)
    }
    
    /// updates comment
    /// - parameter postId: post to which the comment belongs
    /// - parameter commentId: id of the comment to be updated
    /// - parameter comment: the new comment to replace the old
    /// - parameter completionHander: where the callbacks will be made
    public func updateComment(postId: String, commentId: String, comment: Comment, completionHandler: (comment: Comment?, error: ErrorType?) -> ()) {
        rxTapglue.updateComment(postId, commentId: commentId,comment: comment).unwrap(completionHandler)
    }
    
    /// deletes comment
    /// - parameter postId: post to which the comment belongs
    /// - parameter commentId: id of the comment to be deleted
    /// - parameter completionHander: where the callbacks will be made
    public func deleteComment(forPostId postId: String, commentId: String, completionHandler: (success: Bool, error: ErrorType?) -> ()) {
        rxTapglue.deleteComment(forPostId: postId, commentId: commentId).unwrap(completionHandler)
    }
    
    /// creates like
    /// - parameter postId: post to be liked
    /// - parameter completionHander: where the callbacks will be made
    public func createLike(forPostId postId: String, completionHandler: (like: Like?, error: ErrorType?) -> ()) {
        rxTapglue.createLike(forPostId: postId).unwrap(completionHandler)
    }
    
    /// retrieves likes on a post
    /// - parameter postId: id of the post
    /// - parameter completionHander: where the callbacks will be made
    public func retrieveLikes(postId: String, completionHandler: (likes: [Like]?, error: ErrorType?) -> ()) {
        rxTapglue.retrieveLikes(postId).unwrap(completionHandler)
    }
    
    /// delete like on a post
    /// - parameter postId: post that was liked
    /// - parameter completionHander: where the callbacks will be made
    public func deleteLike(forPostId postId: String, completionHandler: (success: Bool, error: ErrorType?) -> ()) {
        rxTapglue.deleteLike(forPostId: postId).unwrap(completionHandler)
    }

    /// retrieves post feed
    /// - parameter completionHander: where the callbacks will be made
    public func retrievePostFeed(completionHandler: (posts: [Post]?, error: ErrorType?) -> ()) {
        rxTapglue.retrievePostFeed().unwrap(completionHandler)
    }

    /// retrieves activity feed
    /// - note: event feed on the api documentation
    /// - parameter completionHander: where the callbacks will be made
    public func retrieveActivityFeed(completionHandler:
        (activities: [Activity]?, error: ErrorType?) -> ()) {
        rxTapglue.retrieveActivityFeed().unwrap(completionHandler)
    }

    /// retrieves news feed
    /// - parameter completionHander: where the callbacks will be made
    public func retrieveNewsFeed(completionHandler: (feed: NewsFeed?, error:ErrorType?) -> ()) {
        rxTapglue.retrieveNewsFeed().unwrap(completionHandler)
    }

    /// retrieves a feed of activities tageting the current user
    public func retrieveMeFeed(completionHandler: 
        (activities: [Activity]?, error: ErrorType?) -> ()) {
        rxTapglue.retrieveMeFeed().unwrap(completionHandler)
    }
}