//
//  RouterTest.swift
//  Tapglue
//
//  Created by John Nilsen on 7/4/16.
//  Copyright © 2016 Tapglue. All rights reserved.
//

import XCTest
import Nimble
@testable import Tapglue

class RouterTest: XCTestCase {
    
    override func setUp() {
        super.setUp()
        Router.configuration =  Configuration()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testRouterPostCreatesRequestWithMethod() {
        let request = Router.post("/login", payload: ["user_name":"paco"])
        expect(request.HTTPMethod).to(equal("POST"))
    }
    
    func testRouterPostCreatesRequestWithPath() {
        let request = Router.post("/login", payload: ["a":"b"])
        expect(request.URLString).to(equal("https://api.tapglue.com/0.4/login"))
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
            expect(dictionary).to(equal(payload))
        } catch {
            XCTFail("could not deserialize JSON")
        }
    }
    
    func testRouterPostAddsAppTokenHeader() {
        let request = Router.post("/login", payload: [:])
        let headers = request.allHTTPHeaderFields!
        let authorizationHeader = headers["Authorization"]
        
        expect(authorizationHeader).to(contain("Basic "))
    }
    
    func testRouterGetCreatesRequestWithMethod() {
        let request = Router.get("/me")
        expect(request.HTTPMethod).to(equal("GET"))
    }
    
    func testRouterGetBodyNil() {
        let request = Router.get("/me")
        expect(request.HTTPBody).to(beNil())
    }
}
