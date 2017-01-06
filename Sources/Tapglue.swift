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
open class Tapglue {
    let disposeBag = DisposeBag()
    let rxTapglue: RxTapglue
    
    open var currentUser: User? {
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
    open func loginUser(_ username: String, password: String, completionHandler: @escaping
        (_ user: User?, _ error: Error?) -> ()) {
        rxTapglue.loginUser(username, password: password).unwrap(completionHandler)
    }

    /// logs in user on tapglue
    /// - parameter email: email of the user to be logged in
    /// - parameter password: password of the user to be logged in 
    /// - parameter completionHander: where the callbacks will be made
    open func loginUserWithEmail(_ email: String, password: String, completionHandler: @escaping 
        (_ user: User?, _ error: Error?) -> ()) {
        rxTapglue.loginUserWithEmail(email, password: password).unwrap(completionHandler)
    }

    /// creates a user on tapglue
    /// - parameter user: user to be created
    /// - parameter completionHander: where the callbacks will be made
    /// - parameter completionHander: where the callbacks will be made
    /// - Note: username or email is required, password is required
    /// - Note: does not login user
    open func createUser(_ user: User, completionHandler: @escaping (_ user: User?, _ error: Error?) -> ()) {
        rxTapglue.createUser(user).unwrap(completionHandler)
    }

    /// update information on the current user by providing a user entity
    /// - parameter user: entity with the information to be updated
    /// - parameter completionHander: where the callbacks will be made
    open func updateCurrentUser(_ user: User, completionHandler: @escaping (_ user: User?, _ error: Error?) -> ()) {
        rxTapglue.updateCurrentUser(user).unwrap(completionHandler)
    }

    /// refreshes locally stored copy of the current user
    /// - parameter completionHander: where the callbacks will be made
    open func refreshCurrentUser(_ completionHandler: @escaping (_ user: User?, _ error: Error?) -> ()) {
        rxTapglue.refreshCurrentUser().unwrap(completionHandler)
    }

    /// logs out the current user
    /// - parameter completionHander: where the callbacks will be made
    open func logout(_ completionHandler: @escaping (_ success:Bool, _ error:Error?) -> ()) {
        rxTapglue.logout().unwrap(completionHandler)
    }

    /// deletes current user from tapglue
    /// - parameter completionHander: where the callbacks will be made
    open func deleteCurrentUser(_ completionHandler: @escaping (_ success:Bool, _ error:Error?) -> ()) {
        rxTapglue.deleteCurrentUser().unwrap(completionHandler)
    }

    /// retrieve a user
    /// - parameter id: id of the user to be retrieved
    /// - parameter completionHander: where the callbacks will be made
    open func retrieveUser(_ id: String, completionHandler: @escaping (_ user:User?, _ error: Error?) -> ()) {
        rxTapglue.retrieveUser(id).unwrap(completionHandler)
    }

    /// search for users on tapglue
    /// - parameter searchTerm: term to search for
    /// - parameter completionHander: where the callbacks will be made
    @available(*, deprecated: 2.1)
    open func searchUsersForSearchTerm(_ term: String, completionHandler: @escaping (_ result: [User]?,
        _ error: Error?) -> ()) {
        rxTapglue.searchUsersForSearchTerm(term).unwrap(completionHandler)
    }

    /// Search tapglue for users with emails
    /// - parameter emails: search tapglue for users with emails within this list
    /// - parameter completionHander: where the callbacks will be made
    @available(*, deprecated: 2.1)
    open func searchEmails(_ emails: [String], completionHandler: @escaping (_ result: [User]?, _ error:
        Error?) -> ()) {
        rxTapglue.searchEmails(emails).unwrap(completionHandler)
    }

    /// Search tapglue for users with social ids
    /// - parameter ids: list of ids to search for
    /// - parameter platform: platform name for which the search is performed
    /// - parameter completionHander: where the callbacks will be made
    @available(*, deprecated: 2.1)
    open func searchSocialIds(_ ids: [String], onPlatform platform: String,
        completionHandler: @escaping (_ result: [User]?, _ error:Error?) -> ()) {
        rxTapglue.searchSocialIds(ids, onPlatform: platform).unwrap(completionHandler)
    }

    /// create connection on tapglue
    /// - parameter connection: connection to be created
    /// - parameter completionHander: where the callbacks will be made
    open func createConnection(_ connection: Connection, 
            completionHandler: @escaping (_ connection: Connection?, _ error: Error?) -> ()) {
        rxTapglue.createConnection(connection).unwrap(completionHandler)
    }

    /// delete connection on tapglue
    /// - parameter userId: user id of the user the connection is
    /// - parameter type: the type of connection to be deleted
    /// - parameter completionHander: where the callbacks will be made
    open func deleteConnection(toUserId userId: String, type: 
            ConnectionType, completionHandler: @escaping (_ success: Bool, _ error: Error?) -> ()) {
        rxTapglue.deleteConnection(toUserId: userId, type: type).unwrap(completionHandler)
    }

    /// create connections to users by using their ids from another platform
    /// - parameter socialConnections: contains the platform name and list of ids
    /// - parameter completionHander: where the callbacks will be made
    @available(*, deprecated: 2.1)
    open func createSocialConnections(_ socialConnections: SocialConnections, 
        completionHandler: @escaping (_ users: [User]?, _ error: Error?) -> ()) {
        rxTapglue.createSocialConnections(socialConnections).unwrap(completionHandler)
    }

    /// retrieves the followers of the current user
    /// - parameter completionHander: where the callbacks will be made
    @available(*, deprecated: 2.1)
    open func retrieveFollowers(_ completionHandler: @escaping (_ users: [User]?, _ error: Error?) -> ()) {
        rxTapglue.retrieveFollowers().unwrap(completionHandler)
    }

    /// retrieves the users followed by the current user
    /// - parameter completionHander: where the callbacks will be made
    @available(*, deprecated: 2.1)
    open func retrieveFollowings(_ completionHandler: @escaping (_ users: [User]?, _ error: Error?) -> ()) {
        rxTapglue.retrieveFollowings().unwrap(completionHandler)
    }

    /// retrieves followers for a given user
    /// - parameter id: followers of the user of the given id
    /// - parameter completionHander: where the callbacks will be made
    @available(*, deprecated: 2.1)
    open func retrieveFollowersForUserId(_ id: String, 
            completionHandler: @escaping (_ users: [User]?, _ error:Error?) -> ()) {
        rxTapglue.retrieveFollowersForUserId(id).unwrap(completionHandler)
    }

    /// retrieves users followed by a given user
    /// - parameter id: followings of the user of the given id
    /// - parameter completionHander: where the callbacks will be made
    @available(*, deprecated: 2.1)
    open func retrieveFollowingsForUserId(_ id: String, 
            completionHandler: @escaping (_ users: [User]?, _ error: Error?) -> ()) {
        rxTapglue.retrieveFollowingsForUserId(id).unwrap(completionHandler)
    }

    /// retrieve friends for current user
    /// - parameter completionHander: where the callbacks will be made
    @available(*, deprecated: 2.1)
    open func retrieveFriends(_ completionHandler: @escaping (_ users: [User]?, _ error: Error?) -> ()) {
        rxTapglue.retrieveFriends().unwrap(completionHandler)
    }

    /// Retrieve friends for a given user
    /// - parameter id: friends of the user with the given id
    /// - parameter completionHander: where the callbacks will be made
    @available(*, deprecated: 2.1)
    open func retrieveFriendsForUserId(_ id: String,
            completionHandler: @escaping (_ users: [User]?, _ error: Error?) -> ()) {
        rxTapglue.retrieveFriendsForUserId(id).unwrap(completionHandler)
    }

    /// retrieve pending connections
    /// - parameter completionHander: where the callbacks will be made
    @available(*, deprecated: 2.1)
    open func retrievePendingConnections(_ completionHandler: @escaping (_ connections: Connections?,
            _ error: Error?) -> ()) {
        rxTapglue.retrievePendingConnections().unwrap(completionHandler)
    }

    /// retrieve rejected connections
    /// - parameter completionHander: where the callbacks will be made
    @available(*, deprecated: 2.1)
    open func retrieveRejectedConnections(_ completionHandler: @escaping (_ connections: Connections?,
            _ error:Error?) -> ()) {
        rxTapglue.retrieveRejectedConnections().unwrap(completionHandler)
    }

    /// creates post
    /// - parameter post: post to be created
    /// - parameter completionHander: where the callbacks will be made
    open func createPost(_ post: Post, completionHandler: @escaping (_ post: Post?, _ error: Error?) -> ()) {
        rxTapglue.createPost(post).unwrap(completionHandler)
    }

    /// retrieve a post
    /// - parameter id: id of the post to be retrieved
    /// - parameter completionHander: where the callbacks will be made
    open func retrievePost(_ id: String, completionHandler: @escaping (_ post: Post?, _ error: Error?) -> ()) {
        rxTapglue.retrievePost(id).unwrap(completionHandler)
    }

    /// update post
    /// - parameter post: the post to replace the old one
    /// - note: post id must be set on the post object
    /// - parameter completionHander: where the callbacks will be made
    open func updatePost(_ id: String, post: Post, completionHandler: @escaping (_ post: Post?, _ error: Error?) -> ()) {
        rxTapglue.updatePost(id, post: post).unwrap(completionHandler)
    }

    /// delete post
    /// - parameter id: id of the post to be deleted
    /// - parameter completionHander: where the callbacks will be made
    open func deletePost(_ id: String, completionHandler: @escaping (_ success: Bool, _ error: Error?) -> ()) {
        rxTapglue.deletePost(id).unwrap(completionHandler)
    }

    /// retrieve posts created by a user
    /// - parameter userId: id of the user from whom the posts will be retrieved
    /// - parameter completionHander: where the callbacks will be made
    @available(*, deprecated: 2.1)
    open func retrievePostsByUser(_ userId: String, completionHandler: @escaping 
        (_ post: [Post]?, _ error: Error?) -> ()) {
        rxTapglue.retrievePostsByUser(userId).unwrap(completionHandler)
    }

    /// retrieves all open and global posts
    /// - parameter completionHander: where the callbacks will be made
    @available(*, deprecated: 2.1)
    open func retrieveAllPosts(_ completionHandler: @escaping (_ posts: [Post]?, _ error: Error?) -> ()) {
        rxTapglue.retrieveAllPosts().unwrap(completionHandler)
    }

    /// Retrieves posts that have all the tags in the tags list. The query behaves like a logical
    /// `and` operation
    /// - parameter tags: tags to filter
    @available(*, deprecated: 2.1)
    open func filterPostsByTags(_ tags: [String], 
        completionHandler: @escaping (_ posts: [Post]?, _ error: Error?) -> ()) {
        rxTapglue.filterPostsByTags(tags).unwrap(completionHandler)
    }
    
    /// Creates a comment on a post
    /// - parameter completionHander: where the callbacks will be made
    open func createComment(_ comment: Comment, completionHandler: @escaping (_ comment: Comment?, _ error: Error?) -> ()) {
        rxTapglue.createComment(comment).unwrap(completionHandler)
    }

    /// retrieve comments on a post
    /// - parameter completionHander: where the callbacks will be made
    @available(*, deprecated: 2.1)
    open func retrieveComments(_ postId: String, completionHandler: @escaping (_ comments: [Comment]?, _ error: Error?) -> ()) {
        rxTapglue.retrieveComments(postId).unwrap(completionHandler)
    }
    
    /// updates comment
    /// - parameter postId: post to which the comment belongs
    /// - parameter commentId: id of the comment to be updated
    /// - parameter comment: the new comment to replace the old
    /// - parameter completionHander: where the callbacks will be made
    open func updateComment(_ postId: String, commentId: String, comment: Comment, completionHandler: @escaping (_ comment: Comment?, _ error: Error?) -> ()) {
        rxTapglue.updateComment(postId, commentId: commentId,comment: comment).unwrap(completionHandler)
    }
    
    /// deletes comment
    /// - parameter postId: post to which the comment belongs
    /// - parameter commentId: id of the comment to be deleted
    /// - parameter completionHander: where the callbacks will be made
    open func deleteComment(forPostId postId: String, commentId: String, completionHandler: @escaping (_ success: Bool, _ error: Error?) -> ()) {
        rxTapglue.deleteComment(forPostId: postId, commentId: commentId).unwrap(completionHandler)
    }
    
    /// creates like
    /// - parameter postId: post to be liked
    /// - parameter completionHander: where the callbacks will be made
    open func createLike(forPostId postId: String, completionHandler: @escaping (_ like: Like?, _ error: Error?) -> ()) {
        rxTapglue.createLike(forPostId: postId).unwrap(completionHandler)
    }

    /// creates reaction on a post
    /// - parameter reaction: the reaction to be created. Check corresponding class for more 
    /// information
    /// - forPostId: post on which the reaction is created
    open func createReaction(_ reaction: Reaction, forPostId postId: String, completionHandler:
        @escaping (_ success: Bool, _ error: Error?) -> ()) {
        rxTapglue.createReaction(reaction, forPostId: postId).unwrap(completionHandler)
    }

    /// deletes reaction
    /// - parameter reaction: the reaction to be deleted. Check corresponding class for more 
    /// information
    /// - forPostId: post on which the reaction is deleted
    open func deleteReaction(_ reaction: Reaction, forPostId postId: String, completionHandler:
        @escaping (_ success: Bool, _ error: Error?) -> ()) {
        rxTapglue.deleteReaction(reaction, forPostId: postId).unwrap(completionHandler)
    }
    
    /// retrieves likes on a post
    /// - parameter postId: id of the post
    /// - parameter completionHander: where the callbacks will be made
    @available(*, deprecated: 2.1)
    open func retrieveLikes(_ postId: String, completionHandler: @escaping (_ likes: [Like]?, _ error: Error?) -> ()) {
        rxTapglue.retrieveLikes(postId).unwrap(completionHandler)
    }
    
    /// delete like on a post
    /// - parameter postId: post that was liked
    /// - parameter completionHander: where the callbacks will be made
    open func deleteLike(forPostId postId: String, completionHandler: @escaping (_ success: Bool, _ error: Error?) -> ()) {
        rxTapglue.deleteLike(forPostId: postId).unwrap(completionHandler)
    }

    @available(*, deprecated: 2.1)
    open func retrieveLikesByUser(_ userId: String,
        completionHandler: @escaping (_ likes: [Like]?, _ error: Error?) -> ()) {
        rxTapglue.retrieveLikesByUser(userId).unwrap(completionHandler)
    }

    /// retrieves post feed
    /// - parameter completionHander: where the callbacks will be made
    @available(*, deprecated: 2.1)
    open func retrievePostFeed(_ completionHandler: @escaping (_ posts: [Post]?, _ error: Error?) -> ()) {
        rxTapglue.retrievePostFeed().unwrap(completionHandler)
    }

    /// retrieves activity feed
    /// - note: event feed on the api documentation
    /// - parameter completionHander: where the callbacks will be made
    @available(*, deprecated: 2.1)
    open func retrieveActivityFeed(_ completionHandler: @escaping
        (_ activities: [Activity]?, _ error: Error?) -> ()) {
        rxTapglue.retrieveActivityFeed().unwrap(completionHandler)
    }

    /// retrieves news feed
    /// - parameter completionHander: where the callbacks will be made
    @available(*, deprecated: 2.1)
    open func retrieveNewsFeed(_ completionHandler: @escaping (_ feed: NewsFeed?, _ error:Error?) -> ()) {
        rxTapglue.retrieveNewsFeed().unwrap(completionHandler)
    }

    /// retrieves a feed of activities tageting the current user
    @available(*, deprecated: 2.1)
    open func retrieveMeFeed(_ completionHandler: @escaping
        ([Activity]?, Error?) -> ()) {
        rxTapglue.retrieveMeFeed().unwrap(completionHandler)
    }
    

    /// search for users on tapglue
    /// - parameter searchTerm: term to search for
    /// - parameter completionHander: where the callbacks will be made
    open func searchUsersForSearchTerm(_ term: String, completionHandler: @escaping (Page<User>?,
        Error?) -> ()) {
        rxTapglue.searchUsersForSearchTerm(term).map { (rxPage: RxPage<User>) in 
            return rxPage.page()
        }.unwrap(completionHandler)
    }

    /// Search tapglue for users with emails
    /// - parameter emails: search tapglue for users with emails within this list
    /// - parameter completionHander: where the callbacks will be made
    open func searchEmails(_ emails: [String], completionHandler: @escaping(Page<User>?,
        Error?) -> ()) {
        rxTapglue.searchEmails(emails).map { (rxPage:RxPage<User>) in
            return rxPage.page()
        }.unwrap(completionHandler)
    }

    /// Search tapglue for users with social ids
    /// - parameter ids: list of ids to search for
    /// - parameter platform: platform name for which the search is performed
    /// - parameter completionHander: where the callbacks will be made
    open func searchSocialIds(_ ids: [String], onPlatform platform: String,
        completionHandler: @escaping (Page<User>?, Error?) -> ()) {
        rxTapglue.searchSocialIds(ids, onPlatform: platform).map { (rxPage:RxPage<User>) in
            return rxPage.page()
        }.unwrap(completionHandler)
    }

    /// create connections to users by using their ids from another platform
    /// - parameter socialConnections: contains the platform name and list of ids
    /// - parameter completionHander: where the callbacks will be made
    open func createSocialConnections(_ socialConnections: SocialConnections, 
        completionHandler: @escaping (Page<User>?, Error?) -> ()) {
        rxTapglue.createSocialConnections(socialConnections).map { (rxPage: RxPage<User>) in
            return rxPage.page()
        }.unwrap(completionHandler)
    }

    /// retrieves the followers of the current user
    /// - parameter completionHander: where the callbacks will be made
    open func retrieveFollowers(_ completionHandler: @escaping (Page<User>?, Error?) -> ()) {
        rxTapglue.retrieveFollowers().map{ (rxPage: RxPage<User>) in
            return rxPage.page()
        }.unwrap(completionHandler)
    }

    /// retrieves the users followed by the current user
    /// - parameter completionHander: where the callbacks will be made
    open func retrieveFollowings(_ completionHandler: @escaping (Page<User>?, Error?) -> ()) {
        rxTapglue.retrieveFollowings().map { (rxPage: RxPage<User>) in
            return rxPage.page()
        }.unwrap(completionHandler)
    }

    /// retrieves followers for a given user
    /// - parameter id: followers of the user of the given id
    /// - parameter completionHander: where the callbacks will be made
    open func retrieveFollowersForUserId(_ id: String, 
            completionHandler: @escaping (Page<User>?, Error?) -> ()) {
        rxTapglue.retrieveFollowersForUserId(id).map { (rxPage: RxPage<User>) in
            return rxPage.page()
        }.unwrap(completionHandler)
    }

    /// retrieves users followed by a given user
    /// - parameter id: followings of the user of the given id
    /// - parameter completionHander: where the callbacks will be made
    open func retrieveFollowingsForUserId(_ id: String, 
            completionHandler: @escaping (Page<User>?, Error?) -> ()) {
        rxTapglue.retrieveFollowingsForUserId(id).map { (rxPage: RxPage<User>) in
            return rxPage.page()
        }.unwrap(completionHandler)
    }

    /// retrieve friends for current user
    /// - parameter completionHander: where the callbacks will be made
    open func retrieveFriends(_ completionHandler: @escaping (Page<User>?, Error?) -> ()) {
        rxTapglue.retrieveFriends().map { (rxPage: RxPage<User>) in
            return rxPage.page()
        }.unwrap(completionHandler)
    }

    /// Retrieve friends for a given user
    /// - parameter id: friends of the user with the given id
    /// - parameter completionHander: where the callbacks will be made
    open func retrieveFriendsForUserId(_ id: String,
            completionHandler: @escaping(Page<User>?, Error?) -> ()) {
        rxTapglue.retrieveFriendsForUserId(id).map { (rxPage:RxPage<User>) in
            return rxPage.page()
        }.unwrap(completionHandler)
    }

    /// retrieve pending connections
    /// - parameter completionHander: where the callbacks will be made
    open func retrievePendingConnections(_ completionHandler: @escaping (CompositePage<Connections>?, 
            Error?) -> ()) {
        rxTapglue.retrievePendingConnections().map { (rxPage: RxCompositePage<Connections>) in
            return rxPage.page()
        }.unwrap(completionHandler)
    }

    /// retrieve rejected connections
    /// - parameter completionHander: where the callbacks will be made
    open func retrieveRejectedConnections(_ completionHandler: @escaping (CompositePage<Connections>?,
            Error?) -> ()) {
        rxTapglue.retrieveRejectedConnections().map { (rxPage: RxCompositePage<Connections>) in
            return rxPage.page()
        }.unwrap(completionHandler)
    }

    /// retrieve posts created by a user
    /// - parameter userId: id of the user from whom the posts will be retrieved
    /// - parameter completionHander: where the callbacks will be made
    open func retrievePostsByUser(_ userId: String, completionHandler: @escaping 
        (Page<Post>?, Error?) -> ()) {
        rxTapglue.retrievePostsByUser(userId).map { (rxPage: RxPage<Post>) in
            return rxPage.page()
        }.unwrap(completionHandler)
    }

    /// retrieves all open and global posts
    /// - parameter completionHander: where the callbacks will be made
    open func retrieveAllPosts(_ completionHandler: @escaping (Page<Post>?, Error?) -> ()) {
        rxTapglue.retrieveAllPosts().map { (rxPage: RxPage<Post>) in
            return rxPage.page()
        }.unwrap(completionHandler)
    }

    /// Retrieves posts that have all the tags in the tags list. The query behaves like a logical
    /// `and` operation
    /// - parameter tags: tags to filter
    open func filterPostsByTags(_ tags: [String], 
        completionHandler: @escaping (Page<Post>?, Error?) -> ()) {
        rxTapglue.filterPostsByTags(tags).map { (rxPage:RxPage<Post>) in
            return rxPage.page()
        }.unwrap(completionHandler)
    }

    /// retrieve comments on a post
    /// - parameter completionHander: where the callbacks will be made
    open func retrieveComments(_ postId: String, completionHandler: @escaping (Page<Comment>?, Error?) -> ()) {
        rxTapglue.retrieveComments(postId).map { (rxPage: RxPage<Comment>) in
            return rxPage.page()
        }.unwrap(completionHandler)
    }
    
    /// retrieves likes on a post
    /// - parameter postId: id of the post
    /// - parameter completionHander: where the callbacks will be made
    open func retrieveLikes(_ postId: String, completionHandler: @escaping (Page<Like>?, Error?) -> ()) {
        rxTapglue.retrieveLikes(postId).map { (rxPage: RxPage<Like>) in
            return rxPage.page()
        }.unwrap(completionHandler)
    }

    open func retrieveLikesByUser(_ userId: String, 
        completionHandler: @escaping (Page<Like>?, Error?) -> ()) {
        rxTapglue.retrieveLikesByUser(userId).map { (rxPage: RxPage<Like>) in
            return rxPage.page()
        }.unwrap(completionHandler)
    }

    /// retrieves post feed
    /// - parameter completionHander: where the callbacks will be made
    open func retrievePostFeed(_ completionHandler: @escaping (Page<Post>?, Error?) -> ()) {
        rxTapglue.retrievePostFeed().map { (rxPage: RxPage<Post>) in
            return rxPage.page()
        }.unwrap(completionHandler)
    }

    /// retrieves activity feed
    /// - note: event feed on the api documentation
    /// - parameter completionHander: where the callbacks will be made
    open func retrieveActivityFeed(_ completionHandler: @escaping
        (Page<Activity>?, Error?) -> ()) {
        rxTapglue.retrieveActivityFeed().map { (rxPage:RxPage<Activity>) in
            return rxPage.page()
        }.unwrap(completionHandler)
    }

    /// retrieves a feed of activities tageting the current user
    open func retrieveMeFeed(_ completionHandler: @escaping 
        (Page<Activity>?, Error?) -> ()) {
        rxTapglue.retrieveMeFeed().map { (rxPage:RxPage<Activity>) in
            return rxPage.page()
        }.unwrap(completionHandler)
    }

    /// retrieves news feed
    /// - parameter completionHander: where the callbacks will be made
    open func retrieveNewsFeed(_ completionHandler: @escaping (CompositePage<NewsFeed>?, Error?) -> ()) {
        rxTapglue.retrieveNewsFeed().map { (rxPage:RxCompositePage<NewsFeed>) in
            return rxPage.page()
        }.unwrap(completionHandler)
    }
}
