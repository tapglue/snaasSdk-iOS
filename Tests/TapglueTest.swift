//
//  TapglueTest.swift
//  Tapglue
//
//  Created by John Nilsen on 7/12/16.
//  Copyright © 2016 Tapglue. All rights reserved.
//

import XCTest
import Nimble
@testable import Tapglue

class TapglueTest: XCTestCase {

    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }

    func testLogin() {
        let tapglue = Tapglue(configuration: Configuration())
        tapglue.rxTapglue.network = TestNetwork()
        
        var callbackUser = User()
        tapglue.loginUser("user1", password: "1234") {
            user, error in
            callbackUser = user!
        }
        
        expect(callbackUser.id).toEventually(equal("testUserId"))
    }
}
