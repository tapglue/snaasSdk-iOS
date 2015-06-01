//
//  TGObjectCacheTests.m
//  Tapglue Tests
//
//  Created by Martin Stemmle on 03/06/15.
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
#import "TGObjectCache.h"
#import "TGModelObject+Private.h"

@interface TGObjectCacheTests : TGTestCase
@property (nonatomic, strong) TGObjectCache *cache;
@end

@implementation TGObjectCacheTests

- (void)setUp {
    [super setUp];
    self.cache = [TGObjectCache new];
    [TGObjectCache clearAllCaches];
}

- (void)tearDown {
    [super tearDown];
}

#pragma mark - test TGObjectCache only

- (void)testAddObject {
    TGModelObject* object = [[TGModelObject alloc] initWithDictionary:@{@"id" : @"4711"}];
    [self.cache addObject:object];
    expect([self.cache objectWithObjectId:@"4711"]).to.equal(object);
}

- (void)testHasObjectWithObjectId {
    TGModelObject* obj = [[TGModelObject alloc] initWithDictionary:@{@"id" : @"4711"}];
    [self.cache addObject:obj];
    expect([self.cache hasObjectWithObjectId:@"4711"]).to.beTruthy();
    expect([self.cache hasObjectWithObjectId:@"0815"]).to.beFalsy();
}

- (void)testReplaceObject {
    TGModelObject* object1 = [[TGModelObject alloc] initWithDictionary:@{@"id" : @"4711"}];
    TGModelObject* object2 = [[TGModelObject alloc] initWithDictionary:@{@"id" : @"4711"}];
    [self.cache addObject:object1];
    [self.cache replaceObject:object2];
    expect([self.cache objectWithObjectId:@"4711"]).toNot.equal(object1);
    expect([self.cache objectWithObjectId:@"4711"]).to.equal(object2);
}

- (void)testClearCache {
    TGModelObject* object = [[TGModelObject alloc] initWithDictionary:@{@"id" : @"4711"}];
    [self.cache addObject:object];
    [self.cache clearCache];
    expect([self.cache objectWithObjectId:@"4711"]).to.beNil();
}

- (void)testCacheFromClassCrashesForNonModelObjectClasses {
    expect(^{[TGObjectCache cacheForClass:[NSString class]];}).to.raiseAny();
    expect(^{[TGObjectCache cacheForClass:[TGUser class]];}).toNot.raiseAny();
    expect(^{[TGObjectCache cacheForClass:[TGEvent class]];}).toNot.raiseAny();
}

- (void)testFindObjectUsingPredicate {
    NSDictionary *eventData = @{ @"id" : @"a47f173d-d996-5ab7-ba02-621e00ff3297",
                                 @"user_id" : @"8586b3fe-6c7d-5d77-8509-a8b587c8e1ee",
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
    [self.cache addObject:event];

    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"type=%@ AND object.objectId=%@", @"like", @"o4711"];
    expect([self.cache findFirstMatchingPredicate:predicate]).to.equal(event);
}


#pragma mark - test TGObjectCache with TGUser & TGEvent

- (void)testUserCaching {

    NSDictionary *userData = @{
                               @"id" : @"a47f173d-d996-5ab7-ba02-621e00ff3297",
                               @"email" : @"testuser@tapglue.com"
                               };

    // try loading a not yet created user
    expect([TGUser objectWithId:@"a47f173d-d996-5ab7-ba02-621e00ff3297"]).to.beNil();

    // create a new user
    TGUser *user = [TGUser createOrLoadWithDictionary:userData];

    // the user should now be loadable and return the created user
    expect([TGUser objectWithId:@"a47f173d-d996-5ab7-ba02-621e00ff3297"]).to.equal(user);

    // calling create user again with the same id should return the already existing instance of the user
    expect([TGUser createOrLoadWithDictionary:userData]).to.equal(user);

}

// [Correct] Create mutliple users from JSON
- (void)testCreateAndCacheMultipleUsersFromDictionaries {
    NSArray *userData =  @[
                           @{
                               @"id" : @"tpgl1",
                               @"email" : @"testuser1@tapglue.com"
                               },

                           @{
                               @"id" : @"tpgl2",
                               @"email" : @"testuser2@tapglue.com"
                               },
                           @{
                               @"id" : @"tpgl3",
                               @"email" : @"testuser3@tapglue.com"
                               }
                           ];

    [TGUser createAndCacheObjectsFromDictionaries:userData];
    expect([TGUser objectWithId:@"tpgl1"]).toNot.beNil();
    expect([TGUser objectWithId:@"tpgl2"]).toNot.beNil();
    expect([TGUser objectWithId:@"tpgl3"]).toNot.beNil();
}



- (void)testEventCaching {

    NSDictionary *eventData = @{
                                @"id" : @"a47f173d-d996-5ab7-ba02-621e00ff3297",
                                @"user_id" : @"8586b3fe-6c7d-5d77-8509-a8b587c8e1ee",
                                @"type" : @"like",
                                @"created_at": @"2015-06-01T08:44:57.144996856Z",
                                @"updated_at": @"2014-02-10T06:25:10.144996856Z"};


    // try loading a not yet created user
    expect([TGEvent objectWithId:@"a47f173d-d996-5ab7-ba02-621e00ff3297"]).to.beNil();

    // create a new user
    TGEvent *event = [TGEvent createOrLoadWithDictionary:eventData];

    // the user should now be loadable and return the created user
    expect([TGEvent objectWithId:@"a47f173d-d996-5ab7-ba02-621e00ff3297"]).to.equal(event);

    // calling create user again with the same id should return the already existing instance of the user
    expect([TGEvent createOrLoadWithDictionary:eventData]).to.equal(event);

}

// [Correct] Create mutliple users from JSON
- (void)testCreateAndCacheMultipleEventsFromDictionaries {
    NSArray *eventData =  @[
                            @{
                                @"id" : @"tpgl1",
                                @"user_id" : @"8586b3fe-6c7d-5d77-8509-a8b587c8e1ee",
                                @"type" : @"like",
                                @"created_at": @"2015-06-01T08:44:57.144996856Z",
                                @"updated_at": @"2014-02-10T06:25:10.144996856Z"                               },

                            @{
                                @"id" : @"tpgl2",
                                @"user_id" : @"8586b3fe-6c7d-5d77-8509-a8b587c8e1ee",
                                @"type" : @"like",
                                @"created_at": @"2015-06-01T08:44:57.144996856Z",
                                @"updated_at": @"2014-02-10T06:25:10.144996856Z"                               },
                            @{
                                @"id" : @"tpgl3",
                                @"user_id" : @"8586b3fe-6c7d-5d77-8509-a8b587c8e1ee",
                                @"type" : @"like",
                                @"created_at": @"2015-06-01T08:44:57.144996856Z",
                                @"updated_at": @"2014-02-10T06:25:10.144996856Z"                               }
                            ];

    [TGEvent createAndCacheObjectsFromDictionaries:eventData];
    expect([TGEvent objectWithId:@"tpgl1"]).toNot.beNil();
    expect([TGEvent objectWithId:@"tpgl2"]).toNot.beNil();
    expect([TGEvent objectWithId:@"tpgl3"]).toNot.beNil();
}


- (void)testCachingUserAndEventWithSameIds {

    NSDictionary *eventData = @{
                                @"id" : @"123",
                                @"user_id" : @"8586b3fe-6c7d-5d77-8509-a8b587c8e1ee",
                                @"type" : @"like",
                                @"created_at": @"2015-06-01T08:44:57.144996856Z",
                                @"updated_at": @"2014-02-10T06:25:10.144996856Z"};

    NSDictionary *userData = @{
                               @"id" : @"123",
                               @"email" : @"testuser@tapglue.com"
                               };


    expect([TGUser objectWithId:@"123"]).to.beNil();
    expect([TGEvent objectWithId:@"123"]).to.beNil();

    [TGUser createOrLoadWithDictionary:userData];
    [TGEvent createOrLoadWithDictionary:eventData];

    expect([TGUser objectWithId:@"123"]).to.beKindOf([TGUser class]);
    expect([TGEvent objectWithId:@"123"]).to.beKindOf([TGEvent class]);

}



@end
