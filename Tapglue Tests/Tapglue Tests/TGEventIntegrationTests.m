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

@interface TGEventIntegrationTests : TGIntegrationTestCase

@end

@implementation TGEventIntegrationTests

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

        //NSDate *startedAt = [NSDate dateWithTimeIntervalSinceNow:-1];

        // Create Event
        [Tapglue createEvent:event withCompletionBlock:^(BOOL success, NSError *error) {
            expect(success).to.beTruthy();
            expect(error).to.beNil();

            expect(event.type).to.equal(@"like");
            expect(event.language).to.equal(@"en");
            expect(event.priority).to.equal(@"high");
            expect(event.location).to.equal(@"berlin");
            // Rounding issues with lat and long
//            expect(event.latitude).to.equal(52.520007);
//            expect(event.longitude).to.equal(13.404954);
            expect(event.object.objectId).to.equal(@"a1b2c3");
            expect(event.object.type).to.equal(@"movie");
            expect(event.object.url).to.equal(@"app://tapglue.com/objects/1");
            expect([event.object displayNameForLanguage:@"en"]).to.equal(@"good movie");
            expect([event.object displayNameForLanguage:@"de"]).to.equal(@"guter film");

            expect([event.metadata objectForKey:@"foo"]).to.equal(@"bar");
            expect([event.metadata objectForKey:@"amount"]).to.equal(12);
            expect([event.metadata objectForKey:@"progress"]).to.equal(0.95);
//            expect(event.updatedAt).to.beGreaterThan(startedAt);

            [Tapglue deleteEventWithId:event.eventId withCompletionBlock:^(BOOL success, NSError *error) {
                expect(success).to.beTruthy();
                expect(error).to.beNil();
                [expectation fulfill];
            }];
        }];
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

        //NSDate *startedAt = [NSDate dateWithTimeIntervalSinceNow:-1];

        // Create Event
        [Tapglue createEvent:event withCompletionBlock:^(BOOL success, NSError *error) {
            expect(success).to.beTruthy();
            expect(error).to.beNil();

            expect(event.type).to.equal(@"like");
            expect(event.language).to.equal(@"en");
//            expect(event.updatedAt).to.beGreaterThan(startedAt);

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

        //NSDate *startedAt = [NSDate dateWithTimeIntervalSinceNow:-1];

        [Tapglue createEvent:event withCompletionBlock:^(BOOL success, NSError *error) {
            expect(success).to.beTruthy();
            expect(error).to.beNil();

            expect(event.eventId).toNot.beNil();
            expect(event.createdAt).toNot.beNil();
//            expect(event.updatedAt).toNot.beNil();
//            expect(event.updatedAt).to.beGreaterThan(startedAt);
            
            [NSThread sleepForTimeInterval:3];

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

// [Negative] Create Event with Wrong Type (too long)
- (void)testCreateEventWithWrongTypeLong {
    [self runTestBlockAfterLogin:^(XCTestExpectation *expectation) {

        // Create Event
        [Tapglue createEventWithType:@"abcdef123456abcdef123456abcdef123456" withCompletionBlock:^(BOOL success, NSError *error) {
            expect(success).to.beFalsy();
            expect(error).to.beTruthy();

            [expectation fulfill];
        }];
    }];
}

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
        [Tapglue retrieveUnreadFeedForCurrentUserWithCompletionBlock:^(NSArray *events, NSError *error) {
            expect(events).toNot.beNil();
            expect(events.count).to.beGreaterThanOrEqualTo(0);
            expect(error).to.beNil();

            [expectation fulfill];
        }];
    }];
}

// [Correct] Retrieve news feed
- (void)testFeed {
    [self runTestBlockAfterLogin:^(XCTestExpectation *expectation) {
        [Tapglue retrieveFeedForCurrentUserWithCompletionBlock:^(NSArray *events, NSInteger unreadCount, NSError *error) {
            expect(events).toNot.beNil();
            expect(events.count).to.beGreaterThanOrEqualTo(0);
            expect(unreadCount).to.beGreaterThanOrEqualTo(0);
            expect(error).to.beNil();

            [expectation fulfill];
        }];
    }];
}

#pragma mark - Negative

// TODO: More use cases for negative feed events
// Variations to count events etc.
// Get unread feed
// Get feed
// Get current user feed
// Get user feed

// TODO: Cache Tests
// TODO: Flush Tests

@end
