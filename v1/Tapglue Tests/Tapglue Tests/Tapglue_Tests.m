//
//  Tapglue_Tests.m
//  Tapglue Tests
//
//  Created by Martin Stemmle on 02/06/15.
//  Copyright (c) 2015 Tapglue (https://www.tapglue.com/). All rights reserved.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

#import "TGTestCase.h"

#import "Tapglue.h"
#import "NSURL+TGUtilities.h"
#import "TGEvent.h"
#import "NSError+TGError.h"
#import "TGApiClient.h"

@interface TGApiClient (TestingPrivates)
- (NSError*)errorFromJsonResponse:(NSDictionary*)jsonResponse withHTTPStatus:(NSInteger)httpStatusCode;
@end

@interface Tapglue_Tests : TGTestCase

@end

@implementation Tapglue_Tests

- (void)setUp {
    [super setUp];
    [Tapglue setUpWithAppToken:self.appToken andConfig:self.config];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testURLByAppendingQueryParameters {
    NSURL *testUrl = [NSURL URLWithString:@"http://tapglue.com"];
    NSURL *expectedUrl = [NSURL URLWithString:@"http://tapglue.com?foo=bar"];
    expect([testUrl tg_URLByAppendingQueryParameters:@{@"foo": @"bar"}]).to.equal(expectedUrl);
}

- (void)testErrorFromDictionary {
    NSError *error;

    error = [NSError tg_errorFromJsonDicitonary:@{@"code" : @123, @"message": @"something went wrong"}];
    expect(error.domain).to.equal(TGErrorDomain);
    expect(error.code).to.equal(123);
    expect(error.localizedDescription).to.equal(@"something went wrong");

    error = [NSError tg_errorFromJsonDicitonary:@{@"code" : @-12, @"message": @"something went wrong"}];
    expect(error.domain).to.equal(TGErrorDomain);
    expect(error.code).to.equal(kTGErrorUnknownError);
    expect(error.localizedDescription).to.equal(@"something went wrong");

    error = [NSError tg_errorFromJsonDicitonary:@{@"message": @"something went wrong"}];
    expect(error.domain).to.equal(TGErrorDomain);
    expect(error.code).to.equal(kTGErrorUnknownError);
    expect(error.localizedDescription).to.equal(@"something went wrong");

    error = [NSError tg_errorFromJsonDicitonary:@{@"code": @123}];
    expect(error.domain).to.equal(TGErrorDomain);
    expect(error.code).to.equal(123);


    error = [NSError tg_errorFromJsonDicitonary:@{@"code" : @123, @"message": @"something went wrong"}
                                   withUserInfo:@{@"test" : @"some reason"}];
    expect(error.domain).to.equal(TGErrorDomain);
    expect(error.code).to.equal(123);
    expect(error.localizedDescription).to.equal(@"something went wrong");
    expect([error.userInfo valueForKey:@"test"]).to.equal(@"some reason");

}

- (void)testNoErrorFromDictionary {

    NSDictionary *jsonResponse = @{@"errors" : @[] };

    NSError *error = [[TGApiClient new] errorFromJsonResponse:jsonResponse withHTTPStatus:400];

    expect(error.domain).to.equal(TGErrorDomain);
    expect(error.code).to.equal(kTGErrorUnknownError);
    expect([error.userInfo objectForKey:TGErrorHTTPStatusCodeKey]).to.equal(400);
}

- (void)testSingleErrorFromDictionary {

    NSDictionary *jsonResponse = @{@"errors" : @[
                                           @{@"code" : @123, @"message": @"something went wrong"}
                                           ]
                                   };

    NSError *error = [[TGApiClient new] errorFromJsonResponse:jsonResponse withHTTPStatus:400];

    expect(error.domain).to.equal(TGErrorDomain);
    expect(error.code).to.equal(123);
    expect(error.localizedDescription).to.equal(@"something went wrong");
    expect([error.userInfo objectForKey:TGErrorHTTPStatusCodeKey]).to.equal(400);

}

- (void)testMultipleErrorsFromDictionary {

    NSDictionary *jsonResponse = @{@"errors" : @[
                                           @{@"code" : @123, @"message": @"something went wrong"},
                                           @{@"code" : @456, @"message": @"shit happened"}
                                           ]
                                   };

    NSError *error = [[TGApiClient new] errorFromJsonResponse:jsonResponse withHTTPStatus:400];

    expect(error.domain).to.equal(TGErrorDomain);
    expect(error.code).to.equal(kTGErrorMultipleErrors);
    expect(error.userInfo).toNot.beNil();
    expect(error.localizedDescription).to.equal(@"Multiple errors occured. See userInfos[TGErrorUnderlyingErrorsKey]");
    expect([error.userInfo objectForKey:TGErrorHTTPStatusCodeKey]).to.equal(400);


    NSArray *underlyingErrors = [error.userInfo objectForKey:TGErrorUnderlyingErrorsKey];
    expect(underlyingErrors).to.beKindOf([NSArray class]);
    expect(underlyingErrors.count).to.equal(2);

    NSError *underlyingErrors1 = underlyingErrors[0];
    expect(underlyingErrors1.domain).to.equal(TGErrorDomain);
    expect(underlyingErrors1.code).to.equal(123);
    expect(underlyingErrors1.localizedDescription).to.equal(@"something went wrong");
    expect([underlyingErrors1.userInfo objectForKey:TGErrorHTTPStatusCodeKey]).to.beNil();


    NSError *underlyingErrors2 = underlyingErrors[1];
    expect(underlyingErrors2.domain).to.equal(TGErrorDomain);
    expect(underlyingErrors2.code).to.equal(456);
    expect(underlyingErrors2.localizedDescription).to.equal(@"shit happened");
    expect([underlyingErrors2.userInfo objectForKey:TGErrorHTTPStatusCodeKey]).to.beNil();

}



- (void) waitForExpectations {
    [self waitForExpectationsWithTimeout:5.0 handler:^(NSError *error) {
        if(error) {
            XCTFail(@"Expectation Failed with error: %@", error);
        }
    }];
}

@end
