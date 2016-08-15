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

    func testRouterPutCreatesRequestWithMethod() {
        let request = Router.put("/me", payload: [:])
        expect(request.HTTPMethod).to(equal("PUT"))
    }

    func testRouterPutCreatesRequestWithPayload() {
        let payload = ["user_name":"paco", "password":"1234"]
        let request = Router.put("/login", payload: payload)
        if request.HTTPBody == nil {
            fail("http body was nil!")
            return
        }
        
        let body = request.HTTPBody!
        do {
            let dictionary = try NSJSONSerialization.JSONObjectWithData(body, options: .MutableContainers) as? [String: String]
            expect(dictionary).to(equal(payload))
        } catch {
            fail("could not deserialize JSON")
        }
    }

    func testRouterDeleteCreatesRequestWithMethod() {
        let request = Router.delete("/me")
        expect(request.HTTPMethod).to(equal("DELETE"))
    }
    
    func testRouterAddsOSHeader() {
        let request = Router.post("/login", payload: [:])
        let headers = request.allHTTPHeaderFields!
        let header = headers["X-Tapglue-OS"]
        
        expect(header).to(equal("iOS"))
    }
    
    func testRouterAddsManufacturerHeader() {
        let request = Router.post("/login", payload: [:])
        let headers = request.allHTTPHeaderFields!
        let header = headers["X-Tapglue-Manufacturer"]
        
        expect(header).to(equal("Apple"))
    }

    func testRouterAddsSDKVersionHeader() {
        let request = Router.get("/me")
        let headers = request.allHTTPHeaderFields!
        let header = headers["X-Tapglue-SDKVersion"]

        expect(header).to(equal(Router.sdkVersion))
    }
    
    func testRouterAddsTimezoneHeader() {
        let request = Router.get("/me")
        let headers = request.allHTTPHeaderFields!
        let header = headers["X-Tapglue-Timezone"]
        
        expect(header).to(equal(NSTimeZone.localTimeZone().abbreviation!))
    }

    func testRouterAddsDeviceIdHeader() {
        let request = Router.get("/me")
        let headers = request.allHTTPHeaderFields!
        let header = headers["X-Tapglue-IDFV"]
        
        expect(header).toNot(beEmpty())
    }
    
    func testRouterAddsModelHeader() {
        let request = Router.get("/me")
        let headers = request.allHTTPHeaderFields!
        let header = headers["X-Tapglue-Model"]
        
        expect(header).toNot(beEmpty())
    }
    
    func testRouterAddsOsVersionHeader() {
        let request = Router.get("/me")
        let headers = request.allHTTPHeaderFields!
        let header = headers["X-Tapglue-OSVersion"]
        
        expect(header).toNot(beEmpty())
    }
}
