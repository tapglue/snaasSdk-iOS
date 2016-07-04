//
//  RouterTest.swift
//  Tapglue
//
//  Created by John Nilsen on 7/4/16.
//  Copyright © 2016 Tapglue. All rights reserved.
//

import XCTest
@testable import Tapglue

class RouterTest: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testRouterPostCreatesRequestWithMethod() {
        let request = Router.post("/login", payload: ["user_name":"paco"])
        XCTAssertEqual(request.HTTPMethod, "POST")
    }
    
    func testRouterPostCreatesRequestWithPath() {
        let request = Router.post("/login", payload: ["a":"b"])
        XCTAssertEqual(request.URLString, "https://api.tapglue.com/login")
    }
    
    func testRouterPostCreatesRequestWithPayload() {
        let payload = ["user_name":"paco", "password":"1234"]
        let request = Router.post("/login", payload: payload)
        if request.HTTPBody == nil {
            XCTFail("http body was nil!")
            return
        }
        
        let body = request.HTTPBody!
        do {
            let dictionary = try NSJSONSerialization.JSONObjectWithData(body, options: .MutableContainers) as? [String: String]
            XCTAssertEqual(dictionary!, payload)
        } catch {
            XCTFail("could not deserialize JSON")
        }
        
    }
}
