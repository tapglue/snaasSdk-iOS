//
//  SearchTest.swift
//  Example
//
//  Created by John Nilsen on 8/1/16.
//  Copyright © 2016 Tapglue. All rights reserved.
//

import XCTest
import Nimble
import Tapglue

class SearchTest: XCTestCase {
    
    let username1 = "SearchTest1"
    let username2 = "SearchTest2"
    let email1 = "email1@domain.com"
    let email2 = "email2@domain.com"
    let socialPlatform = "socialplatform"
    let socialId1 = "searchSocialId1"
    let socialId2 = "searchSocialId2"
    let password = "SearchTestPassword"
    let tapglue = RxTapglue(configuration: Configuration())
    var user1 = User()
    var user2 = User()
    
    override func setUp() {
        super.setUp()
        user1.username = username1
        user1.email = email1
        user1.socialIds = [socialPlatform: socialId1]
        user1.password = password
        
        user2.username = username2
        user2.email = email2
        user2.socialIds = [socialPlatform: socialId2]
        user2.password = password
        
        do {
            user1 = try tapglue.createUser(user1).toBlocking().first()!
            user2 = try tapglue.createUser(user2).toBlocking().first()!
        } catch {
            fail("failed to create and login user for integration tests")
        }
    }
    
    override func tearDown() {
        super.tearDown()
        do {
            try tapglue.loginUser(username1, password: password).toBlocking().first()
            try tapglue.deleteCurrentUser().toBlocking().first()
            
            try tapglue.loginUser(username2, password: password).toBlocking().first()
            try tapglue.deleteCurrentUser().toBlocking().first()
        } catch {
            fail("failed to login and delete user for integration tests")
        }
    }
    
    func testUserSearchWithNoResults() throws {
        user1 = try tapglue.loginUser(username1, password: password).toBlocking().first()!
        var searchResult: [User]?
        _ = tapglue.searchUsersForSearchTerm("someTerm").subscribeNext { users in
            searchResult = users
        }
        expect(searchResult?.count).toEventually(equal(0))
    }
    
    func testUserSearchWithResult() throws {
        user1 = try tapglue.loginUser(username1, password: password).toBlocking().first()!
        var searchResult: [User]?
        _ = tapglue.searchUsersForSearchTerm(username2).subscribeNext { users in
            searchResult = users
        }
        expect(searchResult?.count).toEventually(equal(1))
        expect(searchResult?.first?.username).toEventually(equal(username2))
    }
    
    func testUserSearchWithInvalidPath() throws {
        user1 = try tapglue.loginUser(username1, password: password).toBlocking().first()!
        var searchResult: [User]?
        _ = tapglue.searchUsersForSearchTerm("jasd jkshad").subscribeNext { users in
            searchResult = users
        }
        expect(searchResult?.count).toEventually(equal(0))
    }
    
    func testEmailSearchWithNoResults() throws {
        user1 = try tapglue.loginUser(username1, password: password).toBlocking().first()!
        var searchResult: [User]?
        _ = tapglue.searchEmails(["somerandom@email.com"]).subscribeNext { users in
            searchResult = users
        }
        expect(searchResult?.count).toEventually(equal(0))
    }
    
    func testEmailSearchWithResult() throws {
        user1 = try tapglue.loginUser(username1, password: password).toBlocking().first()!
        var searchResult: [User]?
        _ = tapglue.searchEmails([email2]).subscribeNext { users in
            searchResult = users
        }
        expect(searchResult?.count).toEventually(equal(1))
    }
    
    func testSocialIdSearchWithNoResults() throws {
        user1 = try tapglue.loginUser(username1, password: password).toBlocking().first()!
        var searchResult: [User]?
        _ = tapglue.searchSocialIds(["someRandomSocialId"], onPlatform: socialPlatform).subscribeNext { users in
            searchResult = users
        }
        expect(searchResult?.count).toEventually(equal(0))
    }
    
    func testSocialIdSearchWithResult() throws {
        user1 = try tapglue.loginUser(username1, password: password).toBlocking().first()!
        var searchResult: [User]?
        _ = tapglue.searchSocialIds([socialId2], onPlatform: socialPlatform).subscribeNext { users in
            searchResult = users
        }
        expect(searchResult?.count).toEventually(equal(1))
    }
}
