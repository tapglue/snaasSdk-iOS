//
//  NetworkTest.swift
//  Tapglue
//
//  Created by John Nilsen on 7/6/16.
//  Copyright © 2016 Tapglue. All rights reserved.
//

import XCTest
import Mockingjay
import Nimble
@testable import Tapglue

class NetworkTest: XCTestCase {

    let postId = "postId123"
    let commentId = "commentIdString"
    let likeId = "likeIdString"
    let userId = "someId213"
    let activityId = "activityId"
    var sampleUser: [String: AnyObject]!
    var samplePost: [String:AnyObject]!
    var samplePostFeed: [String:AnyObject]!
    var sampleComment: [String:AnyObject]!
    var sampleLike: [String:AnyObject]!
    var sampleUserFeed = [String: AnyObject]()
    var sampleCommentFeed = [String: AnyObject]()
    var sampleLikeFeed = [String: AnyObject]()
    var sampleConnection: [String:AnyObject]!
    var sampleConnectionsFeed: [String: AnyObject]!
    var sampleActivityFeed: [String: AnyObject]!
    var sampleNewsFeed: [String: AnyObject]!
    var network: Network!

    var analyticsSent = false
    
    override func setUp() {
        super.setUp()
        stub(http(.post, uri: "/0.4/analytics"), builder: analyticsBuilder)
        Network.analyticsSent = false

        network = Network()
        sampleUser = ["user_name":"user1" as AnyObject,"id_string": userId as AnyObject,"password":"1234" as AnyObject, "session_token":"someToken" as AnyObject]
        sampleUserFeed["users"] = [sampleUser]
        samplePost = ["visibility": 20 as AnyObject, "attachments": [], "id": postId, "user_id":userId]
        samplePostFeed = ["posts":[samplePost], "users":[userId:sampleUser]]
        sampleComment = ["contents":["en":"content"], "post_id":postId, "id":commentId, "user_id": userId]
        sampleCommentFeed = ["comments": [sampleComment], "users": [userId: sampleUser]]
        sampleLike = ["post_id":postId as AnyObject, "id":likeId as AnyObject, "user_id": userId as AnyObject]
        sampleLikeFeed = ["likes": [sampleLike], "users": [userId: sampleUser],
            "post_map":[postId: samplePost]]
        sampleConnection = ["user_to_id_string": userId as AnyObject, "user_from_id_string": userId as AnyObject, "type":"follow" as AnyObject, "state":"confirmed" as AnyObject]
        sampleConnectionsFeed = ["incoming": [sampleConnection], "outgoing": [sampleConnection],
            "users":[sampleUser]]
        sampleActivityFeed = ["events":[["id_string":activityId, "user_id_string":userId,
            "post_id": postId]], "users":[userId: sampleUser], "post_map":[postId: samplePost]]
        sampleNewsFeed = sampleActivityFeed
        sampleNewsFeed["posts"] = [samplePost]
    }
    
    override func tearDown() {
        super.tearDown()
    }

    func analyticsBuilder(_ request: URLRequest) -> Response {
        analyticsSent = true
        let response = HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)!
        return .success(response, nil)
    }

    func testAnalyticsSentOnInstantiation() {
        expect(self.analyticsSent).toEventually(beTrue())
    }
    
    func testLogin() {
        stub(http(.post, uri: "/0.4/users/login"), builder: json(sampleUser))
        
        var networkUser = User()
        _ = network.loginUser("user2", password: "1234").subscribeNext { user in
            networkUser = user
        }
        
        expect(networkUser.username).toEventually(equal("user1"))
    }
    
    func testLoginSetsSessionTokenToRouter() {
        stub(http(.post, uri: "/0.4/users/login"), builder: json(sampleUser))
        
        _ = network.loginUser("user2", password: "1234").subscribe()
        
        expect(Router.sessionToken).toEventually(equal("someToken"))
    }

    func testEmailLogin() {
        stub(http(.post, uri: "/0.4/users/login"), builder: json(sampleUser))

        var networkUser: User?
        _ = network.loginUserWithEmail("email@domain.com", password: "1234")
            .subscribeNext { user in
            networkUser = user
        }
        expect(networkUser?.username).toEventually(equal("user1"))
    }
    
    func testEmailLoginSetsSessionTokenToRouter() {
        stub(http(.post, uri: "/0.4/users/login"), builder: json(sampleUser))
        
        _ = network.loginUserWithEmail("email@domain.com", password: "1234").subscribe()
        
        expect(Router.sessionToken).toEventually(equal("someToken"))
    }
    
    func testRefreshCurrentUser() {
        stub(http(.get, uri: "/0.4/me"), builder: json(sampleUser))
        
        var networkUser = User()
        _ = network.refreshCurrentUser().subscribeNext({ user in
            networkUser = user
        })
        
        expect(networkUser.username).toEventually(equal("user1"))
    }

    func testRetrieveFollowersReturnsEmptyArrayWhenNone() {
        sampleUserFeed["users"] = [User]()
        stub(http(.get, uri: "/0.4/me/followers"), builder: json(sampleUserFeed))
        var followers: [User]?
        _ = network.retrieveFollowers().subscribeNext { users in
            followers = users
        }

        expect(followers).toNotEventually(beNil())
    }

    func testCreateUser() {
        stub(http(.post, uri: "/0.4/users"), builder: json(sampleUser))
        let userToBeCreated = User()
        userToBeCreated.username = "someUsername"
        userToBeCreated.password = "1234"

        var createdUser = User()
        _ = network.createUser(userToBeCreated).subscribeNext { user in
            createdUser = user
        }
        expect(createdUser.username).toEventually(equal("user1"))
    }

    func testUpdateCurrentUser() {
        stub(http(.put, uri:"/0.4/me"), builder: json(sampleUser))
        var updatedUser = User();
        _ = network.updateCurrentUser(updatedUser).subscribeNext { user in
            updatedUser = user
        }
        expect(updatedUser.username).toEventually(equal("user1"))
    }

    func testLogout() {
        stub(http(.delete, uri:"/0.4/me/logout"), builder: http(204))
        var wasLoggedout = false
        _ = network.logout().subscribeCompleted { _ in
            wasLoggedout = true
        }
        expect(wasLoggedout).toEventually(beTruthy())
    }

    func testDeleteCurrentUser() {
        stub(http(.delete, uri:"/0.4/me"), builder: http(204))
        var wasDeleted = false
        _ = network.deleteCurrentUser().subscribeCompleted { _ in
            wasDeleted = true
        }
        expect(wasDeleted).toEventually(beTruthy())
    }

    func testRetrieveUser() {
        stub(http(.get, uri:"/0.4/users/1234"), builder: json(sampleUser))
        var networkUser = User()
        _ = network.retrieveUser("1234").subscribeNext { user in
            networkUser = user
        }
        expect(networkUser.username).toEventually(equal("user1"))
    }

    func testSearchUsers() {
        stub(everything, builder: json(sampleUserFeed))
        var searchResult = [User]()
        _ = network.searchUsers(forSearchTerm: "someTerm").subscribeNext { users in
            searchResult = users
        }
        expect(searchResult.count).toEventually(equal(1))
        expect(searchResult.first?.username).toEventually(equal("user1"))
    }

    func testSearchEmail() {
        stub(http(.post, uri: "/0.4/users/search/emails"), builder: json(sampleUserFeed))
        var searchResult = [User]()
        _ = network.searchEmails(["john@doe.com"]).subscribeNext { users in
            searchResult = users
        }
        expect(searchResult.count).toEventually(equal(1))
        expect(searchResult.first?.username).toEventually(equal("user1"))
    }

    func testSearchSocialIds() {
        stub(http(.post, uri: "/0.4/users/search/facebook"), builder: json(sampleUserFeed))
        var searchResult = [User]()
        _ = network.searchSocialIds(["someId"], onPlatform: "facebook").subscribeNext { users in
            searchResult = users
        }
        expect(searchResult.count).toEventually(equal(1))
        expect(searchResult.first?.username).toEventually(equal("user1"))
    }

    func testCreateConnection() {
        stub(http(.put, uri: "/0.4/me/connections"), builder: json(sampleConnection))
        var networkConnection: Connection?
        let connection = Connection(toUserId: "2123", type: .Follow, state: .Confirmed)
        _ = network.createConnection(connection).subscribeNext { connection in
            networkConnection = connection
        }
        expect(networkConnection?.userToId).toEventually(equal(userId))
        expect(networkConnection?.type).toEventually(equal(ConnectionType.Follow))
    }

    func testDeleteConnection() {
        stub(http(.delete, uri: "/0.4/me/connections/follow/"+userId), builder: http(204))
        var wasDeleted = false
        _ = network.deleteConnection(toUserId: userId, type: .Follow).subscribeCompleted {
            wasDeleted = true
        }
        expect(wasDeleted).toEventually(beTrue())
    }

    func testCreateSocialConnections() {
        stub(http(.post, uri: "/0.4/me/connections/social"), builder: json(sampleUserFeed))
        var networkUsers: [User]?
        let connections = SocialConnections(platform:"f", type: .Follow, userSocialId: "s",
            socialIds: ["ids"])
        _ = network.createSocialConnections(connections).subscribeNext { users in
            networkUsers = users
        }
        expect(networkUsers?.count).toEventually(equal(1))
        expect(networkUsers?.first?.username).toEventually(equal("user1"))
    }
    
    func testRetrieveFollowers() {
        stub(http(.get, uri: "/0.4/me/followers"), builder: json(sampleUserFeed))
        var followers = [User]()
        _ = network.retrieveFollowers().subscribeNext { users in
            followers = users
        }
        expect(followers.count).toEventually(equal(1))
        expect(followers.first?.username).toEventually(equal("user1"))
    }

    func testRetrieveFollowings() {
        stub(http(.get, uri: "/0.4/me/follows"), builder: json(sampleUserFeed))
        var followings = [User]()
        _ = network.retrieveFollowings().subscribeNext {users in
            followings = users
        }
        expect(followings.count).toEventually(equal(1))
        expect(followings.first?.username).toEventually(equal("user1"))
    }

    func testRetrieveFollowersForUserId() {
        stub(http(.get, uri: "/0.4/users/" + userId + "/followers"), builder: json(sampleUserFeed))
        var followers = [User]()
        _ = network.retrieveFollowersForUserId(userId).subscribeNext { users in
            followers = users
        }
        expect(followers.count).toEventually(equal(1))
        expect(followers.first?.id).toEventually(equal(userId))
    }

    func testRetrieveFollowingsForUserId() {
        stub(http(.get, uri: "/0.4/users/" + userId + "/follows"),
                    builder: json(sampleUserFeed))
        var followings = [User]()
        _ = network.retrieveFollowingsForUserId(userId).subscribeNext { users in
            followings = users
        }
        expect(followings.count).toEventually(equal(1))
        expect(followings.first?.id).toEventually(equal(userId))
    }

    func testRetrieveFriends() {
        stub(http(.get, uri: "/0.4/me/friends"), builder: json(sampleUserFeed))
        var friends = [User]()
        _ = network.retrieveFriends().subscribeNext { users in
            friends = users
        }
        expect(friends.count).toEventually(equal(1))
        expect(friends.first?.id).toEventually(equal(userId))
    }

    func testRetrieveFriendsForUserId() {
        stub(http(.get, uri: "/0.4/users/"+userId+"/friends"), builder: json(sampleUserFeed))
        var friends = [User]()
        _ = network.retrieveFriendsForUserId(userId).subscribeNext { users in
            friends = users
        }
        expect(friends.count).toEventually(equal(1))
        expect(friends.first?.id).toEventually(equal(userId))
    }

    func testRetrievePendingConnections() {
        stub(http(.get, uri: "/0.4/me/connections/pending"), builder: json(sampleConnectionsFeed))
        var networkConnections: Connections?
        _ = network.retrievePendingConnections().subscribeNext { connections in
            networkConnections =  connections
        }
        expect(networkConnections).toEventuallyNot(beNil())
    }
    
    func testRetrievePendingConnectionsMapsIncomingUser() {
        stub(http(.get, uri: "/0.4/me/connections/pending"), builder: json(sampleConnectionsFeed))
        var networkConnections: Connections?
        _ = network.retrievePendingConnections().subscribeNext { connections in
            networkConnections =  connections
        }
        expect(networkConnections?.incoming?.first?.userFrom).toEventuallyNot(beNil())
    }
    
    func testRetrievePendingConnectionsMapsOutgoingUser() {
        stub(http(.get, uri: "/0.4/me/connections/pending"), builder: json(sampleConnectionsFeed))
        var networkConnections: Connections?
        _ = network.retrievePendingConnections().subscribeNext { connections in
            networkConnections =  connections
        }
        expect(networkConnections?.outgoing?.first?.userTo).toEventuallyNot(beNil())
    }

    func testRetrieveRejectedConnections() {
        stub(http(.get, uri: "/0.4/me/connections/rejected"), builder: json(sampleConnectionsFeed))
        var networkConnections: Connections?
        _ = network.retrieveRejectedConnections().subscribeNext { connections in
            networkConnections =  connections
        }
        expect(networkConnections).toEventuallyNot(beNil())
    }
    
    func testRetrieveRejectedConnectionsMapsIncomingUser() {
        stub(http(.get, uri: "/0.4/me/connections/rejected"), builder: json(sampleConnectionsFeed))
        var networkConnections: Connections?
        _ = network.retrieveRejectedConnections().subscribeNext { connections in
            networkConnections =  connections
        }
        expect(networkConnections?.incoming?.first?.userFrom).toEventuallyNot(beNil())
    }
    
    func testRetrieveRejectedConnectionsMapsOutgoingUser() {
        stub(http(.get, uri: "/0.4/me/connections/rejected"), builder: json(sampleConnectionsFeed))
        var networkConnections: Connections?
        _ = network.retrieveRejectedConnections().subscribeNext { connections in
            networkConnections =  connections
        }
        expect(networkConnections?.outgoing?.first?.userTo).toEventuallyNot(beNil())
    }

    func testCreatePost() {
        stub(http(.post, uri: "/0.4/posts"), builder: json(samplePost))
        var networkPost: Post?
        let post = Post(visibility: .public, attachments: [])
        _ = network.createPost(post).subscribeNext { post in
            networkPost = post
        }
        expect(networkPost?.id).toEventually(equal(postId))
    }

    func testRetrievePost() {
        stub(http(.get, uri: "/0.4/posts/" + postId), builder: json(samplePost))
        var networkPost: Post?
        _ = network.retrievePost(postId).subscribeNext { post in
            networkPost = post
        }
        expect(networkPost?.id).toEventually(equal(postId))
    }

    func testUpdatePost() {
        stub(http(.put, uri: "/0.4/posts/" + postId), builder: json(samplePost))
        var networkPost: Post?
        let post = Post(visibility: .private, attachments: [])
        post.id = postId
        _ = network.updatePost(postId, post: post).subscribeNext {post in
            networkPost = post
        }
        expect(networkPost?.id).toEventually(equal(postId))
    }

    func testDeletePost() {
        stub(http(.delete, uri: "/0.4/posts/" + postId), builder: http(204))
        var wasDeleted = false
        _ = network.deletePost(postId).subscribeCompleted {
            wasDeleted = true
        }
        expect(wasDeleted).toEventually(beTrue())
    }

    func testRetrievePostsByUser() {
        stub(http(.get, uri: "/0.4/users/someId/posts"), builder: json(samplePostFeed))
        var networkPosts: [Post]?
        _ = network.retrievePostsByUser("someId").subscribeNext { posts in
            networkPosts = posts
        }
        expect(networkPosts).toEventuallyNot(beNil())
        expect(networkPosts?.first?.id).toEventually(equal(postId))
    }

    func testRetrievePostsByUserMapsUserToPost() {
        stub(http(.get, uri: "/0.4/users/someId/posts"), builder: json(samplePostFeed))
        var networkPosts: [Post]?
        _ = network.retrievePostsByUser("someId").subscribeNext { posts in
            networkPosts = posts
        }
        expect(networkPosts?.first?.user?.id).toEventually(equal(userId))
    }
    
    func testRetrieveAllPosts() {
        stub(http(.get, uri: "/0.4/posts"), builder: json(samplePostFeed))
        var networkPosts: [Post]?
        _ = network.retrieveAllPosts().subscribeNext { posts in
            networkPosts = posts
        }
        expect(networkPosts?.first?.id).toEventually(equal(postId))
    }

    func testRetrieveAllPostsMapsUsersToPosts() {
        stub(http(.get, uri: "/0.4/posts"), builder: json(samplePostFeed))
        var networkPosts: [Post]?
        _ = network.retrieveAllPosts().subscribeNext { posts in
            networkPosts = posts
        }
        expect(networkPosts?.first?.user?.id).toEventually(equal(userId))
    }

    func testFilterPostsByTags() {
        stub(everything, builder: json(samplePostFeed))
        var networkPosts: [Post]?
        _ = network.filterPostsByTags(["someTag"]).subscribeNext { posts in
            networkPosts = posts
        }
        expect(networkPosts?.first?.id).toEventually(equal(postId))
    }

    func testCreateComment() {
        stub(http(.post, uri: "/0.4/posts/" + postId + "/comments"), builder: json(sampleComment))
        var networkComment: Comment?
        let comment = Comment(contents: ["en":"content"], postId: postId)
        _ = network.createComment(comment).subscribeNext { comment in
            networkComment = comment
        }
        expect(networkComment?.id).toEventually(equal(commentId))
    }
    
    func testRetrieveComments() {
        stub(http(.get, uri: "/0.4/posts/" + postId + "/comments"), builder: json(sampleCommentFeed))
        var postComments = [Comment]()
        _ = network.retrieveComments(postId).subscribeNext { comments in
            postComments = comments
        }
        expect(postComments.count).toEventually(equal(1))
        expect(postComments.first?.id).toEventually(equal(commentId))
    }
    
    func testRetrieveCommentsMapsUsers() {
        stub(http(.get, uri: "/0.4/posts/" + postId + "/comments"), builder: json(sampleCommentFeed))
        var postComments = [Comment]()
        _ = network.retrieveComments(postId).subscribeNext { comments in
            postComments = comments
        }
        expect(postComments.first?.user).toEventuallyNot(beNil())
        expect(postComments.first?.user?.id).toEventually(equal(userId))
    }
    
    func testUpdateComment() {
        stub(http(.put, uri: "/0.4/posts/" + postId + "/comments/" + commentId), builder: json(sampleComment))
        var networkComment: Comment?
        let comment = Comment(contents: ["en":"content"], postId: postId)
        comment.id = commentId
        _ = network.updateComment(postId, commentId: commentId, comment: comment).subscribeNext {comment in
            networkComment = comment
        }
        expect(networkComment?.id).toEventually(equal(commentId))
    }
    
    func testDeleteComment() {
        stub(http(.delete, uri: "/0.4/posts/" + postId + "/comments/" + commentId), builder: http(204))
        var wasDeleted = false
        _ = network.deleteComment(postId, commentId: commentId).subscribeCompleted {
            wasDeleted = true
        }
        expect(wasDeleted).toEventually(beTrue())
    }
    
    func testCreateLike() {
        stub(http(.post, uri: "/0.4/posts/" + postId + "/likes"), builder: json(sampleLike))
        var networkLike: Like?
        _ = network.createLike(forPostId: postId).subscribeNext { like in
            networkLike = like
        }
        expect(networkLike?.id).toEventually(equal(likeId))
    }
    
    func testRetrievelikes() {
        stub(http(.get, uri: "/0.4/posts/" + postId + "/likes"), builder: json(sampleLikeFeed))
        var postLikes = [Like]()
        _ = network.retrieveLikes(postId).subscribeNext { likes in
            postLikes = likes
        }
        expect(postLikes.count).toEventually(equal(1))
        expect(postLikes.first?.id).toEventually(equal(likeId))
    }
    
    func testRetrievelikesMapsUsers() {
        stub(http(.get, uri: "/0.4/posts/" + postId + "/likes"), builder: json(sampleLikeFeed))
        var postLikes = [Like]()
        _ = network.retrieveLikes(postId).subscribeNext { likes in
            postLikes = likes
        }
        expect(postLikes.first?.user).toEventuallyNot(beNil())
        expect(postLikes.first?.user?.id).toEventually(equal(userId))
    }
    
    func testDeleteLike() {
        stub(http(.delete, uri: "/0.4/posts/" + postId + "/likes"), builder: http(204))
        var wasDeleted = false
        _ = network.deleteLike(forPostId: postId).subscribeCompleted {
            wasDeleted = true
        }
        expect(wasDeleted).toEventually(beTrue())
    }

    func testRetrieveLikesByUser() {
        stub(http(.get, uri: "/0.4/users/123/likes"), builder: json(sampleLikeFeed))
        var networkLikes: [Like]?
        _ = network.retrieveLikesByUser("123").subscribeNext { likes in
            networkLikes = likes
        }
        expect(networkLikes?.count).toEventually(equal(1))
    }

    func testRetrieveLikesByUserMapsUsers() {
        stub(http(.get, uri: "/0.4/users/123/likes"), builder: json(sampleLikeFeed))
        var networkLikes: [Like]?
        _ = network.retrieveLikesByUser("123").subscribeNext { likes in
            networkLikes = likes
        }
        expect(networkLikes?.first?.user?.id).toEventually(equal(userId))
    }

    func testRetrieveLikesByUserMapsPosts() {
        stub(http(.get, uri: "/0.4/users/123/likes"), builder: json(sampleLikeFeed))
        var networkLikes: [Like]?
        _ = network.retrieveLikesByUser("123").subscribeNext { likes in
            networkLikes = likes
        }
        expect(networkLikes?.first?.post?.id).toEventually(equal(postId))
    }

    func testRetrieveActivitiesByUser() {
        stub(http(.get, uri: "/0.4/users/123/events"), builder: json(sampleActivityFeed))
        var networkActivities: [Activity]?
        _ = network.retrieveActivitiesByUser("123").subscribeNext { activities in
            networkActivities = activities
        }
        expect(networkActivities?.first?.id).toEventually(equal(activityId))
    }

    func testRetrieveActivitiesByUserMapsUsersToActivities() {
        stub(http(.get, uri: "/0.4/users/123/events"), builder: json(sampleActivityFeed))
        var networkActivities: [Activity]?
        _ = network.retrieveActivitiesByUser("123").subscribeNext { activities in
            networkActivities = activities
        }
        expect(networkActivities?.first?.user?.id).toEventually(equal(userId))
    }

    func testRetrievePostFeed() {
        stub(http(.get, uri: "/0.4/me/feed/posts"), builder: json(samplePostFeed))
        var networkPosts: [Post]?
        _ = network.retrievePostFeed().subscribeNext { posts in
            networkPosts = posts
        }
        expect(networkPosts?.first?.id).toEventually(equal(postId))
    }

    func testRetrieveActivityFeed() {
        stub(http(.get, uri: "/0.4/me/feed/events"), builder: json(sampleActivityFeed))
        var networkActivities: [Activity]?
        _ = network.retrieveActivityFeed().subscribeNext { activities in
            networkActivities = activities
        }
        expect(networkActivities?.first?.id).toEventually(equal(activityId))
    }
    
    func testRetrieveActivityFeedMapsUsersToEvents() {
        stub(http(.get, uri: "/0.4/me/feed/events"), builder: json(sampleActivityFeed))
        var networkActivities: [Activity]?
        _ = network.retrieveActivityFeed().subscribeNext { activities in
            networkActivities = activities
        }
        expect(networkActivities?.first?.user?.id).toEventually(equal(userId))
    }

    func testRetrieveActivityFeedMapsPostsToEvents() {
        stub(http(.get, uri: "/0.4/me/feed/events"), builder: json(sampleActivityFeed))
        var networkActivities: [Activity]?
        _ = network.retrieveActivityFeed().subscribeNext { activities in
            networkActivities = activities
        }
        expect(networkActivities?.first?.post?.id).toEventually(equal(postId))
    }

    func testRetrieveNewsFeed() {
        stub(http(.get, uri: "/0.4/me/feed"), builder: json(sampleNewsFeed))
        var networkFeed: NewsFeed?
        _ = network.retrieveNewsFeed().subscribeNext { feed in
            networkFeed = feed
        }
        expect(networkFeed).toEventuallyNot(beNil())
    }

    func testRetrieveNewsFeedFetchesPosts() {
        stub(http(.get, uri: "/0.4/me/feed"), builder: json(sampleNewsFeed))
        var networkFeed: NewsFeed?
        _ = network.retrieveNewsFeed().subscribeNext { feed in
            networkFeed = feed
        }
        expect(networkFeed?.posts?.first?.id).toEventually(equal(postId))
    }
    
    func testRetrieveNewsFeedFetchesActivities() {
        stub(http(.get, uri: "/0.4/me/feed"), builder: json(sampleNewsFeed))
        var networkFeed: NewsFeed?
        _ = network.retrieveNewsFeed().subscribeNext { feed in
            networkFeed = feed
        }
        expect(networkFeed?.activities?.first?.id).toEventually(equal(activityId))
    }

    func testRetrieveNewsFeedMapsPostsToEvents() {
        stub(http(.get, uri: "/0.4/me/feed"), builder: json(sampleNewsFeed))
        var newsFeed: NewsFeed?
        _ = network.retrieveNewsFeed().subscribeNext { feed in
            newsFeed = feed
        }
        expect(newsFeed?.activities?.first?.post?.id).toEventually(equal(postId))
    }

    func testRetrieveMeFeed() {
        stub(http(.get, uri: "/0.4/me/feed/notifications/self"), builder: json(sampleActivityFeed))
        var networkActivities: [Activity]?
        _ = network.retrieveMeFeed().subscribeNext { activities in
            networkActivities = activities
        }
        expect(networkActivities?.first?.id).toEventually(equal(activityId))
    }
    
    func testRetrieveMeFeedMapsUsersToEvents() {
        stub(http(.get, uri: "/0.4/me/feed/notifications/self"), builder: json(sampleActivityFeed))
        var networkActivities: [Activity]?
        _ = network.retrieveMeFeed().subscribeNext { activities in
            networkActivities = activities
        }
        expect(networkActivities?.first?.user?.id).toEventually(equal(userId))
    }

    func testRetrieveMeFeedMapsPostsToEvents() {
        stub(http(.get, uri: "/0.4/me/feed/notifications/self"), builder: json(sampleActivityFeed))
        var networkActivities: [Activity]?
        _ = network.retrieveMeFeed().subscribeNext { activities in
            networkActivities = activities
        }
        expect(networkActivities?.first?.post?.id).toEventually(equal(postId))
    }
}
