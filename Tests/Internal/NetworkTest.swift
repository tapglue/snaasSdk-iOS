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

    let postId = "postIdString"
    let sampleUser = ["user_name":"user1","id_string":"someId213","password":"1234", "session_token":"someToken"]
    var samplePost: [String:AnyObject]!
    var sampleUserFeed = [String: AnyObject]()
    var network: Network!

    var analyticsSent = false
    
    override func setUp() {
        super.setUp()
        stub(http(.POST, uri: "/0.4/analytics"), builder: analyticsBuilder)
        Network.analyticsSent = false

        network = Network()
        sampleUserFeed["users"] = [sampleUser]
        samplePost = ["visibility": 20, "attachments": [], "id_string": "postIdString"]
    }
    
    override func tearDown() {
        super.tearDown()
    }

    func analyticsBuilder(request: NSURLRequest) -> Response {
        analyticsSent = true
        let response = NSHTTPURLResponse(URL: request.URL!, statusCode: 200, HTTPVersion: nil, headerFields: nil)!
        return .Success(response, nil)
    }

    func testAnalyticsSentOnInstantiation() {
        expect(self.analyticsSent).toEventually(beTrue())
    }
    
    func testLogin() {
        stub(http(.POST, uri: "/0.4/users/login"), builder: json(sampleUser))
        
        var networkUser = User()
        _ = network.loginUser("user2", password: "1234").subscribeNext { user in
            networkUser = user
        }
        
        expect(networkUser.username).toEventually(equal("user1"))
    }
    
    func testLoginSetsSessionTokenToRouter() {
        stub(http(.POST, uri: "/0.4/users/login"), builder: json(sampleUser))
        
        _ = network.loginUser("user2", password: "1234").subscribe()
        
        expect(Router.sessionToken).toEventually(equal("someToken"))
    }
    
    func testRefreshCurrentUser() {
        stub(http(.GET, uri: "/0.4/me"), builder: json(sampleUser))
        
        var networkUser = User()
        _ = network.refreshCurrentUser().subscribeNext({ user in
            networkUser = user
        })
        
        expect(networkUser.username).toEventually(equal("user1"))
    }

    func testRetrieveFollowersReturnsEmptyArrayWhenNone() {
        sampleUserFeed["users"] = [User]()
        stub(http(.GET, uri: "/0.4/me/followers"), builder: json(sampleUserFeed))
        var followers: [User]?
        _ = network.retrieveFollowers().subscribeNext { users in
            followers = users
        }

        expect(followers).toNotEventually(beNil())
    }

    func testCreateUser() {
        stub(http(.POST, uri: "/0.4/users"), builder: json(sampleUser))
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
        stub(http(.PUT, uri:"/0.4/me"), builder: json(sampleUser))
        var updatedUser = User();
        _ = network.updateCurrentUser(updatedUser).subscribeNext { user in
            updatedUser = user
        }
        expect(updatedUser.username).toEventually(equal("user1"))
    }

    func testLogout() {
        stub(http(.DELETE, uri:"/0.4/me/logout"), builder: http(204))
        var wasLoggedout = false
        _ = network.logout().subscribeCompleted { _ in
            wasLoggedout = true
        }
        expect(wasLoggedout).toEventually(beTruthy())
    }

    func testDeleteCurrentUser() {
        stub(http(.DELETE, uri:"/0.4/me"), builder: http(204))
        var wasDeleted = false
        _ = network.deleteCurrentUser().subscribeCompleted { _ in
            wasDeleted = true
        }
        expect(wasDeleted).toEventually(beTruthy())
    }

    func testRetrieveUser() {
        stub(http(.GET, uri:"/0.4/users/1234"), builder: json(sampleUser))
        var networkUser = User()
        _ = network.retrieveUser("1234").subscribeNext { user in
            networkUser = user
        }
        expect(networkUser.username).toEventually(equal("user1"))
    }
    
    func testRetrieveFollowers() {
        stub(http(.GET, uri: "/0.4/me/followers"), builder: json(sampleUserFeed))
        var followers = [User]()
        _ = network.retrieveFollowers().subscribeNext { users in
            followers = users
        }
        expect(followers).toNotEventually(contain(sampleUser))
    }

    func testCreatePost() {
        stub(http(.POST, uri: "/0.4/posts"), builder: json(samplePost))
        var networkPost: Post?
        let post = Post(visibility: .Public, attachments: [])
        _ = network.createPost(post).subscribeNext { post in
            networkPost = post
        }
        expect(networkPost?.id).toEventually(equal(postId))
    }

    func testRetrievePost() {
        stub(http(.GET, uri: "/0.4/posts/" + postId), builder: json(samplePost))
        var networkPost: Post?
        _ = network.retrievePost(postId).subscribeNext { post in
            networkPost = post
        }
        expect(networkPost?.id).toEventually(equal(postId))
    }

    func testUpdatePost() {
        stub(http(.PUT, uri: "/0.4/posts/" + postId), builder: json(samplePost))
        var networkPost: Post?
        let post = Post(visibility: .Private, attachments: [])
        post.id = postId
        _ = network.updatePost(post).subscribeNext {post in
            networkPost = post
        }
        expect(networkPost?.id).toEventually(equal(postId))
    }

    func testDeletePost() {
        stub(http(.DELETE, uri: "/0.4/posts/" + postId), builder: http(204))
        var wasDeleted = false
        _ = network.deletePost(postId).subscribeCompleted {
            wasDeleted = true
        }
        expect(wasDeleted).toEventually(beTrue())
    }
}
