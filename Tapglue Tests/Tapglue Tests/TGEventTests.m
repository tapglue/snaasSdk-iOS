//
//  TGEventTests.m
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
#import "TGUser.h"
#import "TGEvent.h"
#import "TGImage.h"
#import "TGEventObject.h"
#import "TGModelObject+Private.h"
#import "TGEvent+RandomTestEvent.h"
#import "NSDateFormatter+TGISOFormatter.h"

@interface TGEventTests : TGTestCase

@end

@implementation TGEventTests

- (void)setUp {
    [super setUp];

    // create a test user
    [TGUser createOrLoadWithDictionary:@{
                                         @"id" : @(858667),
                                         @"user_name" : @"testuser"
                                         }];
}

#pragma mark - User general -

- (void)testImagesDictionaryIsNotNil {
    TGEvent *event = [[TGEvent alloc] init];
    expect(event.images).toNot.beNil();
    expect(event.images).to.beKindOf([NSMutableDictionary class]);
}

#pragma mark - JSON to Event -

#pragma mark - Correct

// [Correct] From JSON to Event with all values
- (void)testInitEventWithDictionaryAll {

    NSDictionary *eventData = @{
                                @"id" : @(471739965702621007),
                                @"user_id" : @(858667),
                                @"type" : @"like",
                                @"language" : @"en",
                                @"priority" : @"high",
                                @"location" : @"berlin",
                                @"latitude" : @52.520007,
                                @"longitude" : @13.404954,
                                @"tg_object_id" : @"124810",
                                @"object" : @{
                                                @"id" : @"o4711",
                                                @"type": @"movie",
                                                @"url": @"app://tapglue.com/objects/1",
                                                @"display_names" : @{
                                                        @"de" : @"Guter Film",
                                                        @"en" : @"Good Movie",
                                                        @"fr" : @"Bon Film"
                                                        },
                                            },
                                @"metadata" : @{
                                                @"foo" : @"bar",
                                                @"amount" : @12,
                                                @"progress" : @0.95
                                            },
                                @"created_at": @"2015-06-01T08:44:57.144996856Z",
                                @"updated_at": @"2014-02-10T06:25:10.144996856Z"};

    expect(eventData).toNot.beNil();

    TGEvent *event = [[TGEvent alloc] initWithDictionary:eventData];

    expect(event).toNot.beNil();

    // Check for correct values
    expect(event.eventId).to.equal(@"471739965702621007");
    expect(event.user).toNot.beNil();
    expect(event.user.userId).to.equal(@"858667");
    expect(event.type).to.equal(@"like");
//    expect(event.language).to.equal(@"en");
    expect(event.priority).to.equal(@"high");
    expect(event.location).to.equal(@"berlin");
    expect(event.latitude).to.equal(@52.520007);
    expect(event.longitude).to.equal(@13.404954);
    expect(event.tgObjectId).to.equal(@"124810");
    expect(event.object.objectId).to.equal(@"o4711");
    expect(event.object.type).to.equal(@"movie");
    expect(event.object.url).to.equal(@"app://tapglue.com/objects/1");
    expect([event.object displayNameForLanguage:@"de"]).to.equal(@"Guter Film");
    expect([event.object displayNameForLanguage:@"en"]).to.equal(@"Good Movie");
    expect([event.object displayNameForLanguage:@"fr"]).to.equal(@"Bon Film");
    expect([event.metadata objectForKey:@"foo"]).to.equal(@"bar");
    expect([event.metadata objectForKey:@"amount"]).to.equal(12);
    expect([event.metadata objectForKey:@"progress"]).to.equal(0.95);
    expect(event.createdAt).to.equal([NSDate dateWithTimeIntervalSince1970:1433148297]);
    expect(event.updatedAt).to.equal([NSDate dateWithTimeIntervalSince1970:1392013510]);

    // Check for correct types
    expect(event.eventId).to.beKindOf([NSString class]);
    expect(event.user.userId).to.beKindOf([NSString class]);
    expect(event.type).to.beKindOf([NSString class]);
    expect(event.language).to.beKindOf([NSString class]);
    expect(event.location).to.beKindOf([NSString class]);
    expect(event.priority).to.beKindOf([NSString class]);
    expect(event.latitude).to.beKindOf([NSNumber class]);
    expect(event.longitude).to.beKindOf([NSNumber class]);
    expect(event.object).to.beKindOf([TGEventObject class]);
    expect(event.object.objectId).to.beKindOf([NSString class]);
    expect(event.object.type).to.beKindOf([NSString class]);
    expect(event.object.url).to.beKindOf([NSString class]);
    expect([event.object displayNameForLanguage:@"de"]).to.beKindOf([NSString class]);
    expect([event.object displayNameForLanguage:@"en"]).to.beKindOf([NSString class]);
    expect([event.object displayNameForLanguage:@"fr"]).to.beKindOf([NSString class]);
    expect(event.metadata).to.beKindOf([NSDictionary class]);
    expect([event.metadata objectForKey:@"foo"]).to.beKindOf([NSString class]);
    expect([event.metadata objectForKey:@"amount"]).to.beKindOf([NSNumber class]);
    expect([event.metadata objectForKey:@"progress"]).to.beKindOf([NSNumber class]);
    expect(event.createdAt).to.beKindOf([NSDate class]);
    expect(event.updatedAt).to.beKindOf([NSDate class]);
}


// [Correct] From JSON to Event with object being null
- (void)testInitEventWithDictionaryWithNullEventObject {
    NSDictionary *eventData = @{
                                @"id" : @(471739965702621007),
                                @"user_id" : @(858667),
                                @"type" : @"like",
                                @"object" : [NSNull null],
                                @"created_at": @"2015-06-01T08:44:57.144996856Z",
                                @"updated_at": @"2014-02-10T06:25:10.144996856Z"};
    
    TGEvent *event = [[TGEvent alloc] initWithDictionary:eventData];
    
    expect(event).toNot.beNil();
    expect(event.object).to.beNil();
}

// [Correct] From JSON to Event with target being null
- (void)testInitEventWithDictionaryWithNullEventTarget {
    NSDictionary *eventData = @{
                                @"id" : @(471739965702621007),
                                @"user_id" : @(858667),
                                @"type" : @"like",
                                @"target" : [NSNull null],
                                @"created_at": @"2015-06-01T08:44:57.144996856Z",
                                @"updated_at": @"2014-02-10T06:25:10.144996856Z"};
    
    TGEvent *event = [[TGEvent alloc] initWithDictionary:eventData];
    
    expect(event).toNot.beNil();
    expect(event.target).to.beNil();
}


// [Correct] From JSON to Event with minimal values
- (void)testInitEventWithDictionaryMinimum {
    NSDictionary *eventData = @{
                                @"id" : @(471739965702621007),
                                @"user_id" : @(858667),
                                @"type" : @"like",
                                @"created_at": @"2015-06-01T08:44:57.144996856Z",
                                @"updated_at": @"2014-02-10T06:25:10.144996856Z"};

    TGEvent *event = [[TGEvent alloc] initWithDictionary:eventData];

    expect(event).toNot.beNil();

    // Check for correct values
    expect(event.eventId).to.equal(@"471739965702621007");
    expect(event.user.userId).to.equal(@"858667");
    expect(event.type).to.equal(@"like");
    expect(event.createdAt).to.equal([NSDate dateWithTimeIntervalSince1970:1433148297]);
    expect(event.updatedAt).to.equal([NSDate dateWithTimeIntervalSince1970:1392013510]);

    // Check for correct types
    expect(event.eventId).to.beKindOf([NSString class]);
    expect(event.user.userId).to.beKindOf([NSString class]);
    expect(event.type).to.beKindOf([NSString class]);
    expect(event.createdAt).to.beKindOf([NSDate class]);
    expect(event.updatedAt).to.beKindOf([NSDate class]);
}

// [Correct] From JSON to Event with location
- (void)testInitEventWithDictionaryWithLocation {
    NSDictionary *eventData = @{
                                @"id" : @(471739965702621007),
                                @"user_id" : @(858667),
                                @"type" : @"like",
                                @"location" : @"berlin",
                                @"latitude" : @52.520007,
                                @"longitude" : @13.404954,
                                @"created_at": @"2015-06-01T08:44:57.144996856Z",
                                @"updated_at": @"2014-02-10T06:25:10.144996856Z"};

    expect(eventData).toNot.beNil();

    TGEvent *event = [[TGEvent alloc] initWithDictionary:eventData];

    expect(event).toNot.beNil();

    // Check for correct values
    expect(event.eventId).to.equal(@"471739965702621007");
    expect(event.user.userId).to.equal(@"858667");
    expect(event.type).to.equal(@"like");
    expect(event.location).to.equal(@"berlin");
    expect(event.latitude).to.equal(@52.520007);
    expect(event.longitude).to.equal(@13.404954);
    expect(event.createdAt).to.equal([NSDate dateWithTimeIntervalSince1970:1433148297]);
    expect(event.updatedAt).to.equal([NSDate dateWithTimeIntervalSince1970:1392013510]);

    // Check for correct types
    expect(event.eventId).to.beKindOf([NSString class]);
    expect(event.user.userId).to.beKindOf([NSString class]);
    expect(event.type).to.beKindOf([NSString class]);
    expect(event.location).to.beKindOf([NSString class]);
    expect(event.latitude).to.beKindOf([NSNumber class]);
    expect(event.longitude).to.beKindOf([NSNumber class]);
    expect(event.createdAt).to.beKindOf([NSDate class]);
    expect(event.updatedAt).to.beKindOf([NSDate class]);
}

// [Correct] From JSON to Event without Dates
- (void)testInitEventWithDictionaryWithoutDates {
    NSDictionary *eventData = @{
                                @"id" : @(471739965702621007),
                                @"user_id" : @(858667),
                                @"type" : @"like"};

    expect(eventData).toNot.beNil();

    TGEvent *event = [[TGEvent alloc] initWithDictionary:eventData];

    expect(event).toNot.beNil();

    // Check for correct values
    expect(event.eventId).to.equal(@"471739965702621007");
    expect(event.user.userId).to.equal(@"858667");
    expect(event.type).to.equal(@"like");

    // Check for correct types
    expect(event.eventId).to.beKindOf([NSString class]);
    expect(event.user.userId).to.beKindOf([NSString class]);
    expect(event.type).to.beKindOf([NSString class]);
}

// [Correct] From JSON to Event with Metadata
- (void)testMetadataForEventInitWithDictionary {
    NSDictionary *eventData = @{ @"id" : @(471739965702621007),
                                 @"user_id" : @(858667),
                                 @"type" : @"like",
                                 @"metadata" : @{
                                        @"foo" : @"bar",
                                        @"amount" : @12,
                                        @"progress" : @0.95
                                        }
                                };

    TGEvent *event = [[TGEvent alloc] initWithDictionary:eventData];

    // Check for correct values
    expect(event.eventId).to.equal(@"471739965702621007");
    expect(event.user.userId).to.equal(@"858667");
    expect(event.type).to.equal(@"like");

    expect(event.metadata).to.beKindOf([NSDictionary class]);

    expect([event.metadata objectForKey:@"foo"]).to.equal(@"bar");
    expect([event.metadata objectForKey:@"amount"]).to.equal(12);
    expect([event.metadata objectForKey:@"progress"]).to.equal(0.95);

    // Check for correct types
    expect(event.eventId).to.beKindOf([NSString class]);
    expect(event.user.userId).to.beKindOf([NSString class]);
    expect(event.type).to.beKindOf([NSString class]);
    expect([event.metadata objectForKey:@"foo"]).to.beKindOf([NSString class]);
    expect([event.metadata objectForKey:@"amount"]).to.beKindOf([NSNumber class]);
    expect([event.metadata objectForKey:@"progress"]).to.beKindOf([NSNumber class]);
}

// [Correct] From JSON to User with Images
- (void)testImagesForUserInitWithDictionary {
    NSDictionary *eventData = @{ @"id" : @(471739965702621007),
                                 @"user_id" : @(858667),
                                 @"type" : @"like",
                                @"images" : @{
                                        @"profile_thumb" : @{@"url": @"http://images.tapglue.com/1/demouser/profile.jpg"}
                                        }
                                };
    
    TGEvent *event = [[TGEvent alloc] initWithDictionary:eventData];
    
    // Check for correct values
    expect(event.eventId).to.equal(@"471739965702621007");
    expect(event.user.userId).to.equal(@"858667");
    expect(event.type).to.equal(@"like");
    
    expect(event.images).to.beKindOf([NSDictionary class]);
    TGImage *profileImage = [event.images objectForKey:@"profile_thumb"];
    expect(profileImage).to.beKindOf([TGImage class]);
    expect(profileImage.url).to.equal(@"http://images.tapglue.com/1/demouser/profile.jpg");
}

// [Correct] From JSON to Event with Object
- (void)testEventInitWithDictionaryWithObject {
    NSDictionary *eventData = @{ @"id" : @(471739965702621007),
                                 @"user_id" : @(858667),
                                 @"type" : @"like",
                                 @"object" : @{
                                         @"id" : @"o4711",
                                         @"type": @"movie",
                                         @"url": @"app://tapglue.com/objects/1",
                                         @"display_names" : @{
                                                 @"de" : @"Guter Film",
                                                 @"en" : @"Good Movie",
                                                 @"fr" : @"Bon Film"
                                                 },
                                         }
                                 };

    TGEvent *event = [[TGEvent alloc] initWithDictionary:eventData];

    // Check for correct values
    expect(event.eventId).to.equal(@"471739965702621007");
    expect(event.user.userId).to.equal(@"858667");
    expect(event.type).to.equal(@"like");
    expect(event.object.objectId).to.equal(@"o4711");
    expect(event.object.type).to.equal(@"movie");
    expect(event.object.url).to.equal(@"app://tapglue.com/objects/1");
    expect([event.object displayNameForLanguage:@"de"]).to.equal(@"Guter Film");
    expect([event.object displayNameForLanguage:@"en"]).to.equal(@"Good Movie");
    expect([event.object displayNameForLanguage:@"fr"]).to.equal(@"Bon Film");

    // Check for correct types
    expect(event.eventId).to.beKindOf([NSString class]);
    expect(event.user.userId).to.beKindOf([NSString class]);
    expect(event.type).to.beKindOf([NSString class]);
    expect(event.object).to.beKindOf([TGEventObject class]);
    expect(event.object.objectId).to.beKindOf([NSString class]);
    expect(event.object.type).to.beKindOf([NSString class]);
    expect(event.object.url).to.beKindOf([NSString class]);
    expect([event.object displayNameForLanguage:@"de"]).to.beKindOf([NSString class]);
    expect([event.object displayNameForLanguage:@"en"]).to.beKindOf([NSString class]);
    expect([event.object displayNameForLanguage:@"fr"]).to.beKindOf([NSString class]);
}

// [Correct] From JSON to Event with Target
- (void)testEventInitWithDictionaryWithTarget {
    NSDictionary *eventData = @{ @"id" : @(471739965702621007),
                                 @"user_id" : @(858667),
                                 @"type" : @"like",
                                 @"target" : @{
                                         @"id" : @"o4711",
                                         @"type": @"movie",
                                         @"url": @"app://tapglue.com/targets/1",
                                         @"display_names" : @{
                                                 @"de" : @"Beste Filme",
                                                 @"en" : @"Great Movies",
                                                 @"fr" : @"Bon Films"
                                                 },
                                         }
                                 };
    
    TGEvent *event = [[TGEvent alloc] initWithDictionary:eventData];
    
    // Check for correct values
    expect(event.eventId).to.equal(@"471739965702621007");
    expect(event.user.userId).to.equal(@"858667");
    expect(event.type).to.equal(@"like");
    expect(event.target.objectId).to.equal(@"o4711");
    expect(event.target.type).to.equal(@"movie");
    expect(event.target.url).to.equal(@"app://tapglue.com/targets/1");
    expect([event.target displayNameForLanguage:@"de"]).to.equal(@"Beste Filme");
    expect([event.target displayNameForLanguage:@"en"]).to.equal(@"Great Movies");
    expect([event.target displayNameForLanguage:@"fr"]).to.equal(@"Bon Films");
    
    // Check for correct types
    expect(event.eventId).to.beKindOf([NSString class]);
    expect(event.user.userId).to.beKindOf([NSString class]);
    expect(event.type).to.beKindOf([NSString class]);
    expect(event.target).to.beKindOf([TGEventObject class]);
    expect(event.target.objectId).to.beKindOf([NSString class]);
    expect(event.target.type).to.beKindOf([NSString class]);
    expect(event.target.url).to.beKindOf([NSString class]);
    expect([event.target displayNameForLanguage:@"de"]).to.beKindOf([NSString class]);
    expect([event.target displayNameForLanguage:@"en"]).to.beKindOf([NSString class]);
    expect([event.target displayNameForLanguage:@"fr"]).to.beKindOf([NSString class]);
}


#pragma mark - Negative

// [Negative] From JSON to Event without type
- (void)testInitEventWithDictionaryWithoutType {
    NSDictionary *eventData = @{
                                @"id" : @(471739965702621007),
                                @"user_id" : @(858667),
                                @"created_at": @"2015-06-01T08:44:57.144996856Z",
                                @"updated_at": @"2014-02-10T06:25:10.144996856Z"};

    expect(eventData).toNot.beNil();

    TGEvent *event = [[TGEvent alloc] initWithDictionary:eventData];

    expect(event).to.beNil();
}

// [Negative] From JSON to Event without id
- (void)testInitEventWithDictionaryWithoutId {
    NSDictionary *eventData = @{
                                @"user_id" : @(858667),
                                @"type" : @"like",
                                @"created_at": @"2015-06-01T08:44:57.144996856Z",
                                @"updated_at": @"2014-02-10T06:25:10.144996856Z"};

    expect(eventData).toNot.beNil();

    TGEvent *event = [[TGEvent alloc] initWithDictionary:eventData];

    expect(event).to.beNil();
}

// [Negative] From JSON to Event without UserId
- (void)testInitEventWithDictionaryWithoutUserId {
    NSDictionary *eventData = @{
                                @"id" : @(471739965702621007),
                                @"type" : @"like",
                                @"created_at": @"2015-06-01T08:44:57.144996856Z",
                                @"updated_at": @"2014-02-10T06:25:10.144996856Z"};

    expect(eventData).toNot.beNil();

    TGEvent *event = [[TGEvent alloc] initWithDictionary:eventData];

    expect(event).to.beNil();
}

// [Negative] From JSON to Event wrong UserId key
- (void)testInitEventWithDictionaryWrongUserKey {
    NSDictionary *eventData = @{
                                @"id" : @(471739965702621007),
                                @"userid" : @"858667",
                                @"type" : @"like",
                                @"created_at": @"2015-06-01T08:44:57.144996856Z",
                                @"updated_at": @"2014-02-10T06:25:10.144996856Z"};

    expect(eventData).toNot.beNil();

    TGEvent *event = [[TGEvent alloc] initWithDictionary:eventData];

    expect(event).to.beNil();
}

// [Negative] From JSON to Event invalid UserId
- (void)testInitEventWithDictionaryInvalidUserId {
    NSDictionary *eventData = @{
                                @"id" : @(471739965702621007),
                                @"user_id" : @"",
                                @"type" : @"like",
                                @"created_at": @"2015-06-01T08:44:57.144996856Z",
                                @"updated_at": @"2014-02-10T06:25:10.144996856Z"};

    expect(eventData).toNot.beNil();

    TGEvent *event = [[TGEvent alloc] initWithDictionary:eventData];

    expect(event).to.beNil();
}

// [Negative] From JSON to Event wrong location data type
- (void)testInitEventWithDictionaryWrongLocationDataType {
    NSDictionary *eventData = @{
                                @"id" : @(471739965702621007),
                                @"user_id" : @(858667),
                                @"type" : @"like",
                                @"location" : @"berlin",
                                @"latitude" : @"52.520007",
                                @"longitude" : @"13.404954",
                                @"created_at": @"2015-06-01T08:44:57.144996856Z",
                                @"updated_at": @"2014-02-10T06:25:10.144996856Z"};

    expect(eventData).toNot.beNil();

    TGEvent *event = [[TGEvent alloc] initWithDictionary:eventData];

    expect(event).toNot.beNil();

    // Check for correct values
    expect(event.eventId).to.equal(@"471739965702621007");
    expect(event.user.userId).to.equal(@"858667");
    expect(event.type).to.equal(@"like");
    expect(event.location).to.equal(@"berlin");
    expect(event.latitude).to.equal(52.520007);
    expect(event.longitude).to.equal(13.404954);
    expect(event.createdAt).to.equal([NSDate dateWithTimeIntervalSince1970:1433148297]);
    expect(event.updatedAt).to.equal([NSDate dateWithTimeIntervalSince1970:1392013510]);

    // Check for correct types
    expect(event.eventId).to.beKindOf([NSString class]);
    expect(event.user.userId).to.beKindOf([NSString class]);
    expect(event.type).to.beKindOf([NSString class]);
    expect(event.latitude).to.beKindOf([NSNumber class]);
    expect(event.longitude).to.beKindOf([NSNumber class]);
    expect(event.location).to.beKindOf([NSString class]);
    expect(event.createdAt).to.beKindOf([NSDate class]);
    expect(event.updatedAt).to.beKindOf([NSDate class]);
}

// [Negative] From JSON to Event no data
- (void)testInitEventWithDictionaryNoData {
    NSDictionary *eventData = @{};

    TGEvent *event = [[TGEvent alloc] initWithDictionary:eventData];

    expect(event).to.beNil();
}

// TODO: test to check the user is nil if not created & cached before  > different test method
// TODO: test to check the user is not nil > different test method

#pragma mark - Event to JSON -

#pragma mark - Correct

// [Correct] From Event to JSON with all data
- (void)testEventJsonDictionaryAll {

    TGEvent *event = [TGEvent new];
    event.objectId = @"487293102930293";
    event.type = @"like";
    event.language = @"en";
    event.priority = @"high";
    event.location = @"berlin";
    event.latitude = 52.520007;
    event.longitude = 13.404954;
    event.tgObjectId = @"124810";

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

    NSDictionary *jsonDictionary = event.jsonDictionary;
    expect([NSJSONSerialization isValidJSONObject:jsonDictionary]).to.beTruthy();

    expect(jsonDictionary.count).to.equal(12);

    // Check for correct values
    expect([jsonDictionary valueForKey:@"id"]).to.equal(487293102930293);
    expect([jsonDictionary valueForKey:@"type"]).to.equal(@"like");
    expect([jsonDictionary valueForKey:@"language"]).to.equal(@"en");
    expect([jsonDictionary valueForKey:@"priority"]).to.equal(@"high");
    expect([jsonDictionary valueForKey:@"visibility"]).toNot.beNil();
    expect([jsonDictionary valueForKey:@"location"]).to.equal(@"berlin");
    expect([jsonDictionary valueForKey:@"latitude"]).to.equal(@52.520007);
    expect([jsonDictionary valueForKey:@"longitude"]).to.equal(@13.404954);
    expect([jsonDictionary valueForKey:@"tg_object_id"]).to.equal(@"124810");
    expect([jsonDictionary valueForKey:@"object"]).toNot.beNil();
    expect([jsonDictionary valueForKey:@"object"]).to.equal(@{
                                                              @"id" : @"a1b2c3",
                                                              @"type": @"movie",
                                                              @"url": @"app://tapglue.com/objects/1",
                                                              @"display_names" : @{
                                                                      @"de" : @"guter film",
                                                                      @"en" : @"good movie",
                                                                      }
                                                              });
    expect([jsonDictionary valueForKey:@"metadata"]).to.equal(@{
                                                                @"foo" : @"bar",
                                                                @"amount" : @12,
                                                                @"progress" : @0.95
                                                                });

    // Check for correct types
    [self validateDataTypesForEventJsonDictionary:jsonDictionary];

    [self validateJsonDictionary:jsonDictionary];
}

// [Correct] From Event to JSON with all values
- (void)testEventJsonDictionaryWithObject {

    TGEvent *event = [TGEvent new];
    event.type = @"like";

    TGEventObject *object = [TGEventObject new];

    object.objectId = @"a1b2c3";
    object.type = @"movie";
    object.url = @"app://tapglue.com/objects/1";
    [object setDisplayName:@"good movie" forLanguage:@"en"];
    [object setDisplayName:@"guter film" forLanguage:@"de"];

    event.object = object;


    NSDictionary *jsonDictionary = event.jsonDictionary;
    expect([NSJSONSerialization isValidJSONObject:jsonDictionary]).to.beTruthy();

    expect(jsonDictionary.count).to.equal(4);

    expect([jsonDictionary valueForKey:@"type"]).to.equal(@"like");
    expect([jsonDictionary valueForKey:@"object"]).toNot.beNil();
    expect([jsonDictionary valueForKey:@"visibility"]).toNot.beNil();


    expect([jsonDictionary valueForKeyPath:@"object.id"]).to.equal(@"a1b2c3");
    expect([jsonDictionary valueForKeyPath:@"object.type"]).to.equal(@"movie");
    expect([jsonDictionary valueForKeyPath:@"object.url"]).to.equal(@"app://tapglue.com/objects/1");
    expect([jsonDictionary valueForKeyPath:@"object.display_names"]).to.equal(@{
                                                                                @"de" : @"guter film",
                                                                                @"en" : @"good movie"
                                                                                });

    // Check for correct types
    [self validateDataTypesForEventJsonDictionary:jsonDictionary];

    [self validateJsonDictionary:jsonDictionary];
}

// [Correct] From Event to JSON with all values
- (void)testEventJsonDictionaryWithTarget {
    
    TGEvent *event = [TGEvent new];
    event.type = @"like";
    
    TGEventObject *target = [TGEventObject new];
    
    target.objectId = @"a1b2c3";
    target.type = @"movie collection";
    target.url = @"app://tapglue.com/targets/1";
    [target setDisplayName:@"great movies" forLanguage:@"en"];
    [target setDisplayName:@"beste filme" forLanguage:@"de"];
    
    event.target = target;
    
    
    NSDictionary *jsonDictionary = event.jsonDictionary;
    expect([NSJSONSerialization isValidJSONObject:jsonDictionary]).to.beTruthy();
    
    expect(jsonDictionary.count).to.equal(4);
    
    expect([jsonDictionary valueForKey:@"type"]).to.equal(@"like");
    expect([jsonDictionary valueForKey:@"target"]).toNot.beNil();
    expect([jsonDictionary valueForKey:@"visibility"]).toNot.beNil();
    
    
    expect([jsonDictionary valueForKeyPath:@"target.id"]).to.equal(@"a1b2c3");
    expect([jsonDictionary valueForKeyPath:@"target.type"]).to.equal(@"movie collection");
    expect([jsonDictionary valueForKeyPath:@"target.url"]).to.equal(@"app://tapglue.com/targets/1");
    expect([jsonDictionary valueForKeyPath:@"target.display_names"]).to.equal(@{
                                                                                @"de" : @"beste filme",
                                                                                @"en" : @"great movies"
                                                                                });
    
    // Check for correct types
    [self validateDataTypesForEventJsonDictionary:jsonDictionary];
    
    [self validateJsonDictionary:jsonDictionary];
}

// [Correct] From Event to JSON with minimal
- (void)testEventJsonDictionaryMinimal {

    TGEvent *event = [TGEvent new];
    event.type = @"like";

    NSDictionary *jsonDictionary = event.jsonDictionary;
    expect([NSJSONSerialization isValidJSONObject:jsonDictionary]).to.beTruthy();

    expect(jsonDictionary.count).to.equal(3);

    // Check for correct values
    expect([jsonDictionary valueForKey:@"type"]).to.equal(@"like");
    expect([jsonDictionary valueForKey:@"visibility"]).toNot.beNil();

    // Check for correct types
    [self validateDataTypesForEventJsonDictionary:jsonDictionary];

    [self validateJsonDictionary:jsonDictionary];
}

// [Correct] From Event to JSON with Nil
- (void)testEventJsonDictionaryWithNil {

    TGEvent *event = [TGEvent new];
    event.type = @"like";
    event.location = NULL;

    NSDictionary *jsonDictionary = event.jsonDictionary;
    expect([NSJSONSerialization isValidJSONObject:jsonDictionary]).to.beTruthy();
    expect(jsonDictionary.count).to.equal(3);

    // Check for correct values
    expect([jsonDictionary valueForKey:@"type"]).to.equal(@"like");
    expect([jsonDictionary valueForKey:@"created_at"]).to.beKindOf([NSString class]);
    expect([jsonDictionary valueForKey:@"location"]).to.equal(nil);
    expect([jsonDictionary valueForKey:@"priority"]).to.equal(nil);
    expect([jsonDictionary valueForKey:@"visibility"]).toNot.beNil();

    // Check for correct types
    [self validateDataTypesForEventJsonDictionary:jsonDictionary];

    [self validateJsonDictionary:jsonDictionary];
}

- (void)testEventJsonDictionaryContainsCreatedAt {
    NSDictionary *eventData = @{
                                @"id" : @(471739965702621007),
                                @"user_id" : @(858667),
                                @"type" : @"like",
                                @"created_at": @"2015-06-01T08:44:57.144996856Z"};
    TGEvent *event = [[TGEvent alloc] initWithDictionary:eventData];
    expect([event.jsonDictionary objectForKey:@"created_at"]).to.equal(@"2015-06-01T08:44:57Z");
}


// [Correct] From User to JSON with images
- (void)testJsonDictionaryWithImagesAsNSDictionary {
    
    TGEvent *event = [TGEvent new];
    event.type = @"like";
    event.images =  @{@"profile_thumb" : @{
                             @"url": @"http://images.tapglue.com/1/demouser/profile.jpg",
                             @"type" : @"some type",
                             @"width" : @800,
                             @"height" : @600
                             }
                     };
    
    NSDictionary *jsonDictionary = event.jsonDictionary;
    expect([NSJSONSerialization isValidJSONObject:jsonDictionary]).to.beTruthy();
    
    // Check for correct values
    NSDictionary *imagesJsonDictionary = [jsonDictionary valueForKey:@"images"];
    expect(imagesJsonDictionary).to.beKindOf([NSDictionary class]);
    expect([imagesJsonDictionary valueForKey:@"profile_thumb"]).to.to.beKindOf([NSDictionary class]);
    expect([imagesJsonDictionary valueForKeyPath:@"profile_thumb.url"]).to.equal(@"http://images.tapglue.com/1/demouser/profile.jpg");
    expect([imagesJsonDictionary valueForKeyPath:@"profile_thumb.type"]).to.equal(@"some type");
    expect([imagesJsonDictionary valueForKeyPath:@"profile_thumb.width"]).to.equal(800);
    expect([imagesJsonDictionary valueForKeyPath:@"profile_thumb.height"]).to.equal(600);
    
    // Check for correct types
    [self validateDataTypesForEventJsonDictionary:jsonDictionary];
}

// [Correct] From User to JSON with images
- (void)testJsonDictionaryWithImagesAsTGImage {
    
    TGImage *image = [[TGImage alloc] init];
    image.url = @"http://images.tapglue.com/1/demouser/profile.jpg";
    image.type = @"some type";
    image.size = CGSizeMake(800, 600);
    
    TGEvent *event = [TGEvent new];
    event.type = @"like";
    event.images =  @{@"profile_thumb" : image};
    
    NSDictionary *jsonDictionary = event.jsonDictionary;
    expect([NSJSONSerialization isValidJSONObject:jsonDictionary]).to.beTruthy();
    
    // Check for correct values
    NSDictionary *imagesJsonDictionary = [jsonDictionary valueForKey:@"images"];
    expect(imagesJsonDictionary).to.beKindOf([NSDictionary class]);
    expect([imagesJsonDictionary valueForKey:@"profile_thumb"]).to.to.beKindOf([NSDictionary class]);
    expect([imagesJsonDictionary valueForKeyPath:@"profile_thumb.url"]).to.equal(@"http://images.tapglue.com/1/demouser/profile.jpg");
    expect([imagesJsonDictionary valueForKeyPath:@"profile_thumb.type"]).to.equal(@"some type");
    expect([imagesJsonDictionary valueForKeyPath:@"profile_thumb.width"]).to.equal(800);
    expect([imagesJsonDictionary valueForKeyPath:@"profile_thumb.height"]).to.equal(600);
    
    // Check for correct types
    [self validateDataTypesForEventJsonDictionary:jsonDictionary];
}



#pragma mark - Negative

// [Negative] From Event to JSON no type
- (void)testEventJsonDictionaryNoType {

    TGEvent *event = [[TGEvent alloc] init];

    event.location = @"like";
    event.priority = @"low";

    NSDictionary *jsonDictionary = event.jsonDictionary;
    expect([NSJSONSerialization isValidJSONObject:jsonDictionary]).to.beTruthy();
    expect(jsonDictionary.count).to.equal(4);

    [self falsifyJsonDictionary:jsonDictionary];
}

// [Negative] From Event to JSON no data
- (void)testEventJsonDictionaryNoData {

    TGEvent *event = [[TGEvent alloc] init];

    NSDictionary *jsonDictionary = event.jsonDictionary;
    expect([NSJSONSerialization isValidJSONObject:jsonDictionary]).to.beTruthy();

    [self falsifyJsonDictionary:jsonDictionary];
}

#pragma mark - Created At -

- (void)testEventHasCreatedAtSetAfterInit {
    TGEvent *event = [[TGEvent alloc] init];
    expect(event.createdAt).to.beKindOf([NSDate class]);
    expect(event.updatedAt).to.beNil();
    NSDate *now = [NSDate date];
    expect(event.createdAt).to.beInTheRangeOf([now dateByAddingTimeInterval:-2], now);

    // additionally also check the json dictionary
    expect([event.jsonDictionary objectForKey:@"created_at"]).to.equal([[NSDateFormatter tg_isoDateFormatter] stringFromDate:event.createdAt]);
    expect([event.jsonDictionary objectForKey:@"created_at"]).to.beKindOf([NSString class]);
}


#pragma mark - Helper -

#pragma mark - JSONDictionary

// Helper to validate jsonDictionary
- (void)validateJsonDictionary:(NSDictionary*)jsonDictionary {
    expect([NSJSONSerialization isValidJSONObject:jsonDictionary]).to.beTruthy();
    expect([jsonDictionary valueForKey:@"type"]).toNot.beNil();
    expect([jsonDictionary valueForKey:@"random_key"]).to.beNil();
}

// Helper to validate jsonDictionary types
- (void)validateDataTypesForEventJsonDictionary:(NSDictionary*)jsonDictionary {
    expect([jsonDictionary valueForKey:@"id"]).to.beKindOfOrNil([NSNumber class]);
    expect([jsonDictionary valueForKey:@"type"]).to.beKindOfOrNil([NSString class]);
    expect([jsonDictionary valueForKey:@"language"]).to.beKindOfOrNil([NSString class]);
    expect([jsonDictionary valueForKey:@"priority"]).to.beKindOfOrNil([NSString class]);
    expect([jsonDictionary valueForKey:@"location"]).to.beKindOfOrNil([NSString class]);
    expect([jsonDictionary valueForKey:@"latitude"]).to.beKindOfOrNil([NSNumber class]);
    expect([jsonDictionary valueForKey:@"longitude"]).to.beKindOfOrNil([NSNumber class]);
    expect([jsonDictionary valueForKey:@"visibility"]).to.beKindOfOrNil([NSNumber class]);
    expect([jsonDictionary valueForKey:@"object"]).to.beKindOfOrNil([NSDictionary class]);
    expect([jsonDictionary valueForKey:@"metadata"]).to.beKindOfOrNil([NSDictionary class]);
    expect([jsonDictionary valueForKey:@"random_key"]).to.beNil();
}

// Helper to falisfy jsonDictionary
- (void)falsifyJsonDictionary:(NSDictionary*)jsonDictionary {
    expect([NSJSONSerialization isValidJSONObject:jsonDictionary]).to.beTruthy();
    expect([jsonDictionary valueForKey:@"event_id"]).to.beNil();
    expect([jsonDictionary valueForKey:@"user_id"]).to.beNil();
    expect([jsonDictionary valueForKey:@"type"]).to.beNil();
    expect([jsonDictionary valueForKey:@"random_key"]).to.beNil();
}

#pragma mark - NSCoding

- (void)testArchivingEvents {
    TGUser *user = [[TGUser alloc] initWithDictionary:@{@"id" : @"102934", @"email" : @"testuser@tapglue.com"}];

    TGImage *testImage = [[TGImage alloc] init];
    testImage.url = @"http://images.tapglue.com/1/demouser/profile.jpg";
    testImage.type = @"thumbnail";
    testImage.size = CGSizeMake(800,600);

    TGEvent *testEvent = [TGEvent randomTestEvent];
    testEvent.user = user;
    testEvent.tgObjectId = @"491852323";
    [testEvent.images setValue:testImage forKey:@"profile_thumbnail"];
    
    NSData *archivedData = [NSKeyedArchiver archivedDataWithRootObject:testEvent];
    TGEvent *unarchivedEvent = [NSKeyedUnarchiver unarchiveObjectWithData:archivedData];
    expect(unarchivedEvent.type).to.equal(testEvent.type);
    expect(unarchivedEvent.user.userId).to.equal(user.userId);
    expect(unarchivedEvent.tgObjectId).to.equal(@"491852323");
    expect(unarchivedEvent.images.allValues.count).to.equal(1);
}


// TODO: create tests for event.visibility with levels enum


@end
