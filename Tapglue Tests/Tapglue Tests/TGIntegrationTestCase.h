//
//  TGIntegrationTestCase.h
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

#import "TGTestCase.h"

extern NSString *const TGTestUserEmail;
extern NSString *const TGTestUsername;
extern NSString *const TGTestFirstName;
extern NSString *const TGTestLastName;
extern NSString *const TGTestUserEmail;
extern NSString *const TGTestPassword;

extern NSString *const TGPersistentUserEmail;
extern NSString *const TGPersistentPassword;

extern NSString *const TGFriendUsername;

extern NSString *const TGSearchTerm;

@interface TGIntegrationTestCase : TGTestCase

- (void)runTestBlockAfterLogin:(void (^)(XCTestExpectation *expectation))testBlock;

- (void)waitForExpectations;

- (void)deleteCurrentUserWithXCTestExpectation:(XCTestExpectation*)expectation;

@end
