//
//  UserInteractionTest.swift
//  Example
//
//  Created by John Nilsen on 7/12/16.
//  Copyright © 2016 Tapglue. All rights reserved.
//

import XCTest
import Tapglue
import RxSwift
import Nimble
import RxBlocking

class LoginTest: XCTestCase {

    let username = "LoginTestUser1"
    let email = "email@domain.com"
    let password = "LoginTestPassword"
    let tapglue = RxTapglue(configuration: Configuration())
    var user = User()
    
    override func setUp() {
        super.setUp()
        user.username = username
        user.password = password
        user.email = email
        
        do {
            user = try tapglue.createUser(user).toBlocking().first()!
        } catch {
            fail("failed to create user for integration tests")
        }
    }
    
    override func tearDown() {
        super.tearDown()
        do {
            try tapglue.deleteCurrentUser().toBlocking().first()
        } catch {
            fail("failed to delete user for integration tests")
        }
    }

    func testUserLogin() {
        do {
            user = try tapglue.loginUser(username, password: password).toBlocking().first()!
        } catch {
            fail("failed to log in")
        }
    }

    func testUserLoginWithEmail() {
        do {
            user = try tapglue.loginUserWithEmail(email, password: password).toBlocking().first()!
        } catch {
            fail("failed to log in")
        }
    }
}
