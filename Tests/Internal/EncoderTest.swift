//
//  EncoderTest.swift
//  Tapglue
//
//  Created by John Nilsen on 7/5/16.
//  Copyright © 2016 Tapglue. All rights reserved.
//

import XCTest
import Nimble
@testable import Tapglue

class EncoderTest: XCTestCase {

    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }

    func testEncodingReturnsCorrectValue() {
        //string to be encoded 'appToken:sessionToken'
        let appToken = "appToken"
        let sessionToken = "sessionToken"
        let expected = "YXBwVG9rZW46c2Vzc2lvblRva2Vu"
        
        expect(Encoder.encode(appToken, sessionToken: sessionToken)).to(equal(expected))
    }
}
