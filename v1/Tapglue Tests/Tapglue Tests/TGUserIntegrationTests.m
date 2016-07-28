//
//  TGUserIntegrationTests.m
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
#import "TGObject+Private.h"
#import "TGUser.h"
#import "NSError+TGError.h"
#import "NSString+TGRandomString.h"

@interface TGUserIntegrationTests : TGIntegrationTestCase

@end

@implementation TGUserIntegrationTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"test setUp will finish"];
    
    [Tapglue createAndLoginUserWithEmail:TGPersistentUserEmail andPassword:TGPersistentPassword withCompletionBlock:^(BOOL success, NSError *error) {
        expect(success).to.beTruthy();
        expect(error).to.beNil();
        
        [Tapglue createAndLoginUserWithUsername:TGSearchTerm andPassword:TGPersistentPassword withCompletionBlock:^(BOOL success, NSError *error) {
            expect(success).to.beTruthy();
            expect(error).to.beNil();
            
            [Tapglue createAndLoginUserWithUsername:TGFriendUsername andPassword:TGPersistentPassword withCompletionBlock:^(BOOL success, NSError *error) {
                expect(success).to.beTruthy();
                expect(error).to.beNil();
                
                [Tapglue createAndLoginUserWithUsername:TGTestUsername andPassword:TGPersistentPassword withCompletionBlock:^(BOOL success, NSError *error) {
                    expect(success).to.beTruthy();
                    expect(error).to.beNil();
                    [expectation fulfill];
                }];
            }];
        }];
    }];
    
    [self waitForExpectationsWithTimeout:9000.0 handler:^(NSError *error) {
        if(error) {
            XCTFail(@"Expectation Failed with error: %@", error);
        }
    }];
    
}

#pragma mark - CRUD User -

#pragma mark - Correct

// [Correct] Create Persistent User (without delete)
- (void)testCreatePersistentUserWithEmail {
    XCTestExpectation *expectation = [self expectationWithDescription:@"api call will finish"];

    // Create User
    [Tapglue createAndLoginUserWithEmail:TGPersistentUserEmail andPassword:TGPersistentPassword withCompletionBlock:^(BOOL success, NSError *error) {
        expect(success).to.beTruthy();
        expect(error).to.beNil();
        expect([TGUser currentUser]).toNot.beNil();

        expect([TGUser currentUser].email).to.equal(TGPersistentUserEmail);

        [expectation fulfill];
    }];

    [self waitForExpectations];
}

// [Correct] Create User with Username
- (void)testCreateUserWithUsername {
    XCTestExpectation *expectation = [self expectationWithDescription:@"api call will finish"];

    // Create User
    [Tapglue createAndLoginUserWithUsername:TGTestUsername andPassword:TGTestPassword withCompletionBlock:^(BOOL success, NSError *error) {
        expect(success).to.beTruthy();
        expect(error).to.beNil();

        expect([TGUser currentUser]).toNot.beNil();
        expect([TGUser currentUser].userId).toNot.beNil();
        expect([TGUser currentUser].username).to.equal(TGTestUsername);

        [expectation fulfill];
    }];

    [self waitForExpectations];
}

// [Correct] Create User with Email
- (void)testCreateUserWithEmail {
    XCTestExpectation *expectation = [self expectationWithDescription:@"api call will finish"];

    // Create User
    [Tapglue createAndLoginUserWithEmail:TGTestUserEmail andPassword:TGTestPassword withCompletionBlock:^(BOOL success, NSError *error) {
        expect(success).to.beTruthy();
        expect(error).to.beNil();

        expect([TGUser currentUser]).toNot.beNil();
        expect([TGUser currentUser].userId).toNot.beNil();
        expect([TGUser currentUser].email).to.equal(TGTestUserEmail);

        [expectation fulfill];
    }];

    [self waitForExpectations];
}

// [Correct] Create User with CompleteTGUser
- (void)testCreateUserWithCompleteTGUser {
    XCTestExpectation *expectation = [self expectationWithDescription:@"api call will finish"];

    TGUser *user = [[TGUser alloc] init];
    user.customId = @"123456abc";
    [user setSocialId:@"acc-1-app-1-user-2-abk" forKey:@"abook"];
    [user setSocialId:@"acc-1-app-1-user-2-fb" forKey:@"facebook"];
    [user setSocialId:@"acc-1-app-1-user-2-gpl" forKey:@"gplus"];
    [user setSocialId:@"acc-1-app-1-user-2-tw" forKey:@"twitter"];
    user.username = TGTestUsername;
    user.firstName = TGTestFirstName;
    user.lastName = TGTestLastName;
    user.email = TGTestUserEmail;
    [user setPassword:TGTestPassword];
    user.url = @"app://tapglue.com/users/1/demouser";
    user.metadata = @{
                      @"foo" : @"bar",
                      @"amount" : @12,
                      @"progress" : @0.95
                      };

    // Create User
    [Tapglue createAndLoginUser:user withCompletionBlock:^(BOOL success, NSError *error) {
        expect(success).to.beTruthy();
        expect(error).to.beNil();

        expect([TGUser currentUser]).toNot.beNil();
        expect([TGUser currentUser].userId).toNot.beNil();

        expect([TGUser currentUser].customId).to.equal(user.customId);
        expect([TGUser currentUser].username).to.equal(user.username);
        expect([TGUser currentUser].firstName).to.equal(user.firstName);
        expect([TGUser currentUser].lastName).to.equal(user.lastName);
        expect([TGUser currentUser].email).to.equal(user.email);
        expect([TGUser currentUser].url).to.equal(user.url);

        [expectation fulfill];
    }];

    [self waitForExpectations];
}

// [Correct] Update Username complete data
- (void)testCreateNewUserAndCheckIfIsCurrentUserOnSuccess {
    XCTestExpectation *expectation = [self expectationWithDescription:@"api call will finish"];

    TGUser *user = [[TGUser alloc] init];
    user.username = TGTestUsername;
    user.firstName = TGTestFirstName;
    user.lastName = TGTestLastName;
    user.email= TGTestUserEmail;
    user.password = TGTestPassword;

    // Create User
    [Tapglue createAndLoginUser:user withCompletionBlock:^(BOOL success, NSError *error) {
        expect(success).to.beTruthy();
        expect(error).to.beNil();

        expect(user.isCurrentUser).to.beTruthy();
        expect(user).to.equal([TGUser currentUser]);

        [expectation fulfill];
    }];

    [self waitForExpectations];
}

// [Correct] Update Username complete data
- (void)testCreateAndUpdateUserWithUsernameComplete {
    XCTestExpectation *expectation = [self expectationWithDescription:@"api call will finish"];

    TGUser *user = [[TGUser alloc] init];
    user.username = TGTestUsername;
    user.firstName = TGTestFirstName;
    user.lastName = TGTestLastName;
    user.email= TGTestUserEmail;
    user.password = TGTestPassword;

    // Create User
    [Tapglue createAndLoginUser:user withCompletionBlock:^(BOOL success, NSError *error) {
        expect(success).to.beTruthy();
        expect(error).to.beNil();

        expect([TGUser currentUser]).toNot.beNil();
        expect([TGUser currentUser].userId).toNot.beNil();

        expect([TGUser currentUser].username).to.equal(TGTestUsername);
//        expect([TGUser currentUser].firstName).to.equal(TGTestFirstName);
//        expect([TGUser currentUser].lastName).to.equal(TGTestLastName);
//        expect([TGUser currentUser].email).to.equal(TGTestUserEmail);

        [TGUser currentUser].username = @"changedUsernamesada";

        [[TGUser currentUser] saveWithCompletionBlock:^(BOOL success, NSError *error) {
            expect(success).to.beTruthy();
            expect(error).to.beNil();

            expect([TGUser currentUser].username).to.equal(@"changedUsernamesada");

            [[TGUser currentUser] deleteWithCompletionBlock:^(BOOL success, NSError *error) {
                expect(success).to.beTruthy();
                [expectation fulfill];
            }];
        }];
    }];

    [self waitForExpectations];
}

// [Correct] Update Username minimal data
- (void)testCreateAndUpdateUserWithUsernameMinimal {
    XCTestExpectation *expectation = [self expectationWithDescription:@"api call will finish"];

    TGUser *user = [[TGUser alloc] init];
    user.username = TGTestUsername;
    user.password = TGTestPassword;

    // Create User
    [Tapglue createAndLoginUser:user withCompletionBlock:^(BOOL success, NSError *error) {
        expect(success).to.beTruthy();
        expect(error).to.beNil();

        expect([TGUser currentUser]).toNot.beNil();
        expect([TGUser currentUser].userId).toNot.beNil();

        expect([TGUser currentUser].username).to.equal(user.username);
        expect([TGUser currentUser].username).to.equal(TGTestUsername);

        user.username = @"changedUsername";

        [[TGUser currentUser] saveWithCompletionBlock:^(BOOL success, NSError *error) {
            expect(success).to.beTruthy();
            expect(error).to.beNil();

            expect([TGUser currentUser].username).to.equal(user.username);
            expect([TGUser currentUser].username).to.equal(@"changedUsername");

            [expectation fulfill];
            
        }];
    }];

    [self waitForExpectations];
}

// [Correct] Update Email complete data
- (void)testCreateAndUpdateUserWithEmailComplete {
    XCTestExpectation *expectation = [self expectationWithDescription:@"api call will finish"];

    TGUser *user = [[TGUser alloc] init];
    user.username = TGTestUsername;
    user.firstName = TGTestFirstName;
    user.lastName = TGTestLastName;
    user.email= TGTestUserEmail;
    user.password = TGTestPassword;

    // Create User
    [Tapglue createAndLoginUser:user withCompletionBlock:^(BOOL success, NSError *error) {
        expect(success).to.beTruthy();
        expect(error).to.beNil();

        expect([TGUser currentUser]).toNot.beNil();
        expect([TGUser currentUser].userId).toNot.beNil();

        expect([TGUser currentUser].username).to.equal(TGTestUsername);
        expect([TGUser currentUser].firstName).to.equal(TGTestFirstName);
        expect([TGUser currentUser].lastName).to.equal(TGTestLastName);
        expect([TGUser currentUser].email).to.equal(TGTestUserEmail);

        [TGUser currentUser].email = @"changedMail@tapglue.com";

        [[TGUser currentUser] saveWithCompletionBlock:^(BOOL success, NSError *error) {
            expect(success).to.beTruthy();
            expect(error).to.beNil();

            expect([TGUser currentUser].email).to.equal(user.email);

            [expectation fulfill];
            
        }];
    }];

    [self waitForExpectations];
}

// [Correct] Update Email from where there was no before
- (void)testCreateAndUpdateUserWithUpdateEmailOnly {
    XCTestExpectation *expectation = [self expectationWithDescription:@"api call will finish"];

    TGUser *user = [[TGUser alloc] init];
    user.username = TGTestUsername;
    user.firstName = TGTestFirstName;
    user.lastName = TGTestLastName;
    user.password = TGTestPassword;

    // Create User
    [Tapglue createAndLoginUser:user withCompletionBlock:^(BOOL success, NSError *error) {
        expect(success).to.beTruthy();
        expect(error).to.beNil();

        expect([TGUser currentUser]).toNot.beNil();
        expect([TGUser currentUser].userId).toNot.beNil();

        expect([TGUser currentUser].username).to.equal(TGTestUsername);
        expect([TGUser currentUser].firstName).to.equal(TGTestFirstName);
        expect([TGUser currentUser].lastName).to.equal(TGTestLastName);

        user.email = @"changedMail@tapglue.com";

        [[TGUser currentUser] saveWithCompletionBlock:^(BOOL success, NSError *error) {
            expect(success).to.beTruthy();
            expect(error).to.beNil();

            expect([TGUser currentUser].email).to.equal(user.email);

            [expectation fulfill];
            
        }];
    }];

    [self waitForExpectations];
}

// [Correct] Update everything
- (void)testCreateAndUpdateUserCompleteData {
    XCTestExpectation *expectation = [self expectationWithDescription:@"api call will finish"];

    TGUser *user = [[TGUser alloc] init];
    user.username = TGTestUsername;
    user.firstName = TGTestFirstName;
    user.lastName = TGTestLastName;
    user.email= TGTestUserEmail;
    user.password = TGTestPassword;

    // Create User
    [Tapglue createAndLoginUser:user withCompletionBlock:^(BOOL success, NSError *error) {
        expect(success).to.beTruthy();
        expect(error).to.beNil();

        expect([TGUser currentUser]).toNot.beNil();
        expect([TGUser currentUser].userId).toNot.beNil();

        expect([TGUser currentUser].username).to.equal(TGTestUsername);
        expect([TGUser currentUser].firstName).to.equal(TGTestFirstName);
        expect([TGUser currentUser].lastName).to.equal(TGTestLastName);
        expect([TGUser currentUser].email).to.equal(TGTestUserEmail);

        user.username = TGTestUsername;
        user.firstName = TGTestFirstName;
        user.lastName = TGTestLastName;
        user.email= TGTestUserEmail;
        user.password = TGTestPassword;

        [[TGUser currentUser] saveWithCompletionBlock:^(BOOL success, NSError *error) {
            expect(success).to.beTruthy();
            expect(error).to.beNil();

            expect([TGUser currentUser]).toNot.beNil();

            [expectation fulfill];
            
        }];
    }];

    [self waitForExpectations];
}

// [Correct] Create and Retrieve User with Username
- (void)testCreateUserWithUsernameAndRetrieve {
    XCTestExpectation *expectation = [self expectationWithDescription:@"api call will finish"];

    // Create User
    [Tapglue createAndLoginUserWithUsername:TGTestUsername andPassword:TGTestPassword withCompletionBlock:^(BOOL success, NSError *error) {
        expect(success).to.beTruthy();
        expect(error).to.beNil();

        expect([TGUser currentUser]).toNot.beNil();
        expect([TGUser currentUser].userId).toNot.beNil();

        expect([TGUser currentUser].username).to.equal(TGTestUsername);

        [Tapglue retrieveCurrentUserWithCompletionBlock:^(TGUser *user, NSError *error) {
            expect(error).to.beNil();

            expect(user).toNot.beNil();
            expect(user.username).to.equal(TGTestUsername);

            [expectation fulfill];
            
        }];
    }];

    [self waitForExpectations];
}

// [Correct] Create and Retrieve User with Email
- (void)testCreateUserWithEmailAndRetrieve {
    XCTestExpectation *expectation = [self expectationWithDescription:@"api call will finish"];

    // Create User
    [Tapglue createAndLoginUserWithEmail:TGTestUserEmail andPassword:TGTestPassword withCompletionBlock:^(BOOL success, NSError *error) {
        expect(success).to.beTruthy();
        expect(error).to.beNil();

        expect([TGUser currentUser]).toNot.beNil();
        expect([TGUser currentUser].userId).toNot.beNil();

        expect([TGUser currentUser].email).to.equal(TGTestUserEmail);

        [Tapglue retrieveCurrentUserWithCompletionBlock:^(TGUser *user, NSError *error) {
            expect(error).to.beNil();
            expect(user.email).to.equal(TGTestUserEmail);

            [expectation fulfill];
            
        }];
    }];

    [self waitForExpectations];
}

// [Correct] Create and Retrieve complete User
- (void)testCreateAndRetrieveUserComplete {
    XCTestExpectation *expectation = [self expectationWithDescription:@"api call will finish"];

    TGUser *user = [[TGUser alloc] init];
    user.username = TGTestUsername;
    user.firstName = TGTestFirstName;
    user.lastName = TGTestLastName;
    user.email= TGTestUserEmail;
    user.password = TGTestPassword;

    // Create User
    [Tapglue createAndLoginUser:user withCompletionBlock:^(BOOL success, NSError *error) {
        expect(success).to.beTruthy();
        expect(error).to.beNil();

        expect([TGUser currentUser]).toNot.beNil();
        expect([TGUser currentUser].userId).toNot.beNil();

        expect([TGUser currentUser].username).to.equal(TGTestUsername);
        expect([TGUser currentUser].firstName).to.equal(TGTestFirstName);
        expect([TGUser currentUser].lastName).to.equal(TGTestLastName);
        expect([TGUser currentUser].email).to.equal(TGTestUserEmail);

        [Tapglue retrieveCurrentUserWithCompletionBlock:^(TGUser *user, NSError *error) {
            expect(error).to.beNil();
            expect(user.username).to.equal(TGTestUsername);
            expect(user.firstName).to.equal(TGTestFirstName);
            expect(user.lastName).to.equal(TGTestLastName);
            expect(user.email).to.equal(TGTestUserEmail);

            [expectation fulfill];
            
        }];
    }];

    [self waitForExpectations];
}

// [Correct] Create and Retrieve complete User after logging out an in again
- (void)testCreateAndRetrieveAfterLogoutAndLogin {
    XCTestExpectation *expectation = [self expectationWithDescription:@"api call will finish"];

    TGUser *user = [[TGUser alloc] init];
    user.username = TGTestUsername;
    user.firstName = TGTestFirstName;
    user.lastName = TGTestLastName;
    user.email= TGTestUserEmail;
    user.password = TGTestPassword;

    // Create User
    [Tapglue createAndLoginUser:user withCompletionBlock:^(BOOL success, NSError *error) {
        expect(success).to.beTruthy();
        expect(error).to.beNil();

        expect([TGUser currentUser]).toNot.beNil();
        expect([TGUser currentUser].userId).toNot.beNil();

        expect([TGUser currentUser].username).to.equal(TGTestUsername);
        expect([TGUser currentUser].firstName).to.equal(TGTestFirstName);
        expect([TGUser currentUser].lastName).to.equal(TGTestLastName);
        expect([TGUser currentUser].email).to.equal(TGTestUserEmail);

        [Tapglue logoutWithCompletionBlock:^(BOOL success, NSError *error) {
            expect(success).to.beTruthy();
            expect(error).to.beNil();

            [Tapglue loginWithUsernameOrEmail:TGTestUserEmail
                                  andPassword:TGTestPassword
                          withCompletionBlock:^(BOOL success, NSError *error) {
                              // Retrieve User
                              [Tapglue retrieveCurrentUserWithCompletionBlock:^(TGUser *user, NSError *error) {
                                  expect(error).to.beNil();
                                  expect(user).toNot.beNil();

                                  expect(user.username).to.equal(TGTestUsername);
                                  expect(user.firstName).to.equal(TGTestFirstName);
                                  expect(user.lastName).to.equal(TGTestLastName);
                                  expect(user.email).to.equal(TGTestUserEmail);

                                  [expectation fulfill];
                                  
                              }];
                          }];
        }];
    }];

    [self waitForExpectations];
}

// [Correct] Create and Retrieve complete User after changing pw
- (void)testCreateAndRetrieveAfterPWChange {
    XCTestExpectation *expectation = [self expectationWithDescription:@"api call will finish"];

    TGUser *user = [[TGUser alloc] init];
    user.username = TGTestUsername;
    user.firstName = TGTestFirstName;
    user.lastName = TGTestLastName;
    user.email= TGTestUserEmail;
    user.password = TGTestPassword;

    // Create User
    [Tapglue createAndLoginUser:user withCompletionBlock:^(BOOL success, NSError *error) {
        expect(success).to.beTruthy();
        expect(error).to.beNil();

        expect([TGUser currentUser]).toNot.beNil();
        expect([TGUser currentUser].userId).toNot.beNil();

        expect([TGUser currentUser].username).to.equal(TGTestUsername);
        expect([TGUser currentUser].firstName).to.equal(TGTestFirstName);
        expect([TGUser currentUser].lastName).to.equal(TGTestLastName);
        expect([TGUser currentUser].email).to.equal(TGTestUserEmail);

        user.password = @"changed";

        [[TGUser currentUser] saveWithCompletionBlock:^(BOOL success, NSError *error) {
            [Tapglue retrieveCurrentUserWithCompletionBlock:^(TGUser *user, NSError *error) {
                expect(error).to.beNil();
                expect(user).toNot.beNil();

                expect(user.username).to.equal(TGTestUsername);
                expect(user.firstName).to.equal(TGTestFirstName);
                expect(user.lastName).to.equal(TGTestLastName);
                expect(user.email).to.equal(TGTestUserEmail);

                [expectation fulfill];
                
            }];
        }];
    }];

    [self waitForExpectations];
}

#pragma mark - Negative

// [Negative] Create User with wrong Username
- (void)testCreateUserWithWrongUsername {
    XCTestExpectation *expectation = [self expectationWithDescription:@"api call will finish"];

    // Create User
    [Tapglue createAndLoginUserWithUsername:@"a" andPassword:TGTestPassword withCompletionBlock:^(BOOL success, NSError *error) {
        expect(success).to.beFalsy();
        expect(error).to.beTruthy();

        expect(error.domain).to.equal(TGErrorDomain);
        expect(error.code).to.equal(kTGErrorUserUsernameSize);
        expect(error.userInfo).toNot.beNil();
        expect([error.userInfo objectForKey:TGErrorHTTPStatusCodeKey]).to.equal(400);

        [expectation fulfill];
    }];

    [self waitForExpectations];
}

// [Negative] Create User no Password
- (void)testCreateUserWithNoPassword {
    XCTestExpectation *expectation = [self expectationWithDescription:@"api call will finish"];

    TGUser *user = [[TGUser alloc] init];
    user.username = TGTestUsername;

    // Create User
    [Tapglue createAndLoginUser:user withCompletionBlock:^(BOOL success, NSError *error) {
        expect(success).to.beFalsy();
        expect(error).to.beTruthy();

        expect(error.domain).to.equal(TGErrorDomain);
//        expect(error.code).to.equal(kTGErrorMultipleErrors);
        expect(error.userInfo).toNot.beNil();
        expect([error.userInfo objectForKey:TGErrorHTTPStatusCodeKey]).to.equal(400);

        [expectation fulfill];
    }];

    [self waitForExpectations];
}

// [Negative] Create User no Data
- (void)testCreateUserWithNoData {
    XCTestExpectation *expectation = [self expectationWithDescription:@"api call will finish"];

    TGUser *user = [[TGUser alloc] init];

    // Create User
    [Tapglue createAndLoginUser:user withCompletionBlock:^(BOOL success, NSError *error) {
        expect(success).to.beFalsy();
        expect(error).to.beTruthy();

        expect(error.domain).to.equal(TGErrorDomain);
        expect(error.code).to.equal(kTGErrorMultipleErrors);
        expect(error.userInfo).toNot.beNil();
        expect([error.userInfo objectForKey:TGErrorHTTPStatusCodeKey]).to.equal(400);

        [expectation fulfill];
    }];

    [self waitForExpectations];
}

// [Negative] Create User with wrong Email
- (void)testCreateUserWithWrongEmail {
    XCTestExpectation *expectation = [self expectationWithDescription:@"api call will finish"];

    // Create User
    [Tapglue createAndLoginUserWithEmail:@"incorrectMail" andPassword:TGTestPassword withCompletionBlock:^(BOOL success, NSError *error) {
        expect(success).to.beFalsy();
        expect(error).to.beTruthy();

        expect(error.domain).to.equal(TGErrorDomain);
//        expect(error.code).to.equal(kTGErrorMultipleErrors);
        expect(error.userInfo).toNot.beNil();
        expect([error.userInfo objectForKey:TGErrorHTTPStatusCodeKey]).to.equal(400);

        [expectation fulfill];
    }];

    [self waitForExpectations];
}

// [Negative] Create User and update with wrong username
- (void)testCreateUserAndUpdateWithWrongUsername {
    XCTestExpectation *expectation = [self expectationWithDescription:@"api call will finish"];

    // Create User
    [Tapglue createAndLoginUserWithUsername:TGTestUsername andPassword:TGTestPassword withCompletionBlock:^(BOOL success, NSError *error) {
        expect(success).to.beTruthy();
        expect(error).to.beFalsy();

        TGUser *user = [TGUser currentUser];
        user.username = @"a";
        // Update User
        [user saveWithCompletionBlock:^(BOOL success, NSError *error) {
            expect(success).to.beFalsy();
            expect(error).to.beTruthy();
            
            expect(error.domain).to.equal(TGErrorDomain);
            expect(error.code).to.equal(kTGErrorUserUsernameSize);
            expect(error.userInfo).toNot.beNil();
            expect([error.userInfo objectForKey:TGErrorHTTPStatusCodeKey]).to.equal(400);
            
            [expectation fulfill];
            
        }];
    }];

    [self waitForExpectations];
}

// [Negative] Create User and update with wrong email
- (void)testCreateUserAndUpdateWithWrongEmail {
    XCTestExpectation *expectation = [self expectationWithDescription:@"api call will finish"];

    // Create User
    [Tapglue createAndLoginUserWithEmail:TGTestUserEmail andPassword:TGTestPassword withCompletionBlock:^(BOOL success, NSError *error) {
        expect(success).to.beTruthy();
        expect(error).to.beNil();

        TGUser *user = [[TGUser alloc] init];
        user.email = @"incorrectMail";
        // Update User

        [user saveWithCompletionBlock:^(BOOL success, NSError *error) {
            expect(success).to.beFalsy();
            expect(error).to.beTruthy();

            expect(error.domain).to.equal(TGErrorDomain);
//            expect(error.code).to.equal(kTGErrorUnknownError);
            expect(error.userInfo).toNot.beNil();
//            expect([error.userInfo objectForKey:TGErrorHTTPStatusCodeKey]).to.equal(400);

            [expectation fulfill];
            
        }];
    }];

    [self waitForExpectations];
}

// [Negative] Create User and update without data
- (void)testCreateUserAndUpdateWithoutData {
    XCTestExpectation *expectation = [self expectationWithDescription:@"api call will finish"];

    // Create User
    [Tapglue createAndLoginUserWithEmail:TGTestUserEmail andPassword:TGTestPassword withCompletionBlock:^(BOOL success, NSError *error) {
        expect(success).to.beTruthy();
        expect(error).to.beFalsy();

        TGUser *user = [[TGUser alloc] init];

        // Update User
        [user saveWithCompletionBlock:^(BOOL success, NSError *error) {
            expect(success).to.beFalsy();
            expect(error).to.beTruthy();

            expect(error.domain).to.equal(TGErrorDomain);
//            expect(error.code).to.equal(kTGErrorMultipleErrors);
            expect(error.userInfo).toNot.beNil();
//            expect([error.userInfo objectForKey:TGErrorHTTPStatusCodeKey]).to.equal(400);

            [expectation fulfill];
            
        }];
    }];

    [self waitForExpectations];
}

// [Negative] Create User and update after logout
- (void)testCreateUserAndUpdateAfterLogout {
    XCTestExpectation *expectation = [self expectationWithDescription:@"api call will finish"];

    // Create User
    [Tapglue createAndLoginUserWithEmail:TGTestUserEmail andPassword:TGTestPassword withCompletionBlock:^(BOOL success, NSError *error) {
        expect(success).to.beTruthy();
        expect(error).to.beFalsy();

        // Logout User
        [Tapglue logoutWithCompletionBlock:^(BOOL success, NSError *error) {

            TGUser *user = [[TGUser alloc] init];
            user.email = @"changedMail@mail.io";

            // Update User
            [user saveWithCompletionBlock:^(BOOL success, NSError *error) {
                expect(success).to.beFalsy();
                expect(error).to.beTruthy();

                expect(error.domain).to.equal(TGErrorDomain);
//                expect(error.code).to.equal(kTGErrorMultipleErrors);
                expect(error.userInfo).toNot.beNil();
//                expect([error.userInfo objectForKey:TGErrorHTTPStatusCodeKey]).to.equal(400);

                [Tapglue loginWithUsernameOrEmail:TGTestUserEmail
                                      andPassword:TGTestPassword
                              withCompletionBlock:^(BOOL success, NSError *error) {

                                  expect(success).to.beTruthy();
                                  expect(error).to.beFalsy();

                                  [expectation fulfill];
                                  
                              }];
            }];
        }];
    }];

    [self waitForExpectations];
}

// [Negative] Retrieve non-existing user
- (void)testCreateUserAndRetrieveNonExistingUser {
    XCTestExpectation *expectation = [self expectationWithDescription:@"api call will finish"];

    // Create User
    [Tapglue createAndLoginUserWithEmail:TGTestUserEmail andPassword:TGTestPassword withCompletionBlock:^(BOOL success, NSError *error) {
        expect(success).to.beTruthy();
        expect(error).to.beFalsy();

        [Tapglue retrieveUserWithId:@"nonExistingID" withCompletionBlock:^(TGUser *user, NSError *error) {
            expect(error).to.beTruthy();

            expect(error.domain).to.equal(TGErrorDomain);
//            expect(error.code).to.equal(kTGErrorMultipleErrors);
            expect(error.userInfo).toNot.beNil();
            expect([error.userInfo objectForKey:TGErrorHTTPStatusCodeKey]).to.equal(400);

            expect(user).to.beNil();

            [expectation fulfill];
            
        }];
    }];

    [self waitForExpectations];
}

// [Negative] Retrieve User after logout
- (void)testCreateUserAndRetrieveAfterLogout {
    XCTestExpectation *expectation = [self expectationWithDescription:@"api call will finish"];

    // Create User
    [Tapglue createAndLoginUserWithEmail:TGTestUserEmail andPassword:TGTestPassword withCompletionBlock:^(BOOL success, NSError *error) {
        expect(success).to.beTruthy();
        expect(error).to.beFalsy();


        // Logout User
        [Tapglue logoutWithCompletionBlock:^(BOOL success, NSError *error) {
            expect(success).to.beTruthy();
            expect(error).to.beFalsy();

            // Retrieve User
            [Tapglue retrieveCurrentUserWithCompletionBlock:^(TGUser *user, NSError *error) {
                expect(error).to.beTruthy();

                expect(error.domain).to.equal(TGErrorDomain);
//                expect(error.code).to.equal(kTGErrorMultipleErrors);
                expect(error.userInfo).toNot.beNil();
//                expect([error.userInfo objectForKey:TGErrorHTTPStatusCodeKey]).to.equal(400);

                expect(user).to.beNil();

                // Login User
                [Tapglue loginWithUsernameOrEmail:TGTestUserEmail
                                      andPassword:TGTestPassword
                              withCompletionBlock:^(BOOL success, NSError *error) {

                                  expect(success).to.beTruthy();
                                  expect(error).to.beFalsy();

                                  [expectation fulfill];
                                  
                              }];
            }];
        }];
    }];

    [self waitForExpectations];
}

#pragma mark - Login/Logout User -

#pragma mark - Correct

// [Correct] Login Retrieve and Logout
- (void)testLoginRetrieveAndLogout {
    XCTestExpectation *expectation = [self expectationWithDescription:@"api call will finish"];

    [Tapglue createAndLoginUserWithEmail:TGTestUserEmail andPassword:TGTestPassword withCompletionBlock:^(BOOL success, NSError *error) {
        expect(success).to.beTruthy();
        expect(error).to.beNil();

        [Tapglue loginWithUsernameOrEmail:TGTestUserEmail
                              andPassword:TGTestPassword
                      withCompletionBlock:^(BOOL success, NSError *error) {

                          expect(success).to.beTruthy();
                          expect(error).to.beNil();

                          [Tapglue retrieveCurrentUserWithCompletionBlock:^(TGUser *user, NSError *error) {
                              expect(user).notTo.beNil();
                              expect(error).to.beNil();
                              expect(user.email).to.equal(TGTestUserEmail);

                              [Tapglue logoutWithCompletionBlock:^(BOOL success, NSError *error) {
                                  expect(success).to.beTruthy();
                                  expect(error).to.beNil();

                                [expectation fulfill];
                                  
                              }];
                          }];
                      }];
    }];

    [self waitForExpectations];
}

// [Correct] Test login and logout for existing user
- (void)testLoginAndLogout {
    [self runTestBlockAfterLogin:^(XCTestExpectation *expectation) {
        [Tapglue retrieveCurrentUserWithCompletionBlock:^(TGUser *user, NSError *error) {
            expect(user).notTo.beNil();
            expect(error).to.beNil();
            expect(user.email).to.equal(TGPersistentUserEmail);

            [Tapglue logoutWithCompletionBlock:^(BOOL success, NSError *error) {
                expect(success).to.beTruthy();
                expect(error).to.beNil();
                [expectation fulfill];
            }];
        }];
    }];
}

#pragma mark - Negative

// [Negative] Logout for existing user
- (void)testLogoutWithoutUser {
    XCTestExpectation *expectation = [self expectationWithDescription:@"api call will finish"];
    [Tapglue createAndLoginUserWithEmail:TGTestUserEmail andPassword:TGTestPassword withCompletionBlock:^(BOOL success, NSError *error) {
        expect(success).to.beTruthy();
        expect(error).to.beNil();

        // Delete User
        [[TGUser currentUser] deleteWithCompletionBlock:^(BOOL success, NSError *error) {
            // Delete Current User if existing

            [Tapglue logoutWithCompletionBlock:^(BOOL success, NSError *error) {
                expect(success).to.beFalsy();
                expect(error).to.beTruthy();

                [expectation fulfill];
            }];
        }];
    }];
    [self waitForExpectations];
}

#pragma mark - Search User -

#pragma mark - Correct

// [Correct] Search user with keyword with results
- (void)testUserSearchWithResults {
    [self runTestBlockAfterLogin:^(XCTestExpectation *expectation) {
        NSString *searchInput = @"demo";

        [Tapglue searchUsersWithTerm:searchInput andCompletionBlock:^(NSArray *users, NSError *error) {
            expect(users).to.beKindOf([NSArray class]);
            for (TGUser *user in users) {
                expect(user).to.beKindOf([TGUser class]);
                expect(user.jsonDictionary.description.lowercaseString).to.contain(searchInput.lowercaseString);
            }
            [expectation fulfill];
        }];
    }];
}

// [Correct] Search user with keyword without results
- (void)testUserSearchWithoutResults {
    [self runTestBlockAfterLogin:^(XCTestExpectation *expectation) {
        NSString *searchInput = @"totallyRandomKeyword";

        [Tapglue searchUsersWithTerm:searchInput andCompletionBlock:^(NSArray *users, NSError *error) {
            expect(users).to.beKindOf([NSArray class]);
            expect(users.count).to.equal(0);

            for (TGUser *user in users) {
                expect(user).to.beKindOf([TGUser class]);
                expect(user.jsonDictionary.description.lowercaseString).to.contain(searchInput.lowercaseString);
            }
            [expectation fulfill];
        }];
    }];
}

- (void)testUserSearchWithEmails {
    [self runTestBlockAfterLogin:^(XCTestExpectation *expectation) {
        NSArray *emails = @[@"1@tapgleu.com", @"asdf@tapglue.com"];
        [Tapglue searchUsersWithEmails:emails andCompletionBlock:^(NSArray *users, NSError *error) {
            expect(error).to.beNil();
            expect(users.count).to.beGreaterThanOrEqualTo(0);
            [expectation fulfill];
        }];
    }];
}

- (void)testSearchUsersByEmails {
    [self runTestBlockAfterLogin:^(XCTestExpectation *expectation) {
        
        [Tapglue loginWithUsernameOrEmail:TGSearchTerm andPassword:TGPersistentPassword withCompletionBlock:^(BOOL success, NSError *error) {
            expect(error).to.beNil();
            expect(success).to.beTruthy();
            
            NSArray *emails = @[TGPersistentUserEmail, @"anotherUser@mail.com", @"yetanotherUser@mail.com"];
            
            [Tapglue searchUsersWithEmails:emails andCompletionBlock:^(NSArray *users, NSError *error) {
                expect(users.count).to.beGreaterThanOrEqualTo(1);
                expect(users).toNot.beNil();
                expect(error).to.beNil();
                [expectation fulfill];
            }];
        }];
        
        
    }];
}

- (void)testSearchUsersByEmailWithVeryLongQuery {
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"test will fail"];
    
    NSMutableArray *emails = [NSMutableArray arrayWithObjects:@"TGTestUser14@tapglue.com", nil];
    for (int i = 0; i < 3000; i++) {
        [emails addObject:@"user@email.com"];
    }
    
    [Tapglue searchUsersWithEmails:emails andCompletionBlock:^(NSArray *users, NSError *error) {
        expect(error).notTo.beNil();
        
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:30.0 handler:^(NSError *error) {
        if(error) {
            XCTFail(@"Expectation Failed with error: %@", error);
        }
    }];
}

- (void)testSearchUsersBySocialIds {
    [self runTestBlockAfterLogin:^(XCTestExpectation *expectation) {
        
        TGUser *user = [TGUser new];
        user.username = @"Testuserftw";
        [user setSocialId:@"fb12345" forKey:@"facebook"];
        [user setPassword:@"password"];
        
        
        [Tapglue createAndLoginUser:user withCompletionBlock:^(BOOL success, NSError *error) {
            expect(error).to.beNil();
            expect(success).to.beTruthy();
            
            [Tapglue loginWithUsernameOrEmail:TGSearchTerm andPassword:TGPersistentPassword withCompletionBlock:^(BOOL success, NSError *error) {
                expect(error).to.beNil();
                expect(success).to.beTruthy();
                
                NSArray *socialIds = @[@"fb12345"];
                
                [Tapglue searchUsersOnSocialPlatform:@"facebook" withSocialUsersIds:socialIds andCompletionBlock:^(NSArray *users, NSError *error) {
                    expect(users.count).to.beGreaterThanOrEqualTo(1);
                    expect(users).toNot.beNil();
                    expect(error).to.beNil();
                    [expectation fulfill];
                }];
            }];
        }];
    }];
}


// [Correct] Test for isCurrentUser
- (void)testIsCurrentUserAfterLogin {
    [self runTestBlockAfterLogin:^(XCTestExpectation *expectation) {
        expect([TGUser currentUser].isCurrentUser).to.beTruthy;
        [expectation fulfill];
    }];
}

#pragma mark - Negative

// [Negative] Search user with to short keyword
- (void)testUserSearchShortOne {
    [self runTestBlockAfterLogin:^(XCTestExpectation *expectation) {
        NSString *searchInput = @"a";
        [Tapglue searchUsersWithTerm:searchInput andCompletionBlock:^(NSArray *users, NSError *error) {

            expect(error).to.beTruthy();
            expect(users).to.beNil();

            [expectation fulfill];
        }];
    }];
}

// [Negative] Search user with to short keyword
- (void)testUserSearchShortTwo {
    [self runTestBlockAfterLogin:^(XCTestExpectation *expectation) {
        NSString *searchInput = @"ab";
        [Tapglue searchUsersWithTerm:searchInput andCompletionBlock:^(NSArray *users, NSError *error) {

            expect(error).to.beTruthy();
            expect(users).to.beNil();

            [expectation fulfill];
        }];
    }];
}

#pragma mark - Other User Test -

#pragma mark - Correct

// [Correct] Cretae User with Rest Method
- (void)testCreateUserWithRestMethod {
    [self runTestBlockAfterLogin:^(XCTestExpectation *expectation) {

        TGUser *user = [TGUser new];
        user.username =  [NSString randomStringWithLength:10];
        [user setPassword:[NSString randomStringWithLength:10]];
        
        [Tapglue makeRestRequestWithHTTPMethod:@"POST" atEndPoint:@"users" withURLParameters:nil andPayload:user.jsonDictionary andCompletionBlock:^(NSDictionary *jsonResponse, NSError *error) {
            expect(jsonResponse).toNot.beNil();
            expect(error).to.beNil();
            [expectation fulfill];
        }];
    }];
}

#pragma mark - User Recommendation Tests -
// [Correct] Retrieve user recommendations
- (void)testRetrieveUserRecommendations {
    [self runTestBlockAfterLogin:^(XCTestExpectation *expectation) {
        
        [Tapglue retrieveUserRecommendationsOfType:TGUserRecommendationsTypeActive forPeriod:TGUserRecommendationsPeriodDay andCompletionBlock:^(NSArray *users, NSError *error) {
            expect(users).toNot.beNil();
            expect(error).to.beNil();
            [expectation fulfill];
        }];
    }];
}

// [Correct] Retrieve user recommendations convenience
- (void)testRetrieveUserRecommendationsConvenient {
    [self runTestBlockAfterLogin:^(XCTestExpectation *expectation) {
        
        [Tapglue retrieveUserRecommendationsWithCompletionBlock:^(NSArray *users, NSError *error) {
            expect(users).toNot.beNil();
            expect(error).to.beNil();
            [expectation fulfill];
        }];
    }];
}

// [Correct] Test follower counts
- (void)testRetrieveUserFollowerCounts {
    [self runTestBlockAfterLogin:^(XCTestExpectation *expectation) {
        
        NSLog(@"Before");
        NSLog(@"%ld", (long)[TGUser currentUser].followingCount);
        NSLog(@"%ld", (long)[TGUser currentUser].followersCount);
        
        [Tapglue retrieveCurrentUserWithCompletionBlock:^(TGUser *user, NSError *error) {
            NSLog(@"Initial Retrieve");
            NSLog(@"%ld", (long)[TGUser currentUser].followingCount);
            NSLog(@"%ld", (long)[TGUser currentUser].followersCount);
            
            [Tapglue searchUsersWithTerm:@"Brady" andCompletionBlock:^(NSArray *users, NSError *error) {
                    
                [Tapglue followUser:users.firstObject withCompletionBlock:^(BOOL success, NSError *error) {
                    NSLog(@"After follow");
                    NSLog(@"%ld", (long)[TGUser currentUser].followingCount);
                    NSLog(@"%ld", (long)[TGUser currentUser].followersCount);
                    
                    [Tapglue retrieveCurrentUserWithCompletionBlock:^(TGUser *user, NSError *error) {
                        NSLog(@"After follow and retrieve");
                        NSLog(@"%ld", (long)[TGUser currentUser].followingCount);
                        NSLog(@"%ld", (long)[TGUser currentUser].followersCount);
                        
                        [Tapglue searchUsersWithTerm:@"Brady" andCompletionBlock:^(NSArray *userz, NSError *error) {
                        
                            [Tapglue unfollowUser:userz.firstObject withCompletionBlock:^(BOOL success, NSError *error) {
                            NSLog(@"After unfollow");
                            NSLog(@"%ld", (long)[TGUser currentUser].followingCount);
                            NSLog(@"%ld", (long)[TGUser currentUser].followersCount);
                            
                                [Tapglue retrieveCurrentUserWithCompletionBlock:^(TGUser *user, NSError *error) {
                                NSLog(@"After unfollow and retrieve");
                                NSLog(@"%ld", (long)[TGUser currentUser].followingCount);
                                NSLog(@"%ld", (long)[TGUser currentUser].followersCount);
                                    
                                [expectation fulfill];
                                
                                }];
                            
                            }];
                        }];
                    }];
                }];
            }];
        }];
    }];
}

@end
