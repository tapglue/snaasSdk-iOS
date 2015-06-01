//
//  TGConnectionIntegrationTests.m
//  Tapglue Tests
//
//  Created by Onur Akpolat on 05/06/15.
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

@interface TGConnectionIntegrationTests : TGIntegrationTestCase

@end

@implementation TGConnectionIntegrationTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

#pragma mark - Create/Delete Connections -

#pragma mark - Correct

// [Correct] Create a follow connection
- (void)testCreateFollowConnection {
    [self runTestBlockAfterLogin:^(XCTestExpectation *expectation) {

        // Search User
        [Tapglue searchUsersWithTerm:TGSearchTerm andCompletionBlock:^(NSArray *users, NSError *error) {
            expect(users).toNot.beNil();
            expect(error).to.beNil();

            // Follow User
            [Tapglue followUser:users.firstObject withCompletionBlock:^(BOOL success, NSError *error) {
                expect(success).to.beTruthy();
                expect(error).to.beNil();

                // Unfollow User
                [Tapglue unfollowUser:users.firstObject withCompletionBlock:^(BOOL success, NSError *error) {
                    expect(success).to.beTruthy();
                    expect(error).to.beNil();

                    [expectation fulfill];
                }];
            }];
        }];
    }];
}

// [Correct] Create a friend connection
- (void)testCreateFriendConnection {
    [self runTestBlockAfterLogin:^(XCTestExpectation *expectation) {

        // Search User
        [Tapglue searchUsersWithTerm:TGSearchTerm andCompletionBlock:^(NSArray *users, NSError *error) {
            expect(users).toNot.beNil();
            expect(error).to.beNil();

            // Friend User
            [Tapglue friendUser:users[1] withCompletionBlock:^(BOOL success, NSError *error) {
                expect(success).to.beTruthy();
                expect(error).to.beNil();

                // Unfriend User
                [Tapglue unfriendUser:users[1] withCompletionBlock:^(BOOL success, NSError *error) {
                    expect(success).to.beTruthy();
                    expect(error).to.beNil();

                    [expectation fulfill];
                }];
            }];
        }];
    }];
}

// [Correct] Create multiple different connections
- (void)testCreateFollowAndFriendConnections {
    [self runTestBlockAfterLogin:^(XCTestExpectation *expectation) {

        // Search User
        [Tapglue searchUsersWithTerm:TGSearchTerm andCompletionBlock:^(NSArray *users, NSError *error) {
            expect(users).toNot.beNil();
            expect(error).to.beNil();

            // Follow User
            [Tapglue followUser:users.firstObject withCompletionBlock:^(BOOL success, NSError *error) {
                expect(success).to.beTruthy();
                expect(error).to.beNil();

                // Friend User
                [Tapglue friendUser:users[1] withCompletionBlock:^(BOOL success, NSError *error) {
                    expect(success).to.beTruthy();
                    expect(error).to.beNil();

                    // Unfollow User
                    [Tapglue unfollowUser:users.firstObject withCompletionBlock:^(BOOL success, NSError *error) {
                        expect(success).to.beTruthy();
                        expect(error).to.beNil();

                        // Unfriend User
                        [Tapglue unfriendUser:users[1] withCompletionBlock:^(BOOL success, NSError *error) {
                            expect(success).to.beTruthy();
                            expect(error).to.beNil();

                            [expectation fulfill];
                        }];
                    }];
                }];
            }];
        }];
    }];
}

#pragma mark - Negative

// [Negative] Create a follow connection with empty user
- (void)testCreateFollowConnectionEmptyUser {
    [self runTestBlockAfterLogin:^(XCTestExpectation *expectation) {

        TGUser *user = [[TGUser alloc] init];

        [Tapglue followUser:user withCompletionBlock:^(BOOL success, NSError *error) {
            expect(success).to.beFalsy();
            expect(error).toNot.beNil();
            expect(error.code).to.equal(kTGErrorInconsistentData);

            [expectation fulfill];
        }];
    }];
}

// [Negative] Create a friend connection with empty user
- (void)testCreateFriendConnectionEmptyUser {
    [self runTestBlockAfterLogin:^(XCTestExpectation *expectation) {

        TGUser *user = [[TGUser alloc] init];

        [Tapglue friendUser:user withCompletionBlock:^(BOOL success, NSError *error) {
            expect(success).to.beFalsy();
            expect(error).toNot.beNil();
            expect(error.code).to.equal(kTGErrorInconsistentData);

            [expectation fulfill];
        }];
    }];
}

// [Negative] Create a follow connection that already exists
- (void)testCreateFollowConnectionThatExists {
    [self runTestBlockAfterLogin:^(XCTestExpectation *expectation) {

        // Search User
        [Tapglue searchUsersWithTerm:TGSearchTerm andCompletionBlock:^(NSArray *users, NSError *error) {
            expect(users).toNot.beNil();
            expect(error).to.beNil();

            // Follow User
            [Tapglue followUser:users.firstObject withCompletionBlock:^(BOOL success, NSError *error) {
                expect(success).to.beTruthy();
                expect(error).to.beNil();

                // Follow Same User
                [Tapglue followUser:users.firstObject withCompletionBlock:^(BOOL success, NSError *error) {
                    expect(success).to.beFalsy();
                    expect(error).to.beTruthy();

                    // Unfollow
                    [Tapglue unfollowUser:users.firstObject withCompletionBlock:^(BOOL success, NSError *error) {
                        expect(success).to.beTruthy();
                        expect(error).to.beNil();

                        [expectation fulfill];
                    }];
                }];
            }];
        }];
    }];
}

// [Negative] Create a friend connection that already exists
- (void)testCreateFriendConnectionThatExists {
    [self runTestBlockAfterLogin:^(XCTestExpectation *expectation) {

        // Search User
        [Tapglue searchUsersWithTerm:TGSearchTerm andCompletionBlock:^(NSArray *users, NSError *error) {
            expect(users).toNot.beNil();
            expect(error).to.beNil();

            // Friend User
            [Tapglue friendUser:users[1] withCompletionBlock:^(BOOL success, NSError *error) {
                expect(success).to.beTruthy();
                expect(error).to.beNil();

                // Friend User
                [Tapglue friendUser:users[1] withCompletionBlock:^(BOOL success, NSError *error) {
                    expect(success).to.beFalsy();
                    expect(error).to.beTruthy();

                    // Unfriend User
                    [Tapglue unfriendUser:users[1] withCompletionBlock:^(BOOL success, NSError *error) {
                        expect(success).to.beTruthy();
                        expect(error).to.beNil();

                        [expectation fulfill];
                    }];
                }];
            }];
        }];
    }];
}

#pragma mark - Batch Create Connections -

#pragma mark - Correct

// TODO: Create batch followers
// TODO: Create batch friends

#pragma mark - Negative

// TODO: Create batch followers wrong ids
// TODO: Create friends wrong ids

#pragma mark - Connection Lists -

#pragma mark - Correct

// [Correct] Create and retrieve Follows
- (void)testCreateAndRetrieveFollows {
    [self runTestBlockAfterLogin:^(XCTestExpectation *expectation) {

        // Search User
        [Tapglue searchUsersWithTerm:TGSearchTerm andCompletionBlock:^(NSArray *users, NSError *error) {
            expect(users).toNot.beNil();
            expect(error).to.beNil();

            // Follow User
            [Tapglue followUser:users.firstObject withCompletionBlock:^(BOOL success, NSError *error) {
                expect(success).to.beTruthy();
                expect(error).to.beNil();

                // Retrieve Follows
                [Tapglue retrieveFollowsForCurrentUserWithCompletionBlock:^(NSArray *users, NSError *error) {
                    expect(error).to.beNil();
                    expect(users).toNot.beNil();
                    for(TGUser *user in users) {
                        expect(user).to.beInstanceOf([TGUser class]);
                        expect(user).to.equal(users.firstObject);
                    }

                    // Unfollow
                    [Tapglue unfollowUser:users.firstObject withCompletionBlock:^(BOOL success, NSError *error) {
                        expect(success).to.beTruthy();
                        expect(error).to.beNil();

                        [expectation fulfill];
                    }];
                }];

            }];
        }];
    }];
}

// TODO: [Correct] Create and retrieve Followers

// [Correct] Create and retrieve Friends
- (void)testCreateAndRetrieveFriends {
    [self runTestBlockAfterLogin:^(XCTestExpectation *expectation) {

        // Search User
        [Tapglue searchUsersWithTerm:TGSearchTerm andCompletionBlock:^(NSArray *users, NSError *error) {
            expect(error).to.beNil();
            expect(users).to.beKindOf([NSArray class]);
            expect(users.count).to.beGreaterThan(0);
            expect(users.firstObject).to.beKindOf([TGUser class]);

            // Friend User

            [Tapglue friendUser:users.firstObject withCompletionBlock:^(BOOL success, NSError *error) {
                expect(success).to.beTruthy();
                expect(error).to.beNil();

//                // Retrieve Friends
                [Tapglue retrieveFriendsForCurrentUserWithCompletionBlock:^(NSArray *users, NSError *error) {
                    expect(error).to.beNil();
                    expect(users).to.beKindOf([NSArray class]);
                    expect(users.count).to.equal(1);
                    for(TGUser *user in users) {
                        expect(user).to.beInstanceOf([TGUser class]);
                    }

                    // Unfriend User
                    [Tapglue unfriendUser:users.firstObject withCompletionBlock:^(BOOL success, NSError *error) {
                        expect(success).to.beTruthy();
                        expect(error).to.beNil();
//
                        [expectation fulfill];
                    }];
                }];
            }];
        }];
    }];
}

// [Correct] Retrieve Follows for User
- (void)testFollowsForCurrentUser {
    [self runTestBlockAfterLogin:^(XCTestExpectation *expectation) {
        [Tapglue retrieveFollowsForCurrentUserWithCompletionBlock:^(NSArray *users, NSError *error) {
            expect(error).to.beNil();
            expect(users).toNot.beNil();
            for(TGUser *user in users) {
                expect(user).to.beInstanceOf([TGUser class]);
            }

            [expectation fulfill];
        }];
    }];
}

// [Correct] Retrieve Followers for User
- (void)testFollowersForCurrentUser {
    [self runTestBlockAfterLogin:^(XCTestExpectation *expectation) {
        [Tapglue retrieveFollowersForCurrentUserWithCompletionBlock:^(NSArray *users, NSError *error) {
            expect(error).to.beNil();
            expect(users).toNot.beNil();
            for(TGUser *user in users) {
                expect(user).to.beInstanceOf([TGUser class]);
            }

            [expectation fulfill];
        }];
    }];
}

// [Correct] Retrieve Friend for User
- (void)testFriendsForCurrentUser {
    [self runTestBlockAfterLogin:^(XCTestExpectation *expectation) {
        [Tapglue retrieveFriendsForCurrentUserWithCompletionBlock:^(NSArray *users, NSError *error) {
            expect(error).to.beNil();
            expect(users).toNot.beNil();
            for(TGUser *user in users) {
                expect(user).to.beInstanceOf([TGUser class]);
            }

            [expectation fulfill];
        }];
    }];
}

// [Correct] Create User and Retrieve empty follows
- (void)testCreateAndRetrieveEmptyFollows {
        XCTestExpectation *expectation = [self expectationWithDescription:@"api call to finish"];

        // Create User
        [Tapglue createAndLoginUserWithUsername:TGTestUsername andPassword:TGTestPassword withCompletionBlock:^(BOOL success, NSError *error) {
            expect(success).to.beTruthy();
            expect(error).to.beNil();
            expect([TGUser currentUser]).toNot.beNil();

            [Tapglue retrieveFollowsForCurrentUserWithCompletionBlock:^(NSArray *users, NSError *error) {
                expect(users.count).to.equal(0);
                expect(error).to.beNil();

                // Delete User
                [self deleteCurrentUserWithXCTestExpectation:expectation];
            }];
        }];

        [self waitForExpectations];
}

// [Correct] Create User and Retrieve empty followers
- (void)testCreateAndRetrieveEmptyFollowers {
    XCTestExpectation *expectation = [self expectationWithDescription:@"api call to finish"];

    // Create User
    [Tapglue createAndLoginUserWithUsername:TGTestUsername andPassword:TGTestPassword withCompletionBlock:^(BOOL success, NSError *error) {
        expect(success).to.beTruthy();
        expect(error).to.beNil();
        expect([TGUser currentUser]).toNot.beNil();


        [Tapglue retrieveFollowersForCurrentUserWithCompletionBlock:^(NSArray *users, NSError *error) {
            expect(users.count).to.equal(0);
            expect(error).to.beNil();

            // Delete User
            [self deleteCurrentUserWithXCTestExpectation:expectation];
        }];
    }];

    [self waitForExpectations];
}

// [Correct] Create User and Retrieve empty friends
- (void)testCreateAndRetrieveEmptyFriends {
    XCTestExpectation *expectation = [self expectationWithDescription:@"api call to finish"];

    // Create User
    [Tapglue createAndLoginUserWithUsername:TGTestUsername andPassword:TGTestPassword withCompletionBlock:^(BOOL success, NSError *error) {
        expect(success).to.beTruthy();
        expect(error).to.beNil();
        expect([TGUser currentUser]).toNot.beNil();


        [Tapglue retrieveFriendsForCurrentUserWithCompletionBlock:^(NSArray *users, NSError *error) {
            expect(users.count).to.equal(0);
            expect(error).to.beNil();

            // Delete User
            [self deleteCurrentUserWithXCTestExpectation:expectation];
        }];
    }];

    [self waitForExpectations];
}

#pragma mark - Negative

// [Negative] Logout and Retrieve follows
- (void)testRetrieveFollowsAfterLogout {
    [self runTestBlockAfterLogin:^(XCTestExpectation *expectation) {

        //Logout User
        [Tapglue logoutWithCompletionBlock:^(BOOL success, NSError *error) {
            expect(success).to.beTruthy();
            expect(error).to.beNil();

            // Retrieve Follows
            [Tapglue retrieveFollowersForCurrentUserWithCompletionBlock:^(NSArray *users, NSError *error) {
                expect(users.count).to.equal(0);
                expect(error).toNot.beNil();

                [expectation fulfill];
            }];
        }];
    }];
}

// [Negative] Logout and Retrieve followers
- (void)testRetrieveFollowersAfterLogout {
    [self runTestBlockAfterLogin:^(XCTestExpectation *expectation) {

        //Logout User
        [Tapglue logoutWithCompletionBlock:^(BOOL success, NSError *error) {
            expect(success).to.beTruthy();
            expect(error).to.beNil();

            // Retrieve Followers
            [Tapglue retrieveFollowersForCurrentUserWithCompletionBlock:^(NSArray *users, NSError *error) {
                expect(users.count).to.equal(0);
                expect(error).toNot.beNil();

                [expectation fulfill];
            }];
        }];
    }];
}

// [Negative] Logout and Retrieve friends
- (void)testRetrieveFriendsAfterLogout {
    [self runTestBlockAfterLogin:^(XCTestExpectation *expectation) {

        //Logout User
        [Tapglue logoutWithCompletionBlock:^(BOOL success, NSError *error) {
            expect(success).to.beTruthy();
            expect(error).to.beNil();

            // Retrieve friends
            [Tapglue retrieveFriendsForCurrentUserWithCompletionBlock:^(NSArray *users, NSError *error) {
                expect(users.count).to.equal(0);
                expect(error).toNot.beNil();

                [expectation fulfill];
            }];
        }];
    }];
}

@end
