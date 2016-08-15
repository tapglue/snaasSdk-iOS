//
//  HttpTest.swift
//  Tapglue
//
//  Created by John Nilsen on 7/21/16.
//  Copyright © 2016 Tapglue. All rights reserved.
//

import XCTest
import Mockingjay
import RxSwift
import Nimble
@testable import Tapglue

class HttpTest: XCTestCase {
    
    let uri = "/someuri"
    let errorCode = 120239
    var errorResponse: [String: AnyObject]!

    override func setUp() {
        super.setUp()
        errorResponse = ["errors":[["code": errorCode, "message": "some message"]]]
        stub(http(.GET, uri: "/0.4" + uri), builder: json(errorResponse, status: 400))
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testTapglueErrorCodeCorrectlyParsed() {
        var tapglueError = TapglueError()
        _ = Http().execute(Router.get(uri)).subscribeError { error in
            if error is TapglueError {
                tapglueError = error as! TapglueError
            } else {
                fail("error was of wrong type")
            }
        }
        expect(tapglueError.code).toEventually(equal(errorCode))
    }
    
    func testTapglueErrorCodeCorrectlyParsedOnNonVoidExecute() {
        var tapglueError =  TapglueError()
        let observable: Observable<User> = Http().execute(Router.get(uri))
        
        _ = observable.subscribeError { error in
            tapglueError = error as! TapglueError
        }
        
        expect(tapglueError.code).toEventually(equal(errorCode))
    }
    
    func testTapglueErrorMessageCorrectlyParsed() {
        var tapglueError = TapglueError()
        _ = Http().execute(Router.get(uri)).subscribeError { error in
            tapglueError = error as! TapglueError
        }
        expect(tapglueError.message).toEventually(equal("some message"))
    }
}
