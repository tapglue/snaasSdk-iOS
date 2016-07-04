//
//  TapglueTests.swift
//  TapglueTests
//
//  Created by John Nilsen on 6/27/16.
//  Copyright © 2016 Tapglue. All rights reserved.
//

import XCTest
import RxSwift
@testable import Tapglue

class TapglueTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let tapglue = Tapglue()
        XCTAssertEqualWithAccuracy(tapglue.doSomething(), 289, accuracy: 0.1)
        
        
//        XCTAssert(tapglue.doSomething() == 289)
    }
    
    func testCreateUser() {
        let tapglue = Tapglue()
        tapglue.createUser("paco", password: "1234")
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock {
            // Put the code you want to measure the time of here.
        }
    }
    
}
