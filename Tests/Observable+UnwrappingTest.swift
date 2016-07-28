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
        Observable.just(expectedUser).unwrap { (user: User?, error) in
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
    
    func testUnwrappingEmptyObservable() {
        let obs: Observable<Void> = Observable.empty()
        var wasSuccessful = false
        obs.unwrap { (success: Bool, error) in
            wasSuccessful = success
        }
        expect(wasSuccessful).toEventually(beTrue())
    }
    
    func testUnwrappingEmptyErrorObservable() {
        let obs: Observable<Void> = Observable.error(TestError())
        var wasSuccessful = true
        var expectedError: ErrorType?
        obs.unwrap { (success: Bool, error) in
            wasSuccessful = success
            expectedError = error
        }
        expect(wasSuccessful).toEventually(beFalse())
        expect(expectedError).toEventuallyNot(beNil())
    }
}

class TestError: ErrorType {
    var code: Int = 25
}
