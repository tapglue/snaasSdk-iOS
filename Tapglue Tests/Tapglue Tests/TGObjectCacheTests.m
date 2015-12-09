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
    expect(^{[TGObjectCache cacheForClass:[TGPost class]];}).toNot.raiseAny();
}

- (void)testFindObjectUsingPredicate {
    NSDictionary *eventData = @{ @"id" : @(47173996570203297),
                                 @"user_id" : @(85866757785095871),
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
                               @"id" : @(85866757785095871),
                               @"email" : @"testuser@tapglue.com"
                               };

    // try loading a not yet created user
    expect([TGUser objectWithId:@"85866757785095871"]).to.beNil();

    // create a new user
    TGUser *user = [TGUser createOrLoadWithDictionary:userData];
    expect(user).toNot.beNil();

    // the user should now be loadable and return the created user
    expect([TGUser objectWithId:@"85866757785095871"]).to.equal(user);

    // calling create user again with the same id should return the already existing instance of the user
    expect([TGUser createOrLoadWithDictionary:userData]).to.equal(user);

}


- (void)testCreateOrLoadUserWithUpdatedData {
    
    // create a new user
    TGUser *user1 = [TGUser createOrLoadWithDictionary:@{
                                                        @"id" : @(85866757785095871),
                                                        @"email" : @"testuser@tapglue.com",
                                                        @"user_name":@"acc-1-app-1-user-2"
                                                        }];
    expect(user1).toNot.beNil();
    
    // check user name is set correctly
    expect(user1.username).to.equal(@"acc-1-app-1-user-2");
    
    // load the user again with an updated username
    TGUser *user2 = [TGUser createOrLoadWithDictionary:@{
                                                        @"id" : @(85866757785095871),
                                                        @"email" : @"testuser@tapglue.com",
                                                        @"user_name":@"acc-1-app-1-user-4711"
                                                        }];
    
    // check user name is set correctly
    expect(user2.username).to.equal(@"acc-1-app-1-user-4711");
    
    // calling create user again with the same id should return the already existing instance of the user
    expect(user2).to.equal(user1);

    // check the user name has been updated / should always pass if expectation above passes
    expect(user1.username).to.equal(@"acc-1-app-1-user-4711");
}

// [Correct] Create mutliple users from JSON
- (void)testCreateAndCacheMultipleUsersFromDictionaries {
    NSArray *userData =  @[
                           @{
                               @"id" : @(111),
                               @"email" : @"testuser1@tapglue.com"
                               },

                           @{
                               @"id" : @(222),
                               @"email" : @"testuser2@tapglue.com"
                               },
                           @{
                               @"id" : @(333),
                               @"email" : @"testuser3@tapglue.com"
                               }
                           ];

    [TGUser createAndCacheObjectsFromDictionaries:userData];
    expect([TGUser objectWithId:@"111"]).toNot.beNil();
    expect([TGUser objectWithId:@"222"]).toNot.beNil();
    expect([TGUser objectWithId:@"333"]).toNot.beNil();
}



- (void)testEventCaching {

    NSDictionary *eventData = @{
                                @"id" : @(47173996570203297),
                                @"user_id" : @(85866757785095871),
                                @"type" : @"like",
                                @"created_at": @"2015-06-01T08:44:57.144996856Z",
                                @"updated_at": @"2014-02-10T06:25:10.144996856Z"};


    // try loading a not yet created user
    expect([TGEvent objectWithId:@"47173996570203297"]).to.beNil();

    // create a new user
    TGEvent *event = [TGEvent createOrLoadWithDictionary:eventData];
    expect(event).toNot.beNil();

    // the user should now be loadable and return the created user
    expect([TGEvent objectWithId:@"47173996570203297"]).to.equal(event);

    // calling create user again with the same id should return the already existing instance of the user
    expect([TGEvent createOrLoadWithDictionary:eventData]).to.equal(event);

}

// [Correct] Create mutliple users from JSON
- (void)testCreateAndCacheMultipleEventsFromDictionaries {
    NSArray *eventData =  @[
                            @{
                                @"id" : @(111),
                                @"user_id" : @(85866757785095871),
                                @"type" : @"like",
                                @"created_at": @"2015-06-01T08:44:57.144996856Z",
                                @"updated_at": @"2014-02-10T06:25:10.144996856Z"                               },

                            @{
                                @"id" : @(222),
                                @"user_id" : @(85866757785095871),
                                @"type" : @"like",
                                @"created_at": @"2015-06-01T08:44:57.144996856Z",
                                @"updated_at": @"2014-02-10T06:25:10.144996856Z"                               },
                            @{
                                @"id" : @(333),
                                @"user_id" : @(85866757785095871),
                                @"type" : @"like",
                                @"created_at": @"2015-06-01T08:44:57.144996856Z",
                                @"updated_at": @"2014-02-10T06:25:10.144996856Z"                               }
                            ];

    [TGEvent createAndCacheObjectsFromDictionaries:eventData];
    expect([TGEvent objectWithId:@"111"]).toNot.beNil();
    expect([TGEvent objectWithId:@"222"]).toNot.beNil();
    expect([TGEvent objectWithId:@"333"]).toNot.beNil();
}


- (void)testCachingUserAndEventWithSameIds {

    NSDictionary *eventData = @{
                                @"id" : @(123),
                                @"user_id" : @(8586),
                                @"type" : @"like",
                                @"created_at": @"2015-06-01T08:44:57.144996856Z",
                                @"updated_at": @"2014-02-10T06:25:10.144996856Z"};

    NSDictionary *userData = @{
                               @"id" : @(123),
                               @"email" : @"testuser@tapglue.com"
                               };


    expect([TGUser objectWithId:@"123"]).to.beNil();
    expect([TGEvent objectWithId:@"123"]).to.beNil();

    [TGUser createOrLoadWithDictionary:userData];
    [TGEvent createOrLoadWithDictionary:eventData];

    expect([TGUser objectWithId:@"123"]).to.beKindOf([TGUser class]);
    expect([TGEvent objectWithId:@"123"]).to.beKindOf([TGEvent class]);

}

- (void)testPostCaching {
    NSDictionary *postData = @{
                               @"id" : @(471739965702621007),
                               @"user_id" : @(858667),
                               @"visibility": @(30),
                               @"tags": @[@"fitness",@"running"],
                               @"attachments" : @[
                                       @{
                                           @"content": @"Lorem ipsum...",
                                           @"name": @"body",
                                           @"type": @"text"
                                           }
                                       ],
                               @"counts" : @{
                                       @"comments": @(3),
                                       @"likes": @(12),
                                       @"shares": @(1)
                                       },
                               @"created_at": @"2015-06-01T08:44:57.144996856Z",
                               @"updated_at": @"2014-02-10T06:25:10.144996856Z"};
    
    // try loading a not yet created user
    expect([TGUser objectWithId:@"471739965702621007"]).to.beNil();
    
    // create a new post
    TGPost *post = [TGPost createOrLoadWithDictionary:postData];
    expect(post).toNot.beNil();
    
    // the user should now be loadable and return the created post
    expect([TGPost objectWithId:@"471739965702621007"]).to.equal(post);
    
    // calling create post again with the same id should return the already existing instance of the post
    expect([TGPost createOrLoadWithDictionary:postData]).to.equal(post);
    
}


@end
