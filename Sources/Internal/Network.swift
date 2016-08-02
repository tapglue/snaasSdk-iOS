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
    
    func updatePost(post: Post) -> Observable<Post> {
        return http.execute(Router.put("/posts/" + post.id!, payload: post.toJSON()))
    }
    
    func deletePost(id: String) -> Observable<Void> {
        return http.execute(Router.delete("/posts/" + id))
    }

    func retrievePostsByUser(userId: String) -> Observable<[Post]> {
        return http.execute(Router.get("/users/" + userId + "/posts")).map { (feed: PostFeed) in
            let posts = feed.posts?.map { post -> Post in
                post.user = feed.users?[post.userId ?? ""]
                return post
            }
            return posts!
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
}
