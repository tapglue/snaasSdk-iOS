//
//  Network.swift
//  Tapglue
//
//  Created by John Nilsen on 7/5/16.
//  Copyright © 2016 Tapglue. All rights reserved.
//

import Alamofire
import RxSwift

class Network {
    static var analyticsSent = false
    let http = Http()

    init() {
        if !Network.analyticsSent {
            Network.analyticsSent = true
            http.execute(Router.post("/analytics", payload: [:])).subscribeError({ error in
                Network.analyticsSent = false
            }).addDisposableTo(DisposeBag())
        }
    }
    
    func loginUser(username: String, password:String) -> Observable<User> {
        let payload = ["user_name": username, "password": password]
        return http.execute(Router.post("/users/login", payload: payload))
            .map { (user:User) in
                Router.sessionToken = user.sessionToken ?? ""
                return user
        }
    }

    func loginUserWithEmail(email: String, password: String) -> Observable<User> {
        let payload = ["email": email, "password": password]
        return http.execute(Router.post("/users/login", payload: payload))
            .map { (user:User) in
                Router.sessionToken = user.sessionToken ?? ""
                return user
        }
    }

    func createUser(user: User) -> Observable<User> {
        return http.execute(Router.post("/users", payload: user.toJSON()))
    }

    func refreshCurrentUser() -> Observable<User> {
        return http.execute(Router.get("/me"))
    }

    func updateCurrentUser(user: User) -> Observable<User> {
        return http.execute(Router.put("/me", payload: user.toJSON()))
    }

    func logout() -> Observable<Void> {
        return http.execute(Router.delete("/me/logout"))
    }

    func deleteCurrentUser() -> Observable<Void> {
        return http.execute(Router.delete("/me"))
    }

    func retrieveUser(id: String) -> Observable<User> {
        return http.execute(Router.get("/users/" + id))
    }
    
    func createConnection(connection: Connection) -> Observable<Connection> {
        return http.execute(Router.put("/me/connections", payload: connection.toJSON()))
    }

    func deleteConnection(toUserId userId: String, type: ConnectionType) -> Observable<Void> {
        return http.execute(Router.delete("/me/connections/" + type.rawValue + "/" + userId))
    }

    func createSocialConnections(socialConnections: SocialConnections) -> Observable<[User]> {
        return http.execute(Router.post("/me/connections/social", 
            payload: socialConnections.toJSON())).map { (feed: UserFeed) in
                return feed.users!
            }
    }

    func searchUsers(forSearchTerm term: String) -> Observable<[User]> {
        return http.execute(Router.get("/users/search?q=" +
                term.stringByAddingPercentEncodingWithAllowedCharacters(
                    NSCharacterSet.URLHostAllowedCharacterSet())!)).map { (feed:UserFeed) in
            return feed.users!
        }
    }

    func searchEmails(emails: [String]) -> Observable<[User]> {
        let payload = ["emails": emails]
        return http.execute(Router.post("/users/search/emails", payload: payload)).map { (feed:UserFeed) in
            return feed.users!
        }
    }

    func searchSocialIds(ids: [String], onPlatform platform: String) ->
        Observable<[User]> {
        let payload = ["ids":ids]
        return http.execute(Router.post("/users/search/" + platform, payload: payload)).map { 
            (feed: UserFeed) in
            return feed.users!
        }
    }

    func retrieveFollowers() -> Observable<[User]> {
        return http.execute(Router.get("/me/followers")).map { (userFeed:UserFeed) in
            return userFeed.users ?? [User]()
        }
    }

    func retrieveFollowings() -> Observable<[User]> {
        return http.execute(Router.get("/me/follows")).map { (userFeed:UserFeed) in
            return userFeed.users ?? [User]()
        }
    }

    func retrieveFollowersForUserId(id: String) -> Observable<[User]> {
        return http.execute(Router.get("/users/" + id + "/followers")).map { (userFeed: UserFeed) in
            return userFeed.users ?? [User]()
        }
    }

    func retrieveFollowingsForUserId(id: String) -> Observable<[User]> {
        return http.execute(Router.get("/users/" + id + "/follows")).map { (userFeed:UserFeed) in
            return userFeed.users ?? [User]()
        }
    }

    func retrieveFriends() -> Observable<[User]> {
        return http.execute(Router.get("/me/friends")).map { (feed: UserFeed) in
            return feed.users ?? [User]()
        }
    }

    func retrieveFriendsForUserId(id: String) -> Observable<[User]> {
        return http.execute(Router.get("/users/" + id + "/friends")).map { (feed: UserFeed) in
            return feed.users ?? [User]()
        }
    }

    func retrievePendingConnections() -> Observable<Connections> {
        return http.execute(Router.get("/me/connections/pending")).map {
            self.convertToConnections($0)
        }
    }

    func retrieveRejectedConnections() -> Observable<Connections> {
        return http.execute(Router.get("/me/connections/rejected")).map {
            self.convertToConnections($0)
        }
    }
    
    func createPost(post: Post) -> Observable<Post> {
        return http.execute(Router.post("/posts", payload: post.toJSON()))
    }
    
    func retrievePost(id: String) -> Observable<Post> {
        return http.execute(Router.get("/posts/" + id))
    }
    
    func updatePost(id: String, post: Post) -> Observable<Post> {
        return http.execute(Router.put("/posts/" + id, payload: post.toJSON()))
    }
    
    func deletePost(id: String) -> Observable<Void> {
        return http.execute(Router.delete("/posts/" + id))
    }

    func retrievePostsByUser(userId: String) -> Observable<[Post]> {
        return http.execute(Router.get("/users/" + userId + "/posts")).map { 
            self.mapUserToPost($0)
        }
    }

    func retrieveAllPosts() -> Observable<[Post]> {
        return http.execute(Router.get("/posts")).map { 
            self.mapUserToPost($0)
        }
    }

    func filterPostsByTags(tags: [String]) -> Observable<[Post]> {
        let tagsObject = PostTagFilter(tags: tags)
        let json = "{\"post\":\(tagsObject.toJSONString() ?? "")}"
        let query = json.stringByAddingPercentEncodingWithAllowedCharacters(
                    NSCharacterSet.URLHostAllowedCharacterSet()) ?? ""
        return http.execute(Router.get("/posts?where=" + query)).map {
            self.mapUserToPost($0)
        }
    }
    
    func createComment(comment: Comment) -> Observable<Comment> {
        return http.execute(Router.post("/posts/" + comment.postId! + "/comments", payload: comment.toJSON()))
    }
    

    func retrieveComments(postId: String) -> Observable<[Comment]> {
        return http.execute(Router.get("/posts/" + postId + "/comments")).map { (commentFeed:CommentFeed) in
            let comments = commentFeed.comments?.map { comment -> Comment in
                comment.user = commentFeed.users?[comment.userId ?? ""]
                return comment
            }
            return comments ?? [Comment]()
        }
    }
    
    func updateComment(postId: String, commentId: String, comment: Comment) -> Observable<Comment> {
        return http.execute(Router.put("/posts/" + postId + "/comments/" + commentId, payload: comment.toJSON()))
    }
    
    func deleteComment(postId: String, commentId: String) -> Observable<Void> {
        return http.execute(Router.delete("/posts/" + postId + "/comments/" + commentId))
    }
    
    func createLike(forPostId postId: String) -> Observable<Like> {
        let like = Like(postId: postId)
        return http.execute(Router.post("/posts/" + postId + "/likes", payload: like.toJSON()))
    }
    
    func retrieveLikes(postId: String) -> Observable<[Like]> {
        return http.execute(Router.get("/posts/" + postId + "/likes")).map { (likeFeed:LikeFeed) in
            let likes = likeFeed.likes?.map { like -> Like in
                like.user = likeFeed.users?[like.userId ?? ""]
                return like
            }
            return likes ?? [Like]()
        }
    }
    
    func deleteLike(forPostId postId: String) -> Observable<Void> {
        return http.execute(Router.delete("/posts/" + postId + "/likes"))
    }

    func retrieveLikesByUser(userId: String) -> Observable<[Like]> {
        return http.execute(Router.get("/users/" + userId + "/likes")).map {(likeFeed: LikeFeed) in
            let likes = likeFeed.likes?.map { like -> Like in
                like.user = likeFeed.users?[like.userId ?? ""]
                like.post = likeFeed.posts?[like.postId ?? ""]
                return like
            }
            return likes ?? [Like]()
        }
    }

    func retrieveActivitiesByUser(userId: String) -> Observable<[Activity]> {
        return retrieveActivitiesOn("/users/" + userId + "/events")
    }

    func retrievePostFeed() -> Observable<[Post]> {
        return http.execute(Router.get("/me/feed/posts")).map {
            self.mapUserToPost($0)
        }
    }

    func retrieveActivityFeed() -> Observable<[Activity]> {
        return retrieveActivitiesOn("/me/feed/events")
    }

    func retrieveNewsFeed() -> Observable<NewsFeed> {
        return http.execute(Router.get("/me/feed")).map { (feed: NewsFeedEndpoint) in
            let newsFeed = NewsFeed()
            newsFeed.posts = feed.posts?.map { post -> Post in
                post.user = feed.users?[post.userId ?? ""]
                return post
            }
            newsFeed.activities = feed.activities?.map { activity -> Activity in
                activity.user = feed.users?[activity.userId ?? ""]
                activity.post = feed.postMap?[activity.postId ?? ""]
                activity.post?.user = feed.users?[activity.post?.userId ?? ""]
                if activity.target?.type == "tg_user" {
                    activity.targetUser = feed.users?[activity.target!.id ?? ""]
                }
                return activity
            }
            return newsFeed
        }
    }

    func retrieveMeFeed() -> Observable<[Activity]> {
        return retrieveActivitiesOn("/me/feed/notifications/self")
    }

    func searchUsers(forSearchTerm term: String) -> Observable<RxPage<User>> {
        return http.execute(Router.get("/users/search?q=" +
                term.stringByAddingPercentEncodingWithAllowedCharacters(
                    NSCharacterSet.URLHostAllowedCharacterSet())!)).map { (feed:UserFeed) in
                        return feed.rxPage()
                    }
    }

    func searchEmails(emails: [String]) -> Observable<RxPage<User>> {
        let payload = ["emails": emails]
        return http.execute(Router.post("/users/search/emails", payload: payload)).map { (feed:UserFeed) in
            return feed.rxPage()
        }
    }

    func searchSocialIds(ids: [String], onPlatform platform: String) ->
        Observable<RxPage<User>> {
        let payload = ["ids":ids]
        return http.execute(Router.post("/users/search/" + platform, payload: payload)).map { 
            (feed: UserFeed) in
            return feed.rxPage()
        }
    }

    func createSocialConnections(socialConnections: SocialConnections) -> Observable<RxPage<User>>{
        return http.execute(Router.post("/me/connections/social", 
            payload: socialConnections.toJSON())).map { (feed: UserFeed) in
                return feed.rxPage(socialConnections.toJSON())
            }
    }
    
    func retrieveFollowers() -> Observable<RxPage<User>> {
        return http.execute(Router.get("/me/followers")).map { (feed:UserFeed) in
            return feed.rxPage()
        }
    }

    func retrieveFollowings() -> Observable<RxPage<User>> {
        return http.execute(Router.get("/me/follows")).map { (feed:UserFeed) in
            return feed.rxPage()
        }
    }

    func retrieveFollowersForUserId(id: String) -> Observable<RxPage<User>> {
        return http.execute(Router.get("/users/" + id + "/followers")).map { (feed:UserFeed) in
            return feed.rxPage()
        }
    }

    func retrieveFollowingsForUserId(id: String) -> Observable<RxPage<User>> {
        return http.execute(Router.get("/users/" + id + "/follows")).map { (feed: UserFeed) in
            return feed.rxPage()
        }
    }

    func retrieveFriends() -> Observable<RxPage<User>> {
        return http.execute(Router.get("/me/friends")).map { (feed: UserFeed) in
            return feed.rxPage()
        }
    }

    func retrieveFriendsForUserId(id: String) -> Observable<RxPage<User>> {
        return http.execute(Router.get("/users/" + id + "/friends")).map { (feed: UserFeed) in
            return feed.rxPage()
        }
    }

    func retrievePendingConnections() -> Observable<RxCompositePage<Connections>> {
        return http.execute(Router.get("/me/connections/pending")).map { (feed:ConnectionsFeed) in
            return feed.rxPage()
        }
    }

    func retrieveRejectedConnections() -> Observable<RxCompositePage<Connections>> {
        return http.execute(Router.get("/me/connections/rejected")).map { (feed:ConnectionsFeed) in
            return feed.rxPage()
        }
    }

    func retrievePostsByUser(userId: String) -> Observable<RxPage<Post>> {
        return http.execute(Router.get("/users/" + userId + "/posts")).map { (feed:PostFeed) in
            return feed.rxPage()
        }
    }

    func retrieveAllPosts() -> Observable<RxPage<Post>> {
        return http.execute(Router.get("/posts")).map { (feed:PostFeed) in
            return feed.rxPage()
        }
    }

    func filterPostsByTags(tags: [String]) -> Observable<RxPage<Post>> {
        let tagsObject = PostTagFilter(tags: tags)
        let json = "{\"post\":\(tagsObject.toJSONString() ?? "")}"
        let query = json.stringByAddingPercentEncodingWithAllowedCharacters(
                    NSCharacterSet.URLHostAllowedCharacterSet()) ?? ""
        return http.execute(Router.get("/posts?where=" + query)).map { (feed:PostFeed) in
            return feed.rxPage()
        }
    }

    func retrieveComments(postId: String) -> Observable<RxPage<Comment>> {
        return http.execute(Router.get("/posts/" + postId + "/comments")).map { (feed:CommentFeed) in
            return feed.rxPage()
        }
    }
    
    func retrieveLikes(postId: String) -> Observable<RxPage<Like>> {
        return http.execute(Router.get("/posts/" + postId + "/likes")).map { (feed:LikeFeed) in
            return feed.rxPage()
        }
    }

    func retrieveLikesByUser(userId: String) -> Observable<RxPage<Like>> {
        return http.execute(Router.get("/users/" + userId + "/likes")).map {(feed: LikeFeed) in
            return feed.rxPage()
        }
    }

    func retrieveActivitiesByUser(userId: String) -> Observable<RxPage<Activity>> {
        return retrieveActivitiesOn("/users/" + userId + "/events")
    }

    func retrievePostFeed() -> Observable<RxPage<Post>> {
        return http.execute(Router.get("/me/feed/posts")).map { (feed:PostFeed) in
            return feed.rxPage()
        }
    }

    func retrieveActivityFeed() -> Observable<RxPage<Activity>> {
        return retrieveActivitiesOn("/me/feed/events")
    }

    func retrieveMeFeed() -> Observable<RxPage<Activity>> {
        return retrieveActivitiesOn("/me/feed/notifications/self")
    }

    func retrieveNewsFeed() -> Observable<RxCompositePage<NewsFeed>> {
        return http.execute(Router.get("/me/feed")).map { (feed: NewsFeedEndpoint) in
            return feed.rxPage()
        }
    }

    private func retrieveActivitiesOn(path: String) -> Observable<[Activity]> {
        return http.execute(Router.get(path)).map { (feed: ActivityFeed) in
            let activities = feed.activities?.map {activity -> Activity in
                activity.user = feed.users?[activity.userId ?? ""]
                activity.post = feed.posts?[activity.postId ?? ""]
                activity.post?.user = feed.users?[activity.post?.userId ?? ""]
                if activity.target?.type == "tg_user" {
                    activity.targetUser = feed.users?[activity.target!.id ?? ""]
                }
                return activity
            }
            return activities!
        }
    }

    private func retrieveActivitiesOn(path: String) -> Observable<RxPage<Activity>> {
        return http.execute(Router.get(path)).map { (feed: ActivityFeed) in
            return feed.rxPage()
        }
    }
    
    private func convertToConnections(feed: ConnectionsFeed) -> Connections {
        let connections = Connections()
        connections.incoming = feed.incoming?.map { connection -> Connection in
            connection.userFrom = feed.users?.filter { user -> Bool in
                user.id == connection.userFromId
                }.first
            return connection
        }
        connections.outgoing = feed.outgoing?.map { connection -> Connection in
            connection.userTo = feed.users?.filter { user -> Bool in
                user.id == connection.userToId
                }.first
            return connection
        }
        return connections
    }

    private func mapUserToPost(feed: PostFeed) -> [Post] {
        let posts = feed.posts?.map { post -> Post in
            post.user = feed.users?[post.userId ?? ""]
            return post
        }
        return posts!
    }
}
