//
//  Network.swift
//  Tapglue
//
//  Created by John Nilsen on 7/5/16.
//  Copyright © 2016 Tapglue. All rights reserved.
//

import RxSwift

class Network {
    let http = Http()

    init() {
    }
    
    func loginUser(_ username: String, password:String) -> Observable<User> {
        let payload = ["user_name": username, "password": password]
        return http.execute(Router.post("/me/login", payload: payload as [String : AnyObject]))
            .map { (user:User) in
                Router.sessionToken = user.sessionToken ?? ""
                return user
        }
    }

    func loginUserWithEmail(_ email: String, password: String) -> Observable<User> {
        let payload = ["email": email, "password": password]
        return http.execute(Router.post("/me/login", payload: payload as [String : AnyObject]))
            .map { (user:User) in
                Router.sessionToken = user.sessionToken ?? ""
                return user
        }
    }

    func createUser(_ user: User, inviteConnections: String? = nil) -> Observable<User> {
        var path = "/users"
        if let inviteConnections = inviteConnections {
            path = path.appending("?invite-connections=\(inviteConnections)")
        }
        return http.execute(Router.post(path, payload: user.toJSON() as [String : AnyObject]))
    }

    func refreshCurrentUser() -> Observable<User> {
        return http.execute(Router.get("/me"))
    }

    func updateCurrentUser(_ user: User) -> Observable<User> {
        return http.execute(Router.put("/me", payload: user.toJSON() as [String : AnyObject]))
    }

    func createInvite(_ key: String, _ value: String) -> Observable<Void> {
        let payload = ["key": key, "value": value]
        return http.execute(Router.post("/me/invites", payload: payload as [String : AnyObject]))
    }

    func logout() -> Observable<Void> {
        return http.execute(Router.delete("/me/logout"))
    }

    func deleteCurrentUser() -> Observable<Void> {
        return http.execute(Router.delete("/me"))
    }

    func retrieveUser(_ id: String) -> Observable<User> {
        return http.execute(Router.get("/users/" + id))
    }
    
    func createConnection(_ connection: Connection) -> Observable<Connection> {
        return http.execute(Router.put("/me/connections", payload: connection.toJSON() as [String : AnyObject]))
    }

    func deleteConnection(toUserId userId: String, type: ConnectionType) -> Observable<Void> {
        return http.execute(Router.delete("/me/connections/" + type.rawValue + "/" + userId))
    }

    func createSocialConnections(_ socialConnections: SocialConnections) -> Observable<[User]> {
        return http.execute(Router.post("/me/connections/social", 
            payload: socialConnections.toJSON() as [String : AnyObject])).map { (feed: UserFeed) in
                return feed.users!
            }
    }

    func searchUsers(forSearchTerm term: String) -> Observable<[User]> {
        return http.execute(Router.get("/users/search?q=" +
                term.addingPercentEncoding(
                    withAllowedCharacters: CharacterSet.urlHostAllowed)!)).map { (feed:UserFeed) in
            return feed.users!
        }
    }

    func searchEmails(_ emails: [String]) -> Observable<[User]> {
        let payload = ["emails": emails]
        return http.execute(Router.post("/users/search/emails", payload: payload as [String : AnyObject])).map { (feed:UserFeed) in
            return feed.users!
        }
    }

    func searchSocialIds(_ ids: [String], onPlatform platform: String) ->
        Observable<[User]> {
        let payload = ["ids":ids]
        return http.execute(Router.post("/users/search/" + platform, payload: payload as [String : AnyObject])).map { 
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

    func retrieveFollowersForUserId(_ id: String) -> Observable<[User]> {
        return http.execute(Router.get("/users/" + id + "/followers")).map { (userFeed: UserFeed) in
            return userFeed.users ?? [User]()
        }
    }

    func retrieveFollowingsForUserId(_ id: String) -> Observable<[User]> {
        return http.execute(Router.get("/users/" + id + "/follows")).map { (userFeed:UserFeed) in
            return userFeed.users ?? [User]()
        }
    }

    func retrieveFriends() -> Observable<[User]> {
        return http.execute(Router.get("/me/friends")).map { (feed: UserFeed) in
            return feed.users ?? [User]()
        }
    }

    func retrieveFriendsForUserId(_ id: String) -> Observable<[User]> {
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
    
    func createPost(_ post: Post) -> Observable<Post> {
        return http.execute(Router.post("/posts", payload: post.toJSON() as [String : AnyObject]))
    }
    
    func retrievePost(_ id: String) -> Observable<Post> {
        return http.execute(Router.get("/posts/" + id))
    }
    
    func updatePost(_ id: String, post: Post) -> Observable<Post> {
        return http.execute(Router.put("/posts/" + id, payload: post.toJSON() as [String : AnyObject]))
    }
    
    func deletePost(_ id: String) -> Observable<Void> {
        return http.execute(Router.delete("/posts/" + id))
    }

    func retrievePostsByUser(_ userId: String) -> Observable<[Post]> {
        return http.execute(Router.get("/users/" + userId + "/posts")).map { 
            self.mapUserToPost($0)
        }
    }

    func retrieveAllPosts() -> Observable<[Post]> {
        return http.execute(Router.get("/posts")).map { 
            self.mapUserToPost($0)
        }
    }

    func filterPostsByTags(_ tags: [String]) -> Observable<[Post]> {
        let tagsObject = PostTagFilter(tags: tags)
        let json = "{\"post\":\(tagsObject.toJSONString() ?? "")}"
        let query = json.addingPercentEncoding(
                    withAllowedCharacters: CharacterSet.urlHostAllowed) ?? ""
        return http.execute(Router.get("/posts?where=" + query)).map {
            self.mapUserToPost($0)
        }
    }
    
    func createComment(_ comment: Comment) -> Observable<Comment> {
        return http.execute(Router.post("/posts/" + comment.postId! + "/comments", payload: comment.toJSON() as [String : AnyObject]))
    }
    

    func retrieveComments(_ postId: String) -> Observable<[Comment]> {
        return http.execute(Router.get("/posts/" + postId + "/comments")).map { (commentFeed:CommentFeed) in
            let comments = commentFeed.comments?.map { comment -> Comment in
                comment.user = commentFeed.users?[comment.userId ?? ""]
                return comment
            }
            return comments ?? [Comment]()
        }
    }
    
    func updateComment(_ postId: String, commentId: String, comment: Comment) -> Observable<Comment> {
        return http.execute(Router.put("/posts/" + postId + "/comments/" + commentId, payload: comment.toJSON() as [String : AnyObject]))
    }
    
    func deleteComment(_ postId: String, commentId: String) -> Observable<Void> {
        return http.execute(Router.delete("/posts/" + postId + "/comments/" + commentId))
    }
    
    func createLike(forPostId postId: String) -> Observable<Like> {
        let like = Like(postId: postId)
        return http.execute(Router.post("/posts/" + postId + "/likes", payload: like.toJSON() as [String : AnyObject]))
    }

    func createReaction(_ reaction: Reaction, forPostId postId: String) -> Observable<Void> {
        return http.execute(Router.post("/posts/" + postId + "/reactions/" + reaction.rawValue, payload: [:]))
    }

    func deleteReaction(_ reaction: Reaction, forPostId postId: String) -> Observable<Void> {
        return http.execute(Router.delete("/posts/" + postId + "/reactions/" + reaction.rawValue))
    }
    
    func retrieveLikes(_ postId: String) -> Observable<[Like]> {
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

    func retrieveLikesByUser(_ userId: String) -> Observable<[Like]> {
        return http.execute(Router.get("/users/" + userId + "/likes")).map {(likeFeed: LikeFeed) in
            let likes = likeFeed.likes?.map { like -> Like in
                like.user = likeFeed.users?[like.userId ?? ""]
                like.post = likeFeed.posts?[like.postId ?? ""]
                return like
            }
            return likes ?? [Like]()
        }
    }

    func retrieveActivitiesByUser(_ userId: String) -> Observable<[Activity]> {
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
            term.addingPercentEncoding(
                withAllowedCharacters: CharacterSet.urlHostAllowed)!)).map { (feed:UserFeed) in
                        return feed.rxPage()
                    }
    }

    func searchEmails(_ emails: [String]) -> Observable<RxPage<User>> {
        let payload = ["emails": emails]
        return http.execute(Router.post("/users/search/emails", payload: payload as [String : AnyObject])).map { (feed:UserFeed) in
            return feed.rxPage()
        }
    }

    func searchSocialIds(_ ids: [String], onPlatform platform: String) ->
        Observable<RxPage<User>> {
        let payload = ["ids":ids]
        return http.execute(Router.post("/users/search/" + platform, payload: payload as [String : AnyObject])).map { 
            (feed: UserFeed) in
            return feed.rxPage()
        }
    }

    func createSocialConnections(_ socialConnections: SocialConnections) -> Observable<RxPage<User>>{
        return http.execute(Router.post("/me/connections/social", 
            payload: socialConnections.toJSON() as [String : AnyObject])).map { (feed: UserFeed) in
                return feed.rxPage(socialConnections.toJSON() as [String : AnyObject])
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

    func retrieveFollowersForUserId(_ id: String) -> Observable<RxPage<User>> {
        return http.execute(Router.get("/users/" + id + "/followers")).map { (feed:UserFeed) in
            return feed.rxPage()
        }
    }

    func retrieveFollowingsForUserId(_ id: String) -> Observable<RxPage<User>> {
        return http.execute(Router.get("/users/" + id + "/follows")).map { (feed: UserFeed) in
            return feed.rxPage()
        }
    }

    func retrieveFriends() -> Observable<RxPage<User>> {
        return http.execute(Router.get("/me/friends")).map { (feed: UserFeed) in
            return feed.rxPage()
        }
    }

    func retrieveFriendsForUserId(_ id: String) -> Observable<RxPage<User>> {
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

    func retrievePostsByUser(_ userId: String) -> Observable<RxPage<Post>> {
        return http.execute(Router.get("/users/" + userId + "/posts")).map { (feed:PostFeed) in
            return feed.rxPage()
        }
    }

    func retrieveAllPosts() -> Observable<RxPage<Post>> {
        return http.execute(Router.get("/posts")).map { (feed:PostFeed) in
            return feed.rxPage()
        }
    }

    func filterPostsByTags(_ tags: [String]) -> Observable<RxPage<Post>> {
        let tagsObject = PostTagFilter(tags: tags)
        let json = "{\"post\":\(tagsObject.toJSONString() ?? "")}"
        let query = json.addingPercentEncoding(
            withAllowedCharacters: CharacterSet.urlHostAllowed) ?? ""
        return http.execute(Router.get("/posts?where=" + query)).map { (feed:PostFeed) in
            return feed.rxPage()
        }
    }

    func retrieveComments(_ postId: String) -> Observable<RxPage<Comment>> {
        return http.execute(Router.get("/posts/" + postId + "/comments")).map { (feed:CommentFeed) in
            return feed.rxPage()
        }
    }
    
    func retrieveLikes(_ postId: String) -> Observable<RxPage<Like>> {
        return http.execute(Router.get("/posts/" + postId + "/likes")).map { (feed:LikeFeed) in
            return feed.rxPage()
        }
    }

    func retrieveLikesByUser(_ userId: String) -> Observable<RxPage<Like>> {
        return http.execute(Router.get("/users/" + userId + "/likes")).map {(feed: LikeFeed) in
            return feed.rxPage()
        }
    }

    func retrieveActivitiesByUser(_ userId: String) -> Observable<RxPage<Activity>> {
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

    func updateCount(_ newCount: Int, _ nameSpace: String) -> Observable<Void> {
        let payload = ["value": newCount] as [String: AnyObject]
        return http.execute(Router.put("/me/counters/" + 
            nameSpace.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlHostAllowed)!, payload: payload))
    }

    func getCount(_ nameSpace: String) -> Observable<Count> {
        return http.execute(Router.get("/counters/" + 
            nameSpace.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlHostAllowed)!))
    }

    fileprivate func retrieveActivitiesOn(_ path: String) -> Observable<[Activity]> {
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

    fileprivate func retrieveActivitiesOn(_ path: String) -> Observable<RxPage<Activity>> {
        return http.execute(Router.get(path)).map { (feed: ActivityFeed) in
            return feed.rxPage()
        }
    }
    
    fileprivate func convertToConnections(_ feed: ConnectionsFeed) -> Connections {
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

    fileprivate func mapUserToPost(_ feed: PostFeed) -> [Post] {
        let posts = feed.posts?.map { post -> Post in
            post.user = feed.users?[post.userId ?? ""]
            return post
        }
        return posts!
    }
}
