//
//  TGIntegrationTestCase.m
//  Tapglue Tests
//
//  Created by Martin Stemmle on 04/06/15.
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

#import "TGIntegrationTestCase.h"
#import "TGUser.h"

NSString *const TGTestUsername = @"TGTestUsername15000";
NSString *const TGTestFirstName = @"TGFirst";
NSString *const TGTestLastName = @"TGLast";
NSString *const TGTestUserEmail = @"TGTestUser14@tapglue.com";
NSString *const TGTestPassword = @"password";

NSString *const TGFriendUsername = @"TGTestUsername300";

NSString *const TGPersistentUserEmail = @"TGPersistentUser@tapglue.com";
NSString *const TGPersistentPassword = @"password";

NSString *const TGSearchTerm = @"TGConnectionUser";

@implementation TGIntegrationTestCase

- (void)setUp {
    [super setUp];
    [Tapglue setUpWithAppToken:self.appToken andConfig:self.config];
}

- (void)runTestBlockAfterLogin:(void (^)(XCTestExpectation *expectation))testBlock {
    XCTestExpectation *expectation = [self expectationWithDescription:@"api call will finish"];
    [self loginWithWithCompletionBlock:^(BOOL success) {
        if (success) {
            testBlock(expectation);
        }
        else {
            [expectation fulfill];
        }
    }];
    [self waitForExpectations];
}

- (void)loginWithWithCompletionBlock:(void (^)(BOOL success))completionBlock {
    [Tapglue loginWithUsernameOrEmail:TGPersistentUserEmail
                          andPassword:TGPersistentPassword
                  withCompletionBlock:^(BOOL success, NSError *error) {
        expect(success).will.beTruthy();
        expect(error).will.beNil();

        completionBlock(success);
    }];
}


- (void)deleteCurrentUserWithXCTestExpectation:(XCTestExpectation*)expectation {
    TGUser *currentUser = [TGUser currentUser];
    if (currentUser) {
        [currentUser deleteWithCompletionBlock:^(BOOL success, NSError *error) {
            expect(success).will.beTruthy();
            expect(error).will.beNil();
            expect([TGUser currentUser]).to.beNil();
            [expectation fulfill];
        }];
    }
    else {
        // if the is no currentUser fulfill the expectation to end the test
        [expectation fulfill];
    }
}


#pragma mark - Helper -

#pragma mark - Delay Expectation

- (void) waitForExpectations {
    [self waitForExpectationsWithTimeout:10.0 handler:^(NSError *error) {
        if(error) {
            XCTFail(@"Expectation Failed with error: %@", error);
        }
    }];
}

@end
