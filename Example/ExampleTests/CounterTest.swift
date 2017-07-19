//
//  Counter.swift
//  Example
//
//  Created by John Rikard Nilsen on 2017-07-19.
//  Copyright © 2017 Tapglue. All rights reserved.
//

import Foundation

import XCTest
import Tapglue
import RxSwift
import Nimble
import RxBlocking

class CounterTest: XCTestCase {

    let nameSpace = "random_namespace"

    let username = "CounterTestUser"
    let password = "CounterTestPassword"
    let tapglue = RxTapglue(configuration: Configuration())
    var user = User()

    override func setUp() {
        super.setUp()
        user.username = username
        user.password = password
        do {
            user = try tapglue.createUser(user).toBlocking().first()!
            user = try tapglue.loginUser(username, password: password).toBlocking().first()!
        } catch {
            fail("failed to create and login user for integration tests")
        }
    }

    override func tearDown() {
        do {
            _ = try tapglue.deleteCurrentUser().toBlocking().first()
        } catch {
            fail("failed to delete user for integration tests")
        }
    }

    func testUpdateCount() throws {
        _ = try tapglue.updateCount(newCount: 123, withNameSpace: self.nameSpace).toBlocking().first()
    }

    func testGetCount() throws {
        _ = try tapglue.updateCount(newCount: 123, withNameSpace: self.nameSpace).toBlocking().first()
        let count = try tapglue.getCount(withNameSpace: self.nameSpace).toBlocking().first()!
        expect(count.count).to(beGreaterThan(123))
    }
}
