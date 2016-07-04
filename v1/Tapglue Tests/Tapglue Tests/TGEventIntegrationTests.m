//
//  TGEventIntegrationTests.m
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
#import "TGEventManager.h"
#import "Tapglue+Private.h"
#import "NSString+TGRandomString.h"

@interface TGEventIntegrationTests : TGIntegrationTestCase

@end

@implementation TGEventIntegrationTests

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
    
    [self waitForExpectationsWithTimeout:30.0 handler:^(NSError *error) {
        if(error) {
            XCTFail(@"Expectation Failed with error: %@", error);
        }
    }];
    
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
    
    [Tapglue loginWithUsernameOrEmail:TGPersistentUserEmail andPassword:TGPersistentPassword withCompletionBlock:^(BOOL success, NSError *error) {
        expect(success).will.beTruthy();
        expect(error).will.beNil();
        
        TGUser *currentBUser = [TGUser currentUser];
        [currentBUser deleteWithCompletionBlock:^(BOOL success, NSError *error) {
            expect(success).will.beTruthy();
            expect(error).will.beNil();
            expect([TGUser currentUser]).to.beNil();
            
            [Tapglue loginWithUsernameOrEmail:TGSearchTerm andPassword:TGPersistentPassword withCompletionBlock:^(BOOL success, NSError *error) {
                expect(success).will.beTruthy();
                expect(error).will.beNil();
                
                TGUser *currentBUser = [TGUser currentUser];
                [currentBUser deleteWithCompletionBlock:^(BOOL success, NSError *error) {
                    expect(success).will.beTruthy();
                    expect(error).will.beNil();
                    expect([TGUser currentUser]).to.beNil();
                }];
            }];
        }];
    }];
}

#pragma mark - CRUD Event -

#pragma mark - Correct

// [Correct] Create Event with Type
- (void)testCreateEventWithType {
    [self runTestBlockAfterLogin:^(XCTestExpectation *expectation) {

        // Create Event
        [Tapglue createEventWithType:@"like" withCompletionBlock:^(BOOL success, NSError *error) {
            expect(success).to.beTruthy();
            expect(error).to.beNil();

            [expectation fulfill];
        }];
    }];
}

// [Correct] Create Event with Type and ObjectID
- (void)testCreateEventWithTypeAndObjectID {
    [self runTestBlockAfterLogin:^(XCTestExpectation *expectation) {

        // Create Event
        [Tapglue createEventWithTypeAndObjectId:@"like" andObjectId:@"article_123" withCompletionBlock:^(BOOL success, NSError *error) {
            expect(success).to.beTruthy();
            expect(error).to.beNil();

            [expectation fulfill];
        }];
    }];
}

// [Correct] Create Event with complete data TGEvent
- (void)testCreateEventWithTGEventComplete {
    [self runTestBlockAfterLogin:^(XCTestExpectation *expectation) {

        TGEvent *event = [[TGEvent alloc] init];
        event.type = @"like";
        event.language = @"en";
        event.priority = @"high";
        event.location = @"berlin";
        event.latitude = 52.520007;
        event.longitude = 13.404954;
        event.tgObjectId = @"1223423";

        TGEventObject *object = [TGEventObject new];

        object.objectId = @"a1b2c3";
        object.type = @"movie";
        object.url = @"app://tapglue.com/objects/1";
        [object setDisplayName:@"good movie" forLanguage:@"en"];
        [object setDisplayName:@"guter film" forLanguage:@"de"];

        event.object = object;

        event.metadata = @{
                           @"foo" : @"bar",
                           @"amount" : @12,
                           @"progress" : @0.95
                           };

        expect(event.eventId).to.beNil();
        expect(event.createdAt).toNot.beNil();

        [Tapglue createEvent:event withCompletionBlock:^(BOOL success, NSError *error) {
            expect(success).to.beTruthy();
            expect(error).to.beNil();
            
            [expectation fulfill];
        }];
//        // Create Event
//        [Tapglue createEvent:event withCompletionBlock:^(BOOL success, NSError *error) {
//            expect(success).to.beTruthy();
//            expect(error).to.beNil();
//
//            expect(event.type).to.equal(@"like");
//            expect(event.language).to.equal(@"en");
//            expect(event.priority).to.equal(@"high");
//            expect(event.location).to.equal(@"berlin");
//            expect(event.object.objectId).to.equal(@"a1b2c3");
//            expect(event.object.type).to.equal(@"movie");
//            expect(event.object.url).to.equal(@"app://tapglue.com/objects/1");
//            expect([event.object displayNameForLanguage:@"en"]).to.equal(@"good movie");
//            expect([event.object displayNameForLanguage:@"de"]).to.equal(@"guter film");
//
//            expect([event.metadata objectForKey:@"foo"]).to.equal(@"bar");
//            expect([event.metadata objectForKey:@"amount"]).to.equal(12);
//            expect([event.metadata objectForKey:@"progress"]).to.equal(0.95);
//
//            [Tapglue deleteEventWithId:event.eventId withCompletionBlock:^(BOOL success, NSError *error) {
//                expect(success).to.beTruthy();
//                expect(error).to.beNil();
//                [expectation fulfill];
//            }];
//        }];
    }];
}

// [Correct] Create Event with minimal data TGEvent
- (void)testCreateEventWithTGEventMinimal {
    [self runTestBlockAfterLogin:^(XCTestExpectation *expectation) {

        TGEvent *event = [[TGEvent alloc] init];
        event.type = @"like";
        event.language = @"en";

        expect(event.eventId).to.beNil();
        expect(event.createdAt).toNot.beNil();

        // Create Event
        [Tapglue createEvent:event withCompletionBlock:^(BOOL success, NSError *error) {
            expect(success).to.beTruthy();
            expect(error).to.beNil();

            expect(event.type).to.equal(@"like");
            expect(event.language).to.equal(@"en");

            [Tapglue deleteEventWithId:event.eventId withCompletionBlock:^(BOOL success, NSError *error) {
                expect(success).to.beTruthy();
                expect(error).to.beNil();
                [expectation fulfill];
            }];
        }];
    }];
}

// [Correct] Create, Update and Delete and Event
- (void)testEventsCRUD {
    [self runTestBlockAfterLogin:^(XCTestExpectation *expectation) {
        TGEvent *event = [[TGEvent alloc] init];
        event.type = @"like";

        expect(event.eventId).to.beNil();

        [Tapglue createEvent:event withCompletionBlock:^(BOOL success, NSError *error) {
            expect(success).to.beTruthy();
            expect(error).to.beNil();

            expect(event.eventId).toNot.beNil();
            expect(event.createdAt).toNot.beNil();
            
            [NSThread sleepForTimeInterval:3];
            
            event.type = @"changed";
            
            // Update event
            [Tapglue updateEvent:event withCompletionBlock:^(BOOL success, NSError *error) {
                expect(success).to.beTruthy();
                expect(error).to.beNil();
                
                [Tapglue deleteEventWithId:event.eventId withCompletionBlock:^(BOOL success, NSError *error) {
                    expect(success).to.beTruthy();
                    expect(error).to.beNil();
                    [expectation fulfill];
                }];
            }];
        }];
    }];
}

// [Correct] Create and Update Event with complete data TGEvent
- (void)testCreateAndUpdateEventWithTGEventComplete {
    [self runTestBlockAfterLogin:^(XCTestExpectation *expectation) {

        TGEvent *event = [[TGEvent alloc] init];
        event.type = @"like";
        event.language = @"en";
        event.priority = @"high";
        event.location = @"berlin";
        event.latitude = 52.520007;
        event.longitude = 13.404954;

        TGEventObject *object = [TGEventObject new];

        object.objectId = @"a1b2c3";
        object.type = @"movie";
        object.url = @"app://tapglue.com/objects/1";
        [object setDisplayName:@"good movie" forLanguage:@"en"];
        [object setDisplayName:@"guter film" forLanguage:@"de"];

        event.object = object;

        event.metadata = @{
                           @"foo" : @"bar",
                           @"amount" : @12,
                           @"progress" : @0.95
                           };

        expect(event.eventId).to.beNil();
        expect(event.createdAt).toNot.beNil();

        // Create Event
        [Tapglue createEvent:event withCompletionBlock:^(BOOL success, NSError *error) {
            expect(success).to.beTruthy();
            expect(error).to.beNil();

            event.location = @"newLocation";

            // Update Event
            [Tapglue updateEvent:event withCompletionBlock:^(BOOL success, NSError *error) {
                event.location = @"newLocation";

                [Tapglue deleteEventWithId:event.eventId withCompletionBlock:^(BOOL success, NSError *error) {
                    expect(success).to.beTruthy();
                    expect(error).to.beNil();
                    [expectation fulfill];
                }];
            }];
        }];
    }];
}


// [Correct] Create and Retrieve Event with Type for current user
- (void)testCreateAndRetrieveEventWithTGEvent {
    [self runTestBlockAfterLogin:^(XCTestExpectation *expectation) {

        TGEvent *event = [[TGEvent alloc] init];
        event.type = @"like";
        event.language = @"en";

        expect(event.eventId).to.beNil();

        //NSDate *startedAt = [NSDate dateWithTimeIntervalSinceNow:-1];

        // Create Event
        [Tapglue createEvent:event withCompletionBlock:^(BOOL success, NSError *error) {
            expect(success).to.beTruthy();
            expect(error).to.beNil();
            expect(event.eventId).toNot.beNil();
            
            [NSThread sleepForTimeInterval:3];
            
            // FIXME: Martin
            [Tapglue retrieveEventForCurrentUserWithId:event.eventId withCompletionBlock:^(TGEvent *event, NSError *error) {
                expect(error).to.beNil();
                expect(event).toNot.beNil();
                expect(event.type).to.equal(@"like");
                expect(event.language).to.equal(@"en");
//                expect(event.updatedAt).to.beGreaterThan(startedAt);

                [Tapglue deleteEventWithId:event.eventId withCompletionBlock:^(BOOL success, NSError *error) {
                    expect(success).to.beTruthy();
                    expect(error).to.beNil();
                    [expectation fulfill];
                }];
            }];
        }];
    }];
}



// [Correct] Create and Retrieve Event with Type for current user
- (void)testCreateAndRetrieveEventWithTGLikeEvent {
    [self runTestBlockAfterLogin:^(XCTestExpectation *expectation) {
        
        // Create TGPost Object
        TGPost *post = [TGPost new];
        post.visibility = TGVisibilityPublic;
        post.tags = @[@"fitness",@"running"];
        
        [post addAttachment:[TGAttachment attachmentWithText:@"This is the Text of the Post." andName:@"body"]];
        
        // Create Post
        [Tapglue createPost:post withCompletionBlock:^(BOOL success, NSError *error) {
            expect(success).to.beTruthy();
            expect(error).to.beNil();
            
            [post likeWithCompletionBlock:^(BOOL success, NSError *error) {
                expect(success).to.beTruthy();
                [Tapglue retrieveEventsForCurrentUserOfType:@"tg_like" withCompletionBlock:^(NSArray *events, NSError *error) {
                    expect(events).notTo.beNil();
                    expect(events.count).to.equal(1);
                    TGEvent* event = events[0];
                    expect(event.post.objectId).to.equal(post.objectId);
                    expect(event.post.user.userId).to.equal(post.user.userId);
                    
                    for(TGEvent* event in events) {
                        [Tapglue deleteEventWithId:event.eventId withCompletionBlock:^(BOOL success, NSError *error) {
                            expect(success).to.beTruthy();
                        }];
                    }
                    
                    // Delete Post
                    [Tapglue deletePostWithId:post.objectId withCompletionBlock:^(BOOL success, NSError *error) {
                        expect(success).to.beTruthy();
                        expect(error).to.beNil();
                        
                        [expectation fulfill];
                    }];

                }];
            }];
        }];
    }];
}

// [Correct] Create and Delete Event
- (void)testCreateAndDeleteTGEvent {
    [self runTestBlockAfterLogin:^(XCTestExpectation *expectation) {

        TGEvent *event = [[TGEvent alloc] init];
        event.type = @"like";
        event.language = @"en";

        expect(event.eventId).to.beNil();
        expect(event.createdAt).toNot.beNil();

        // Create Event
        [Tapglue createEvent:event withCompletionBlock:^(BOOL success, NSError *error) {
            expect(success).to.beTruthy();
            expect(error).to.beNil();

            // Create second event
            TGEvent *event2 = [[TGEvent alloc] init];
            event2.type = @"like";
            event2.language = @"en";

            [Tapglue createEvent:event2 withCompletionBlock:^(BOOL success, NSError *error) {
                expect(success).to.beTruthy();
                expect(error).to.beNil();

                [Tapglue deleteEventWithId:event.eventId withCompletionBlock:^(BOOL success, NSError *error) {
                    expect(success).to.beTruthy();
                    expect(error).to.beNil();

                    [Tapglue deleteEventWithId:event2.eventId withCompletionBlock:^(BOOL success, NSError *error) {
                        expect(success).to.beTruthy();
                        expect(error).to.beNil();
                        [expectation fulfill];
                    }];

                }];
            }];
        }];
    }];
}

// [Correct] Create Event with Type and Wrong ObjectID
- (void)testCreateEventWithTypeAndWrongObjectID {
    [self runTestBlockAfterLogin:^(XCTestExpectation *expectation) {

        // Create Event
        [Tapglue createEventWithTypeAndObjectId:@"like" andObjectId:@"" withCompletionBlock:^(BOOL success, NSError *error) {
            expect(success).to.beTruthy();
            expect(error).to.beFalsy();

            [expectation fulfill];
        }];
    }];
}

#pragma mark - Negative

// [Negative] Create Event with Wrong Type (too short)
- (void)testCreateEventWithWrongTypeShort {
    [self runTestBlockAfterLogin:^(XCTestExpectation *expectation) {

        // Create Event
        [Tapglue createEventWithType:@"" withCompletionBlock:^(BOOL success, NSError *error) {
            expect(success).to.beFalsy();
            expect(error).to.beTruthy();

            [expectation fulfill];
        }];
    }];
}

// [Negative] Create Event with NULL as type
- (void)testCreateEventNULL {
    [self runTestBlockAfterLogin:^(XCTestExpectation *expectation) {

        TGEvent *event = [[TGEvent alloc] init];
        event.type = NULL;

        expect(event.eventId).to.beNil();
        expect(event.createdAt).toNot.beNil();


        // Create Event
        [Tapglue createEvent:event withCompletionBlock:^(BOOL success, NSError *error) {
            expect(success).to.beFalsy();
            expect(error).to.beTruthy();

            [expectation fulfill];
        }];
    }];
}

// [Negative] Create Event without data
- (void)testCreateEventNoData {
    [self runTestBlockAfterLogin:^(XCTestExpectation *expectation) {

        TGEvent *event = [[TGEvent alloc] init];

        expect(event.eventId).to.beNil();
        expect(event.createdAt).toNot.beNil();


        // Create Event
        [Tapglue createEvent:event withCompletionBlock:^(BOOL success, NSError *error) {
            expect(success).to.beFalsy();
            expect(error).to.beTruthy();

            [expectation fulfill];
        }];
    }];
}

// [Negative] Create Event after logout
- (void)testCreateEventAfterLogout {
    [self runTestBlockAfterLogin:^(XCTestExpectation *expectation) {

        TGEvent *event = [[TGEvent alloc] init];
        event.type = @"like";
        event.language = @"en";

        expect(event.eventId).to.beNil();
        expect(event.createdAt).toNot.beNil();

        // Logout user

        [Tapglue logoutWithCompletionBlock:^(BOOL success, NSError *error) {
            // Create Event
            [Tapglue createEvent:event withCompletionBlock:^(BOOL success, NSError *error) {
                expect(success).to.beFalsy();
                expect(error).to.beTruthy();

                [expectation fulfill];
            }];
        }];
    }];
}

// [Negative] Create and Update Event with wrong data
- (void)testCreateAndUpdateEventWithWrongEvent {
    [self runTestBlockAfterLogin:^(XCTestExpectation *expectation) {

        TGEvent *event = [[TGEvent alloc] init];
        event.type = @"like";
        event.language = @"en";

        expect(event.eventId).to.beNil();
        expect(event.createdAt).toNot.beNil();

        // Create Event
        [Tapglue createEvent:event withCompletionBlock:^(BOOL success, NSError *error) {
            expect(success).to.beTruthy();
            expect(error).to.beNil();

            event.type = @"";

            // Update Event
            [Tapglue updateEvent:event withCompletionBlock:^(BOOL success, NSError *error) {
                expect(success).to.beFalsy();
                expect(error).to.beTruthy();

                [Tapglue deleteEventWithId:event.eventId withCompletionBlock:^(BOOL success, NSError *error) {
                    expect(success).to.beTruthy();
                    expect(error).to.beNil();
                    [expectation fulfill];
                }];
            }];
        }];
    }];
}

// [Negative] Create and Update Event without data
- (void)testCreateAndUpdateEventWithoutData {
    [self runTestBlockAfterLogin:^(XCTestExpectation *expectation) {

        TGEvent *event = [[TGEvent alloc] init];
        event.type = @"like";
        event.language = @"en";

        expect(event.eventId).to.beNil();
        expect(event.createdAt).toNot.beNil();

        // Create Event
        [Tapglue createEvent:event withCompletionBlock:^(BOOL success, NSError *error) {
            expect(success).to.beTruthy();
            expect(error).to.beNil();

            TGEvent *newEvent = [[TGEvent alloc] init];

            // Update Event
            [Tapglue updateEvent:newEvent withCompletionBlock:^(BOOL success, NSError *error) {
                expect(success).to.beFalsy();
                expect(error).to.beTruthy();
                [expectation fulfill];
            }];
        }];
    }];
}

// [Negative] Create and Update Event after logout
- (void)testCreateAndUpdateEventAfterLogout {
    [self runTestBlockAfterLogin:^(XCTestExpectation *expectation) {

        TGEvent *event = [[TGEvent alloc] init];
        event.type = @"like";
        event.language = @"en";

        expect(event.eventId).to.beNil();
        expect(event.createdAt).toNot.beNil();

        // Create Event
        [Tapglue createEvent:event withCompletionBlock:^(BOOL success, NSError *error) {
            expect(success).to.beTruthy();
            expect(error).to.beNil();

            // Logout User
            [Tapglue logoutWithCompletionBlock:^(BOOL success, NSError *error) {
                expect(success).to.beTruthy();
                expect(error).to.beNil();

                // Update Event
                [Tapglue updateEvent:event withCompletionBlock:^(BOOL success, NSError *error) {
                    expect(success).to.beFalsy();
                    expect(error).to.beTruthy();
                    [expectation fulfill];
                }];
            }];
        }];
    }];
}

// [Negative] Retrieve non-existing Event
- (void)testRetrieveNonExistingEvent {
    [self runTestBlockAfterLogin:^(XCTestExpectation *expectation) {

        // Retrieve Event
        [Tapglue retrieveEventForCurrentUserWithId:@"nonExistingEventID" withCompletionBlock:^(TGEvent *event, NSError *error) {
            expect(event).to.beNil();
            expect(error).to.beTruthy();
            [expectation fulfill];
        }];
    }];
}

// [Negative] Retrieve Event after logout
- (void)testRetrieveEventAfterLogout {
    [self runTestBlockAfterLogin:^(XCTestExpectation *expectation) {

        TGEvent *event = [[TGEvent alloc] init];
        event.type = @"like";
        event.language = @"en";

        expect(event.eventId).to.beNil();
        expect(event.createdAt).toNot.beNil();

        // Create Event
        [Tapglue createEvent:event withCompletionBlock:^(BOOL success, NSError *error) {
            expect(success).to.beTruthy();
            expect(error).to.beNil();

            // Logout User
            [Tapglue logoutWithCompletionBlock:^(BOOL success, NSError *error) {
                expect(success).to.beTruthy();
                expect(error).to.beNil();

                // Retrieve Event
                [Tapglue retrieveEventForCurrentUserWithId:event.eventId withCompletionBlock:^(TGEvent *event, NSError *error) {
                    expect(event).to.beNil();
                    expect(error).to.beKindOf([NSError class]);
                    [expectation fulfill];
                }];
            }];
        }];
    }];
}

// [Negative] Delete Event after logout
- (void)testDeleteEventAfterLogout {
    [self runTestBlockAfterLogin:^(XCTestExpectation *expectation) {

        TGEvent *event = [[TGEvent alloc] init];
        event.type = @"like";
        event.language = @"en";

        expect(event.eventId).to.beNil();
        expect(event.createdAt).toNot.beNil();

        // Create Event
        [Tapglue createEvent:event withCompletionBlock:^(BOOL success, NSError *error) {
            expect(success).to.beTruthy();
            expect(error).to.beNil();

            // Logout User
            [Tapglue logoutWithCompletionBlock:^(BOOL success, NSError *error) {
                expect(success).to.beTruthy();
                expect(error).to.beNil();

                // Delete Event
                [Tapglue deleteEventWithId:event.eventId withCompletionBlock:^(BOOL success, NSError *error) {
                    expect(success).to.beFalsy();
                    expect(error).to.beTruthy();
                    [expectation fulfill];
                }];
            }];
        }];
    }];
}

// [Negative] Delete non-existing Event
- (void)testDeleteNonExistingEvent {
    [self runTestBlockAfterLogin:^(XCTestExpectation *expectation) {

        //Delete Event
        [Tapglue deleteEventWithId:@"nonExistingID" withCompletionBlock:^(BOOL success, NSError *error) {
            expect(success).to.beFalsy();
            expect(error).to.beTruthy();
            [expectation fulfill];
        }];
    }];
}

#pragma mark - Feeds -

#pragma mark - Correct

// [Correct] Retrieve unread feed count
- (void)testFeedUnreadCount {
        [self runTestBlockAfterLogin:^(XCTestExpectation *expectation) {
            [Tapglue retrieveUnreadCountForCurrentWithCompletionBlock:^(NSInteger unreadCount, NSError *error) {
                expect(unreadCount).to.beGreaterThanOrEqualTo(0);
                expect(error).to.beNil();

                [expectation fulfill];
            }];
        }];
}

// [Correct] Retrieve unread news feed
- (void)testUnreadFeed {
    [self runTestBlockAfterLogin:^(XCTestExpectation *expectation) {
        [Tapglue retrieveUnreadNewsFeedForCurrentUserWithCompletionBlock:^(NSArray *events, NSError *error) {
            expect(events).toNot.beNil();
            expect(events.count).to.beGreaterThanOrEqualTo(0);
            expect(error).to.beNil();

            [expectation fulfill];
        }];
    }];
}

// [Corrent] Retrieve small events feed
- (void)testNewsFeedSmall {
    [self runTestBlockAfterLogin:^(XCTestExpectation *expectation) {
        
        [Tapglue retrieveNewsFeedForCurrentUserWithCompletionBlock:^(NSArray *posts, NSArray *events, NSError *error) {
            expect(events).toNot.beNil();
            expect(error).to.beNil();
            
            [expectation fulfill];
        }];
    }];
}

// [Correct] Retrieve events feed with query
- (void)testNewsFeedWithQuery {
    [self runTestBlockAfterLogin:^(XCTestExpectation *expectation) {
        
        NSString *eventType = [NSString randomStringWithLength:10];
        NSString *objectId = [NSString randomStringWithLength:5];
        
        TGEvent *event = [[TGEvent alloc] init];
        event.type = eventType;
        
        TGEventObject *object = [TGEventObject new];
        
        object.objectId = objectId;
        event.object = object;
        
        // Login Other User
        [Tapglue loginWithUsernameOrEmail:TGSearchTerm andPassword:TGPersistentPassword withCompletionBlock:^(BOOL success, NSError *error) {
            expect(success).to.beTruthy();
            expect(error).to.beNil();
            
            // Search User
            [Tapglue searchUsersWithTerm:TGPersistentUserEmail andCompletionBlock:^(NSArray *users, NSError *error) {
                expect(users).toNot.beNil();
                expect(error).to.beNil();
                
                TGUser *user = users.firstObject;
                
                // Friend User
                [Tapglue friendUser:user withState:TGConnectionStateConfirmed withCompletionBlock:^(BOOL success, NSError *error) {
                    
                    expect(success).to.beTruthy();
                    expect(error).to.beNil();
                    
                    // Create Event
                    [Tapglue createEvent:event withCompletionBlock:^(BOOL success, NSError *error) {
                        expect(success).to.beTruthy();
                        expect(error).to.beNil();
                        
                        [Tapglue loginWithUsernameOrEmail:TGPersistentUserEmail andPassword:TGPersistentPassword withCompletionBlock:^(BOOL success, NSError *error) {
                            expect(success).to.beTruthy();
                            expect(error).to.beNil();
                            
                            // Create Query Object
                            TGQuery *query = [TGQuery new];
                            [query addEventObjectWithIdEquals:objectId];
                            [query addTypeEquals:eventType];
                
                            // Retrieve Feed with Query
                            [Tapglue retrieveNewsFeedForCurrentUserWithQuery:query andCompletionBlock:^(NSArray *posts, NSArray *events, NSError *error) {
                                expect(events).toNot.beNil();
                                expect(events.count).to.beGreaterThanOrEqualTo(1);
                                expect(error).to.beNil();
                                
                                [expectation fulfill];
                            }];
                        }];
                    }];
                }];
            }];
        }];
    }];
}


// [Correct] Retrieve events feed
- (void)testEventsFeed {
    [self runTestBlockAfterLogin:^(XCTestExpectation *expectation) {
        
        NSString *eventType = [NSString randomStringWithLength:10];
        NSString *objectId = [NSString randomStringWithLength:5];
        
        TGEvent *event = [[TGEvent alloc] init];
        event.type = eventType;
        
        TGEventObject *object = [TGEventObject new];
        
        object.objectId = objectId;
        event.object = object;
        
        // Login Other User
        [Tapglue loginWithUsernameOrEmail:TGSearchTerm andPassword:TGPersistentPassword withCompletionBlock:^(BOOL success, NSError *error) {
            expect(success).to.beTruthy();
            expect(error).to.beNil();
            
            // Search User
            [Tapglue searchUsersWithTerm:TGPersistentUserEmail andCompletionBlock:^(NSArray *users, NSError *error) {
                expect(users).toNot.beNil();
                expect(error).to.beNil();
                
                TGUser *user = users.firstObject;
                
                // Friend User
                [Tapglue friendUser:user withState:TGConnectionStateConfirmed withCompletionBlock:^(BOOL success, NSError *error) {
                    
                    expect(success).to.beTruthy();
                    expect(error).to.beNil();
                    
                    // Create Event
                    [Tapglue createEvent:event withCompletionBlock:^(BOOL success, NSError *error) {
                        expect(success).to.beTruthy();
                        expect(error).to.beNil();
                        
                        [Tapglue loginWithUsernameOrEmail:TGPersistentUserEmail andPassword:TGPersistentPassword withCompletionBlock:^(BOOL success, NSError *error) {
                            expect(success).to.beTruthy();
                            expect(error).to.beNil();
                                
                                // Retrieve Feed
                                [Tapglue retrieveEventsFeedForCurrentUserWithCompletionBlock:^(NSArray *events, NSInteger unreadCount, NSError *error) {
                                    expect(events).toNot.beNil();
                                    expect(events.count).to.beGreaterThanOrEqualTo(0);
                                    expect(unreadCount).to.beGreaterThanOrEqualTo(0);
                                    expect(error).to.beNil();
                                    
                                    [expectation fulfill];
                                }];
                        }];
                    }];
                }];
            }];
        }];
    }];
}

// [Correct] Retrieve events for type
- (void)testRetrieveEventsOfType {
    [self runTestBlockAfterLogin:^(XCTestExpectation *expectation) {
        
        NSString *eventType = [NSString randomStringWithLength:10];
        
        // Create Event
        [Tapglue createEventWithType:eventType withCompletionBlock:^(BOOL success, NSError *error) {
            expect(success).to.beTruthy();
            expect(error).to.beNil();
            
            [Tapglue retrieveEventsForCurrentUserOfType:eventType withCompletionBlock:^(NSArray *events, NSError *error) {
                expect(events).toNot.beNil();
                expect(error).to.beNil();
                expect(events.count).to.beGreaterThanOrEqualTo(1);
                
                [Tapglue retrieveEventsOfType:eventType withCompletionBlock:^(NSArray *events, NSError *error) {
                    expect(events).toNot.beNil();
                    expect(error).to.beNil();
                    expect(events.count).to.beGreaterThanOrEqualTo(1);
                    
                    [expectation fulfill];
                }];
            }];
        }];
    }];
}

// [Correct] Retrieve events for objectid
- (void)testRetrieveEventsForObjectId {
    [self runTestBlockAfterLogin:^(XCTestExpectation *expectation) {
        NSString *eventType = [NSString randomStringWithLength:10];
        NSString *objectId = [NSString randomStringWithLength:5];
        
        TGEvent *event = [[TGEvent alloc] init];
        event.type = eventType;
        
        TGEventObject *object = [TGEventObject new];
        
        object.objectId = objectId;
        event.object = object;
        
        //Create Event
        [Tapglue createEvent:event withCompletionBlock:^(BOOL success, NSError *error) {
            expect(success).to.beTruthy();
            expect(error).to.beNil();
            
            [Tapglue  retrieveEventsForObjectId:objectId withCompletionBlock:^(NSArray *events, NSError *error) {
                expect(events).toNot.beNil();
                expect(error).to.beNil();
                
                expect(events.count).to.equal(1);
                
                [Tapglue retrieveEventsForCurrentUserForObjectId:objectId withCompletionBlock:^(NSArray *events, NSError *error) {
                    expect(events).toNot.beNil();
                    expect(error).to.beNil();
                    
                    expect(events.count).to.equal(1);
                    
                    [expectation fulfill];
                }];
            }];
        }];
    }];
}

// [Correct] Retrieve events for type and id
- (void)testRetrieveEventsOfTypeAndObjectId {
    [self runTestBlockAfterLogin:^(XCTestExpectation *expectation) {
        
        NSString *eventType = [NSString randomStringWithLength:10];
        NSString *objectId = [NSString randomStringWithLength:5];
        
        TGEvent *event = [[TGEvent alloc] init];
        event.type = eventType;
        
        TGEventObject *object = [TGEventObject new];
        
        object.objectId = objectId;
        event.object = object;
        
        // Create Event
        [Tapglue createEvent:event withCompletionBlock:^(BOOL success, NSError *error) {
            expect(success).to.beTruthy();
            expect(error).to.beNil();
            [Tapglue retrieveEventsForCurrentUserForObjectWithId:objectId andEventType:eventType withCompletionBlock:^(NSArray *events, NSError *error) {
                expect(events).toNot.beNil();
                expect(error).to.beNil();
                
                expect(events.count).to.equal(1);
                
                [Tapglue retrieveEventsForObjectWithId:objectId andEventType:eventType withCompletionBlock:^(NSArray *events, NSError *error) {
                    expect(events).toNot.beNil();
                    expect(error).to.beNil();
                    
                    expect(events.count).to.equal(1);
                    [expectation fulfill];
                    
                }];
            }];
        }];
    }];
}

// [Correct] Retrieve events for query object
- (void)testRetrieveEventsForQueryObject {
    [self runTestBlockAfterLogin:^(XCTestExpectation *expectation) {
        
        NSString *eventType = [NSString randomStringWithLength:10];
        NSString *objectId = [NSString randomStringWithLength:5];
        
        TGEvent *event = [[TGEvent alloc] init];
        event.type = eventType;
        
        TGEventObject *object = [TGEventObject new];
        
        object.objectId = objectId;
        event.object = object;
        
        // Login Other User
        [Tapglue loginWithUsernameOrEmail:TGSearchTerm andPassword:TGPersistentPassword withCompletionBlock:^(BOOL success, NSError *error) {
            expect(success).to.beTruthy();
            expect(error).to.beNil();
            
            // Search User
            [Tapglue searchUsersWithTerm:TGPersistentUserEmail andCompletionBlock:^(NSArray *users, NSError *error) {
                expect(users).toNot.beNil();
                expect(error).to.beNil();
                
                TGUser *user = users.firstObject;
                
                // Friend User
                [Tapglue friendUser:user withState:TGConnectionStateConfirmed withCompletionBlock:^(BOOL success, NSError *error) {
                    
                    expect(success).to.beTruthy();
                    expect(error).to.beNil();
                    
                    // Create Event
                    [Tapglue createEvent:event withCompletionBlock:^(BOOL success, NSError *error) {
                        expect(success).to.beTruthy();
                        expect(error).to.beNil();
                        
                        [Tapglue loginWithUsernameOrEmail:TGPersistentUserEmail andPassword:TGPersistentPassword withCompletionBlock:^(BOOL success, NSError *error) {
                            expect(success).to.beTruthy();
                            expect(error).to.beNil();
                            
                            TGEvent *newEvent = [[TGEvent alloc] init];
                            newEvent.type = eventType;
                            newEvent.object = object;
                            
                            // Create Event
                            [Tapglue createEvent:newEvent withCompletionBlock:^(BOOL success, NSError *error) {
                                expect(success).to.beTruthy();
                                expect(error).to.beNil();
                                
                                // Create Query Object
                                TGQuery *query = [TGQuery new];
                                [query addEventObjectWithIdEquals:objectId];
                                [query addTypeEquals:eventType];
                                
                                // Retrieve Events with Query
                                [Tapglue retrieveEventsWithQuery:query andCompletionBlock:^(NSArray *events, NSError *error) {
                                    expect(events).toNot.beNil();
                                    expect(error).to.beNil();
                                    
                                    // Retrieve me events with Query
                                    [Tapglue retrieveEventsForCurrentUserWithQuery:query andCompletionBlock:^(NSArray *events, NSError *error) {
                                        expect(events).toNot.beNil();
                                        expect(error).to.beNil();
                                        
                                        TGEvent *retrievedEvent = events.firstObject;
                                        expect(retrievedEvent.type).to.equal(eventType);
                                        
                                        [Tapglue retrieveEventsWithQuery:query andCompletionBlock:^(NSArray *events, NSError *error) {
                                            expect(events).toNot.beNil();
                                            expect(error).to.beNil();
                                            
                                            TGEvent *retrievedEvent = events.lastObject;
                                            expect(retrievedEvent.type).to.equal(eventType);
                                            
                                            [expectation fulfill];
                                        }];
                                    }];
                                }];
                            }];
                        }];
                    }];
                }];
            }];
        }];
    }];
}

// [Correct] Retrieve feed for a set of event types
- (void)testRetrieveFeedForSetOfEventTypes {
    [self runTestBlockAfterLogin:^(XCTestExpectation *expectation) {
        
        NSString *eventType = [NSString randomStringWithLength:10];
        NSString *objectId = [NSString randomStringWithLength:5];
        
        TGEvent *event = [[TGEvent alloc] init];
        event.type = eventType;
        
        TGEventObject *object = [TGEventObject new];
        
        object.objectId = objectId;
        event.object = object;
        
        // Login Other User
        [Tapglue loginWithUsernameOrEmail:TGSearchTerm andPassword:TGPersistentPassword withCompletionBlock:^(BOOL success, NSError *error) {
            expect(success).to.beTruthy();
            expect(error).to.beNil();
            
            // Search User
            [Tapglue searchUsersWithTerm:TGPersistentUserEmail andCompletionBlock:^(NSArray *users, NSError *error) {
                expect(users).toNot.beNil();
                expect(error).to.beNil();
                
                TGUser *user = users.firstObject;
                
                // Friend User
                [Tapglue friendUser:user withState:TGConnectionStateConfirmed withCompletionBlock:^(BOOL success, NSError *error) {
                    
                    expect(success).to.beTruthy();
                    expect(error).to.beNil();
                    
                    // Create Event
                    [Tapglue createEvent:event withCompletionBlock:^(BOOL success, NSError *error) {
                        expect(success).to.beTruthy();
                        expect(error).to.beNil();
                        
                        [Tapglue loginWithUsernameOrEmail:TGPersistentUserEmail andPassword:TGPersistentPassword withCompletionBlock:^(BOOL success, NSError *error) {
                            expect(success).to.beTruthy();
                            expect(error).to.beNil();
                            
                            TGEvent *newEvent = [[TGEvent alloc] init];
                            newEvent.type = eventType;
                            newEvent.object = object;
                            
                            // Create Event
                            [Tapglue createEvent:newEvent withCompletionBlock:^(BOOL success, NSError *error) {
                                expect(success).to.beTruthy();
                                expect(error).to.beNil();
                                
                                // Create Query Object
                                TGQuery *query = [TGQuery new];
                                [query addEventObjectWithIdEquals:objectId];
                                [query addTypeEquals:eventType];
                                
                                NSArray *types = @[eventType];
                                
                                // Retrieve Events with Query
                                [Tapglue retrieveEventsForEventTypes:types withCompletionBlock:^(NSArray *events, NSError *error) {
                                    expect(success).to.beTruthy();
                                    expect(error).to.beNil();
                                    
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

// [Correct] Create a like on an objectId
- (void)testCreateLikeOnObjectId {
    [self runTestBlockAfterLogin:^(XCTestExpectation *expectation) {
        
        NSString *objectId = [NSString randomStringWithLength:5];
        
        [Tapglue createLikeForObjectWithId:objectId andCompletionBlock:^(BOOL success, NSError *error) {
            expect(success).to.beTruthy();
            expect(error).to.beNil();
            
            [expectation fulfill];
        }];
    }];
}

// [Correct] Delete a like on an objectId
- (void)testDeleteLikeOnObjectId {
    [self runTestBlockAfterLogin:^(XCTestExpectation *expectation) {
        
        NSString *objectId = [NSString randomStringWithLength:5];
        
        [Tapglue createLikeForObjectWithId:objectId andCompletionBlock:^(BOOL success, NSError *error) {
            expect(success).to.beTruthy();
            expect(error).to.beNil();
            
            [Tapglue deleteLikeForObjectWithId:objectId andCompletionBlock:^(BOOL success, NSError *error) {
                expect(success).to.beTruthy();
                expect(error).to.beNil();
                
                [expectation fulfill];
            }];
        }];
    }];
}

// [Correct] Retrieve likes on an objectId
- (void)testRetrieveLikesOnObjectId {
    [self runTestBlockAfterLogin:^(XCTestExpectation *expectation) {
        
        NSString *objectId = [NSString randomStringWithLength:5];
        
        [Tapglue createLikeForObjectWithId:objectId andCompletionBlock:^(BOOL success, NSError *error) {
            expect(success).to.beTruthy();
            expect(error).to.beNil();
            
            [Tapglue retrieveLikesForObjectWithId:objectId withCompletionBlock:^(NSArray *likes, NSError *error) {
                expect(likes).toNot.beNil();
                expect(likes.count).to.equal(1);
                expect(error).to.beNil();
                
                [Tapglue deleteLikeForObjectWithId:objectId andCompletionBlock:^(BOOL success, NSError *error) {
                    expect(success).to.beTruthy();
                    expect(error).to.beNil();
                    
                    [expectation fulfill];
                }];
            }];
        }];
    }];
}

// [Correct] Create a comment on a custom object
- (void)testCreateCommentOnObjectId {
    [self runTestBlockAfterLogin:^(XCTestExpectation *expectation) {
        
        NSString *objectId = [NSString randomStringWithLength:5];
        NSString *comment = [NSString randomStringWithLength:10];
        
        [Tapglue createComment:comment forObjectWithId:objectId withCompletionBlock:^(BOOL success, NSError *error) {
            expect(success).to.beTruthy();
            expect(error).to.beNil();
            
            [expectation fulfill];
        }];
    }];
}

// [Correct] Delete a comment on a custom object
- (void)testCRUDCommentOnObjectId {
    [self runTestBlockAfterLogin:^(XCTestExpectation *expectation) {
        
        NSString *objectId = [NSString randomStringWithLength:5];
        NSString *comment = [NSString randomStringWithLength:10];
        
        [Tapglue createComment:comment forObjectWithId:objectId withCompletionBlock:^(BOOL success, NSError *error) {
            expect(success).to.beTruthy();
            expect(error).to.beNil();
            
            [Tapglue retrieveCommentsForObjectWithId:objectId withCompletionBlock:^(NSArray *comments, NSError *error) {
                expect(success).to.beTruthy();
                expect(error).to.beNil();
                
                TGComment *comment = comments.firstObject;
                comment.contents = @{@"en": @"bad post!"};
                
                [Tapglue updateComment:comment forObjectWithId:objectId andCompletionBlock:^(BOOL success, NSError *error) {
                    expect(success).to.beTruthy();
                    expect(error).to.beNil();
                    
                    [Tapglue deleteComment:comment forObjectWithId:objectId andCompletionBlock:^(BOOL success, NSError *error) {
                        expect(success).to.beTruthy();
                        expect(error).to.beNil();
                        
                        [expectation fulfill];
                    }];
                }];
            }];
        }];
    }];
}

@end