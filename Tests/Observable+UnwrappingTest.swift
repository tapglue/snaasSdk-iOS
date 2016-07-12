//
//  Observable+Unwrappingtest.swift
//  Tapglue
//
//  Created by John Nilsen on 7/12/16.
//  Copyright © 2016 Tapglue. All rights reserved.
//

import XCTest
import RxSwift
import Nimble
@testable import Tapglue

class Observable_Unwrappingtest: XCTestCase {

    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }

    func testUnwrappingSuccess() {
        let expectedUser = User()
        expectedUser.id = "expectedId"
        var unwrappedUser = User();
        Observable.just(expectedUser).unwrap { (user, error) in
            unwrappedUser = expectedUser
        }
        expect(unwrappedUser.id).toEventually(equal(expectedUser.id))
    }
    
    func testUnwrappingError() {
        var expectedError: ErrorType?
        Observable.error(TestError()).unwrap { (user: User?, error: ErrorType?) in
            expectedError = error
        }
        
        expect(expectedError).toEventuallyNot(beNil())
    }
}

class TestError: ErrorType {
    var code: Int = 25
}
