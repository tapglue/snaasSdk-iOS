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
    
    func createComment(comment: Comment) -> Observable<Comment> {
        return http.execute(Router.post("/posts/" + comment.postId! + "/comments", payload: comment.toJSON()))
    }
    

    func retrieveComments(postId: String) -> Observable<[Comment]> {
        return http.execute(Router.get("/posts/" + postId + "/comments")).map { (commentFeed:CommentFeed) in
            return commentFeed.comments ?? [Comment]()
        }
    }
    
    func updateComment(comment: Comment) -> Observable<Comment> {
        return http.execute(Router.put("/posts/" + comment.postId! + "/comments", payload: comment.toJSON()))
    }
    
    func deleteComment(comment: Comment) -> Observable<Void> {
        return http.execute(Router.delete("/posts/" + comment.postId! + "/comments" + comment.id!))
    }
}
