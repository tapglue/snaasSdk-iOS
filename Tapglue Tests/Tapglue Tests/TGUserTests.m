//
//  TGUserTests.m
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
#import "TGImage.h"
#import "TGUser+Private.h"
#import "TGModelObject+Private.h"
#import "NSString+TGUtilities.h"

@interface TGUser (Testing)
@property (nonatomic, strong, readwrite) NSDate *lastLogin;
@end

@interface TGUserTests : TGTestCase

@end

@implementation TGUserTests

#pragma mark - User general -

- (void)testImagesDictionaryIsNotNil {
    TGUser *user = [[TGUser alloc] init];
    expect(user.images).toNot.beNil();
    expect(user.images).to.beKindOf([NSMutableDictionary class]);
}

#pragma mark - JSON to User -

#pragma mark - Correct

// [Correct] From JSON to User with all values
- (void)testInitUserWithDictionaryAll {
    NSDictionary *userData = @{
                               @"id":@(18446744073709551615),
                               @"custom_id":@"123456abc",
                               @"social_ids":@{
                                   @"abook":@"acc-1-app-1-user-2-abk",
                                   @"facebook":@"acc-1-app-1-user-2-fb",
                                   @"gplus":@"acc-1-app-1-user-2-gpl",
                                   @"twitter":@"acc-1-app-1-user-2-tw"
                               },
                               @"user_name":@"acc-1-app-1-user-2",
                               @"first_name":@"acc-1-app-1-user-2-first-name",
                               @"last_name":@"acc-1-app-1-user-2-last-name",
                               @"email":@"acc-1-app-1-user-2@tapglue-test.com",
                               @"url":@"app://tapglue.com/users/1/demouser",
                               @"metadata" : @{
                                       @"foo" : @"bar",
                                       @"amount" : @12,
                                       @"progress" : @0.95
                                       },
                               @"created_at": @"2015-06-01T08:44:57.144996856Z",
                               @"updated_at": @"2014-02-10T06:25:10.144996856Z"
                            };

    expect(userData).toNot.beNil();

    TGUser *user = [[TGUser alloc] initWithDictionary:userData];

    expect(user).toNot.beNil();

    // Check for correct values
    expect(user.userId).to.equal(@"18446744073709551615");
    expect(user.customId).to.equal(@"123456abc");
    expect(user.socialIds).to.equal(@{
                                      @"abook":@"acc-1-app-1-user-2-abk",
                                      @"facebook":@"acc-1-app-1-user-2-fb",
                                      @"gplus":@"acc-1-app-1-user-2-gpl",
                                      @"twitter":@"acc-1-app-1-user-2-tw"
                                      });
    expect([user socialIdForKey:@"abook"]).to.equal(@"acc-1-app-1-user-2-abk");
    expect([user socialIdForKey:@"facebook"]).to.equal(@"acc-1-app-1-user-2-fb");
    expect([user socialIdForKey:@"gplus"]).to.equal(@"acc-1-app-1-user-2-gpl");
    expect([user socialIdForKey:@"twitter"]).to.equal(@"acc-1-app-1-user-2-tw");
    expect([user socialIdForKey:@"undefined-key"]).to.beNil();
    expect(user.username).to.equal(@"acc-1-app-1-user-2");
    expect(user.firstName).to.equal(@"acc-1-app-1-user-2-first-name");
    expect(user.lastName).to.equal(@"acc-1-app-1-user-2-last-name");
    expect(user.email).to.equal(@"acc-1-app-1-user-2@tapglue-test.com");
    expect(user.url).to.equal(@"app://tapglue.com/users/1/demouser");
    expect([user.metadata objectForKey:@"foo"]).to.equal(@"bar");
    expect([user.metadata objectForKey:@"amount"]).to.equal(12);
    expect([user.metadata objectForKey:@"progress"]).to.equal(0.95);
    expect(user.createdAt).to.equal([NSDate dateWithTimeIntervalSince1970:1433148297]);
    expect(user.updatedAt).to.equal([NSDate dateWithTimeIntervalSince1970:1392013510]);

    // Check for correct types
    expect(user.userId).to.beKindOf([NSString class]);
    expect(user.customId).to.beKindOf([NSString class]);
    expect(user.socialIds).to.beKindOf([NSDictionary class]);
    expect([user socialIdForKey:@"abook"]).to.beKindOf([NSString class]);
    expect([user socialIdForKey:@"facebook"]).to.beKindOf([NSObject class]);
    expect([user socialIdForKey:@"gplus"]).to.beKindOf([NSObject class]);
    expect([user socialIdForKey:@"twitter"]).to.beKindOf([NSObject class]);
    expect(user.username).to.beKindOf([NSString class]);
    expect(user.firstName).to.beKindOf([NSString class]);
    expect(user.lastName).to.beKindOf([NSString class]);
    expect(user.email).to.beKindOf([NSString class]);
    expect(user.url).to.beKindOf([NSString class]);
    expect(user.metadata).to.beKindOf([NSDictionary class]);
    expect([user.metadata objectForKey:@"foo"]).to.beKindOf([NSString class]);
    expect([user.metadata objectForKey:@"amount"]).to.beKindOf([NSNumber class]);
    expect([user.metadata objectForKey:@"progress"]).to.beKindOf([NSNumber class]);
    expect(user.createdAt).to.beKindOf([NSDate class]);
    expect(user.updatedAt).to.beKindOf([NSDate class]);
}

// [Correct] From JSON to User with some values
- (void)testInitUserWithDictionaryAverage {
    NSDictionary *userData = @{
                               @"id":@(858667),
                               @"user_name":@"acc-1-app-1-user-2",
                               @"first_name":@"acc-1-app-1-user-2-first-name",
                               @"last_name":@"acc-1-app-1-user-2-last-name",
                               @"created_at": @"2015-06-01T08:44:57.144996856Z",
                               @"updated_at": @"2014-02-10T06:25:10.144996856Z"
                               };

    expect(userData).toNot.beNil();

    TGUser *user = [[TGUser alloc] initWithDictionary:userData];

    expect(user).toNot.beNil();

    // Check for correct values
    expect(user.userId).to.equal(@"858667");
    expect(user.username).to.equal(@"acc-1-app-1-user-2");
    expect(user.firstName).to.equal(@"acc-1-app-1-user-2-first-name");
    expect(user.lastName).to.equal(@"acc-1-app-1-user-2-last-name");
    expect(user.createdAt).to.equal([NSDate dateWithTimeIntervalSince1970:1433148297]);
    expect(user.updatedAt).to.equal([NSDate dateWithTimeIntervalSince1970:1392013510]);

    // Check for correct types
    expect(user.userId).to.beKindOf([NSString class]);
    expect(user.username).to.beKindOf([NSString class]);
    expect(user.firstName).to.beKindOf([NSString class]);
    expect(user.lastName).to.beKindOf([NSString class]);
    expect(user.createdAt).to.beKindOf([NSDate class]);
    expect(user.updatedAt).to.beKindOf([NSDate class]);
}

// [Correct] From JSON to User with only id and username
- (void)testInitUserWithDictionaryNameAndId {
    NSDictionary *userData = @{
                               @"id":@(858667),
                               @"user_name":@"acc-1-app-1-user-2"
                               };

    expect(userData).toNot.beNil();

    TGUser *user = [[TGUser alloc] initWithDictionary:userData];

    expect(user).toNot.beNil();

    // Check for correct values
    expect(user.userId).to.equal(@"858667");
    expect(user.username).to.equal(@"acc-1-app-1-user-2");

    // Check for correct types
    expect(user.userId).to.beKindOf([NSString class]);
    expect(user.username).to.beKindOf([NSString class]);
}


// [Correct] From JSON to User with only id and email
- (void)testInitUserWithDictionaryEmailAndId {
    NSDictionary *userData = @{
                               @"id":@(858667),
                               @"email":@"acc-1-app@tapglue.com"
                               };

    expect(userData).toNot.beNil();

    TGUser *user = [[TGUser alloc] initWithDictionary:userData];

    expect(user).toNot.beNil();

    // Check for correct values
    expect(user.userId).to.equal(@"858667");
    expect(user.email).to.equal(@"acc-1-app@tapglue.com");
}



// [Correct] From JSON to User with Metadata
- (void)testMetadataForUserInitWithDictionary {
    NSDictionary *userData = @{ @"id":@(858667),
                                @"user_name":@"acc-1-app-1-user-2",
                                @"metadata" : @{
                                        @"foo" : @"bar",
                                        @"amount" : @12,
                                        @"progress" : @0.95
                                        }
                                };

    TGUser *user = [[TGUser alloc] initWithDictionary:userData];

    // Check for correct values
    expect(user.userId).to.equal(@"858667");
    expect(user.username).to.equal(@"acc-1-app-1-user-2");

    expect(user.metadata).to.beKindOf([NSDictionary class]);

    expect([user.metadata objectForKey:@"foo"]).to.equal(@"bar");
    expect([user.metadata objectForKey:@"amount"]).to.equal(12);
    expect([user.metadata objectForKey:@"progress"]).to.equal(0.95);

    // Check for correct types
    expect(user.userId).to.beKindOf([NSString class]);
    expect(user.username).to.beKindOf([NSString class]);
    expect([user.metadata objectForKey:@"foo"]).to.beKindOf([NSString class]);
    expect([user.metadata objectForKey:@"amount"]).to.beKindOf([NSNumber class]);
    expect([user.metadata objectForKey:@"progress"]).to.beKindOf([NSNumber class]);
}

// [Correct] From JSON to User with Images
- (void)testImagesForUserInitWithDictionary {
    NSDictionary *userData = @{ @"id":@(858667),
                                @"user_name":@"acc-1-app-1-user-2",
                                @"images" : @{
                                        @"profile_thumb" : @{@"url": @"http://images.tapglue.com/1/demouser/profile.jpg"}
                                        }
                                };
    
    TGUser *user = [[TGUser alloc] initWithDictionary:userData];
    
    // Check for correct values
    expect(user.userId).to.equal(@"858667");
    expect(user.username).to.equal(@"acc-1-app-1-user-2");
    
    expect(user.images).to.beKindOf([NSDictionary class]);
    TGImage *profileImage = [user.images objectForKey:@"profile_thumb"];
    expect(profileImage).to.beKindOf([TGImage class]);
    expect(profileImage.url).to.equal(@"http://images.tapglue.com/1/demouser/profile.jpg");
}

// [Correct] From JSON to User with connection counts
- (void)testConnectionCountsForUserInitWithDictionary {
    NSDictionary *userData = @{ @"id":@(858667),
                                @"user_name":@"acc-1-app-1-user-2",
                                @"friend_count" : @12,
                                @"follower_count" : @123,
                                @"followed_count" : @57
                                };
    
    TGUser *user = [[TGUser alloc] initWithDictionary:userData];
    
    // Check for correct values
    expect(user.userId).to.equal(@"858667");
    expect(user.username).to.equal(@"acc-1-app-1-user-2");
    expect(user.friendsCount).to.equal(12);
    expect(user.followersCount).to.equal(123);
    expect(user.followingCount).to.equal(57);
}

// [Correct] From JSON to User with connection flags
- (void)testConnectionFlagsForUserInitWithDictionary {
    // test for true value
    NSDictionary *userData;
    TGUser *user;
    
    userData = @{ @"id":@(858667),
                  @"user_name":@"acc-1-app-1-user-2",
                  @"is_friend" : @YES,
                  @"is_follower" : @YES,
                  @"is_followed" : @YES
                  };
    
    user = [[TGUser alloc] initWithDictionary:userData];
    
    // Check for correct values
    expect(user.userId).to.equal(@"858667");
    expect(user.username).to.equal(@"acc-1-app-1-user-2");
    expect(user.isFriend).to.beTruthy();
    expect(user.isFollower).to.beTruthy();
    expect(user.isFollowed).to.beTruthy();
    

    // test for false values
    userData = @{ @"id":@(858667),
                  @"user_name":@"acc-1-app-1-user-2",
                  @"is_friend" : @NO,
                  @"is_follower" : @NO,
                  @"is_followed" : @NO
                  };
    
    user = [[TGUser alloc] initWithDictionary:userData];
    
    // Check for correct values
    expect(user.userId).to.equal(@"858667");
    expect(user.username).to.equal(@"acc-1-app-1-user-2");
    expect(user.isFriend).to.beFalsy();
    expect(user.isFollower).to.beFalsy();
    expect(user.isFollowed).to.beFalsy();
}

// [Correct] From JSON to User with Social IDs
- (void)testSocialIdsOnRetrievedObject {
    NSDictionary *userData = @{
                               @"id":@(858667),
                               @"social_ids":@{
                                       @"abook":@"acc-1-app-1-user-2-abk",
                                       @"facebook":@"acc-1-app-1-user-2-fb",
                                       @"gplus":@"acc-1-app-1-user-2-gpl",
                                       @"twitter":@"acc-1-app-1-user-2-tw"
                                       },
                               @"user_name":@"acc-1-app-1-user-2"
                               };
    TGUser *user = [[TGUser alloc] initWithDictionary:userData];

    // Check for correct values
    expect(user.userId).to.equal(@"858667");
    expect(user.username).to.equal(@"acc-1-app-1-user-2");

    expect(user.socialIds).to.equal(@{
                                      @"abook":@"acc-1-app-1-user-2-abk",
                                      @"facebook":@"acc-1-app-1-user-2-fb",
                                      @"gplus":@"acc-1-app-1-user-2-gpl",
                                      @"twitter":@"acc-1-app-1-user-2-tw"
                                      });

    expect([user socialIdForKey:@"abook"]).to.equal(@"acc-1-app-1-user-2-abk");
    expect([user socialIdForKey:@"facebook"]).to.equal(@"acc-1-app-1-user-2-fb");
    expect([user socialIdForKey:@"gplus"]).to.equal(@"acc-1-app-1-user-2-gpl");
    expect([user socialIdForKey:@"twitter"]).to.equal(@"acc-1-app-1-user-2-tw");

    expect([user socialIdForKey:@"undefined-key"]).to.beNil();

    // Check for correct types
    expect(user.userId).to.beKindOf([NSString class]);
    expect(user.username).to.beKindOf([NSString class]);
    expect([user socialIdForKey:@"abook"]).to.beKindOf([NSString class]);
    expect([user socialIdForKey:@"facebook"]).to.beKindOf([NSString class]);
    expect([user socialIdForKey:@"gplus"]).to.beKindOf([NSString class]);
    expect([user socialIdForKey:@"twitter"]).to.beKindOf([NSString class]);
}

// [Correct] Set Social IDs From JSON
- (void)testSetSocialIdOnRetrievedObject {
    NSDictionary *userData = @{
                               @"id":@(858667),
                               @"social_ids":@{
                                       @"facebook":@"acc-1-app-1-user-2-fb"
                                       },
                               @"user_name":@"acc-1-app-1-user-2"
                               };

    TGUser *user = [[TGUser alloc] initWithDictionary:userData];
    expect([user socialIdForKey:@"facebook"]).to.equal(@"acc-1-app-1-user-2-fb");

    [user setSocialId:@"some-new-facebook-id-10234123" forKey:@"facebook"];
    expect([user socialIdForKey:@"facebook"]).to.equal(@"some-new-facebook-id-10234123");
}

- (void)testLoadDataIntoExistingUserWithDictionaryAll {
    NSDictionary *userData = @{
                               @"id":@(18446744073709551615),
                               @"custom_id":@"123456abc",
                               @"social_ids":@{
                                       @"abook":@"acc-1-app-1-user-2-abk",
                                       @"facebook":@"acc-1-app-1-user-2-fb",
                                       @"gplus":@"acc-1-app-1-user-2-gpl",
                                       @"twitter":@"acc-1-app-1-user-2-tw"
                                       },
                               @"user_name":@"acc-1-app-1-user-2",
                               @"first_name":@"acc-1-app-1-user-2-first-name",
                               @"last_name":@"acc-1-app-1-user-2-last-name",
                               @"email":@"acc-1-app-1-user-2@tapglue-test.com",
                               @"url":@"app://tapglue.com/users/1/demouser",
                               @"metadata" : @{
                                       @"foo" : @"bar",
                                       @"amount" : @12,
                                       @"progress" : @0.95
                                       },
                               @"created_at": @"2015-06-01T08:44:57.144996856Z",
                               @"updated_at": @"2014-02-10T06:25:10.144996856Z"
                               };
    
    TGUser *user = [[TGUser alloc] init];
    expect(user).toNot.beNil();
    [user loadDataFromDictionary:userData];
    
    // Check for correct values
    expect(user.userId).to.equal(@"18446744073709551615");
    expect(user.customId).to.equal(@"123456abc");
    expect(user.socialIds).to.equal(@{
                                      @"abook":@"acc-1-app-1-user-2-abk",
                                      @"facebook":@"acc-1-app-1-user-2-fb",
                                      @"gplus":@"acc-1-app-1-user-2-gpl",
                                      @"twitter":@"acc-1-app-1-user-2-tw"
                                      });
    expect([user socialIdForKey:@"abook"]).to.equal(@"acc-1-app-1-user-2-abk");
    expect([user socialIdForKey:@"facebook"]).to.equal(@"acc-1-app-1-user-2-fb");
    expect([user socialIdForKey:@"gplus"]).to.equal(@"acc-1-app-1-user-2-gpl");
    expect([user socialIdForKey:@"twitter"]).to.equal(@"acc-1-app-1-user-2-tw");
    expect([user socialIdForKey:@"undefined-key"]).to.beNil();
    expect(user.username).to.equal(@"acc-1-app-1-user-2");
    expect(user.firstName).to.equal(@"acc-1-app-1-user-2-first-name");
    expect(user.lastName).to.equal(@"acc-1-app-1-user-2-last-name");
    expect(user.email).to.equal(@"acc-1-app-1-user-2@tapglue-test.com");
    expect(user.url).to.equal(@"app://tapglue.com/users/1/demouser");
    expect([user.metadata objectForKey:@"foo"]).to.equal(@"bar");
    expect([user.metadata objectForKey:@"amount"]).to.equal(12);
    expect([user.metadata objectForKey:@"progress"]).to.equal(0.95);
    expect(user.createdAt).to.equal([NSDate dateWithTimeIntervalSince1970:1433148297]);
    expect(user.updatedAt).to.equal([NSDate dateWithTimeIntervalSince1970:1392013510]);
    
    // Check for correct types
    expect(user.userId).to.beKindOf([NSString class]);
    expect(user.customId).to.beKindOf([NSString class]);
    expect(user.socialIds).to.beKindOf([NSDictionary class]);
    expect([user socialIdForKey:@"abook"]).to.beKindOf([NSString class]);
    expect([user socialIdForKey:@"facebook"]).to.beKindOf([NSObject class]);
    expect([user socialIdForKey:@"gplus"]).to.beKindOf([NSObject class]);
    expect([user socialIdForKey:@"twitter"]).to.beKindOf([NSObject class]);
    expect(user.username).to.beKindOf([NSString class]);
    expect(user.firstName).to.beKindOf([NSString class]);
    expect(user.lastName).to.beKindOf([NSString class]);
    expect(user.email).to.beKindOf([NSString class]);
    expect(user.url).to.beKindOf([NSString class]);
    expect(user.metadata).to.beKindOf([NSDictionary class]);
    expect([user.metadata objectForKey:@"foo"]).to.beKindOf([NSString class]);
    expect([user.metadata objectForKey:@"amount"]).to.beKindOf([NSNumber class]);
    expect([user.metadata objectForKey:@"progress"]).to.beKindOf([NSNumber class]);
    expect(user.createdAt).to.beKindOf([NSDate class]);
    expect(user.updatedAt).to.beKindOf([NSDate class]);
}

#pragma mark - Negative

// [Negative] From JSON to User with without id
- (void)testInitUserWithDictionaryNoId {
    NSDictionary *userData = @{
                               @"user_name":@"acc-1-app-1-user-2"
                               };

    expect(userData).toNot.beNil();

    TGUser *user = [[TGUser alloc] initWithDictionary:userData];

    expect(user).to.beNil();
}

// [Negative] From JSON to User with without username or email
- (void)testInitUserWithDictionaryNoUsername {
    NSDictionary *userData = @{
                               @"id":@(858667)
                               };

    expect(userData).toNot.beNil;
    expect(userData).to.haveACountOf(1);

    TGUser *user = [[TGUser alloc] initWithDictionary:userData];
    expect(user).to.beNil();
}

// [Negative] From JSON to User with wrong username type
- (void)testInitUserWithDictionaryWrongUsernameType {
    NSDictionary *userData = @{
                               @"id":@(858667),
                               @"user_name":@123
                               };

    TGUser *user = [[TGUser alloc] initWithDictionary:userData];
    expect(user).to.beNil();
}

// [Negative] From JSON to User without data
- (void)testInitUserWithDictionaryNoData {
    NSDictionary *userData = @{};

    TGUser *user = [[TGUser alloc] initWithDictionary:userData];
    expect(user).to.beNil();
}

// [Negative] From JSON to User with wrong username key
- (void)testInitUserWithDictionaryWrongUsernameKey {
    NSDictionary *userData = @{
                               @"id":@(858667),
                               @"username":@"acc-1-app-1-user-2"
                               };

    expect(userData).toNot.beNil();

    TGUser *user = [[TGUser alloc] initWithDictionary:userData];

    expect(user).to.beNil();
}

#pragma mark - User to JSON -

#pragma mark - Correct

// [Correct] From User to JSON for all values
- (void)testUserJsonDictionaryAll {

    TGUser *user = [[TGUser alloc] init];
    user.objectId = @"3242398239823";
    user.customId = @"123456abc";
    [user setSocialId:@"acc-1-app-1-user-2-abk" forKey:@"abook"];
    [user setSocialId:@"acc-1-app-1-user-2-fb" forKey:@"facebook"];
    [user setSocialId:@"acc-1-app-1-user-2-gpl" forKey:@"gplus"];
    [user setSocialId:@"acc-1-app-1-user-2-tw" forKey:@"twitter"];
    user.username = @"acc-1-app-1-user-2";
    user.firstName = @"acc-1-app-1-user-2-first-name";
    user.lastName = @"acc-1-app-1-user-2-last-name";
    user.email = @"acc-1-app-1-user-2@tapglue-test.com";
    user.url = @"app://tapglue.com/users/1/demouser";
    user.metadata = @{
                        @"foo" : @"bar",
                        @"amount" : @12,
                        @"progress" : @0.95
                    };

    NSDictionary *jsonDictionary = user.jsonDictionary;
    expect([NSJSONSerialization isValidJSONObject:jsonDictionary]).to.beTruthy();

    expect(jsonDictionary.count).to.equal(9);

    // Check for correct values
    expect([jsonDictionary valueForKey:@"id"]).to.equal(3242398239823);
    expect([jsonDictionary valueForKey:@"user_name"]).to.equal(@"acc-1-app-1-user-2");
    expect([jsonDictionary valueForKey:@"custom_id"]).to.equal(@"123456abc");
    expect([jsonDictionary valueForKey:@"social_ids"]).to.equal(@{
                                                                  @"abook":@"acc-1-app-1-user-2-abk",
                                                                  @"facebook":@"acc-1-app-1-user-2-fb",
                                                                  @"gplus":@"acc-1-app-1-user-2-gpl",
                                                                  @"twitter":@"acc-1-app-1-user-2-tw"
                                                                  });
    expect([user socialIdForKey:@"abook"]).to.equal(@"acc-1-app-1-user-2-abk");
    expect([user socialIdForKey:@"facebook"]).to.equal(@"acc-1-app-1-user-2-fb");
    expect([user socialIdForKey:@"gplus"]).to.equal(@"acc-1-app-1-user-2-gpl");
    expect([user socialIdForKey:@"twitter"]).to.equal(@"acc-1-app-1-user-2-tw");
    expect([jsonDictionary valueForKey:@"first_name"]).to.equal(@"acc-1-app-1-user-2-first-name");
    expect([jsonDictionary valueForKey:@"last_name"]).to.equal(@"acc-1-app-1-user-2-last-name");
    expect([jsonDictionary valueForKey:@"email"]).to.equal(@"acc-1-app-1-user-2@tapglue-test.com");
    expect([jsonDictionary valueForKey:@"url"]).to.equal(@"app://tapglue.com/users/1/demouser");
    expect([jsonDictionary valueForKey:@"metadata"]).to.equal(@{
                                                                @"foo" : @"bar",
                                                                @"amount" : @12,
                                                                @"progress" : @0.95
                                                                });

    // Check for correct types
    [self validateDataTypesForUserJsonDictionary:jsonDictionary];
}

// [Correct] From User to JSON for values with nil
- (void)testJsonDictionaryWithNil {

    TGUser *user = [[TGUser alloc] init];
    user.customId = @"123456abc";
    user.username = @"acc-1-app-1-user-2";
    user.firstName = @"acc-1-app-1-user-2-first-name";
    user.lastName = @"acc-1-app-1-user-2-last-name";
    user.url = NULL;

    NSDictionary *jsonDictionary = user.jsonDictionary;
    expect([NSJSONSerialization isValidJSONObject:jsonDictionary]).to.beTruthy();

    expect(jsonDictionary.count).to.equal(4);


    // Check for correct values
    expect([jsonDictionary valueForKey:@"user_name"]).to.equal(@"acc-1-app-1-user-2");
    expect([jsonDictionary valueForKey:@"custom_id"]).to.equal(@"123456abc");
    expect([jsonDictionary valueForKey:@"first_name"]).to.equal(@"acc-1-app-1-user-2-first-name");
    expect([jsonDictionary valueForKey:@"last_name"]).to.equal(@"acc-1-app-1-user-2-last-name");
    expect([jsonDictionary valueForKey:@"url"]).to.equal(nil);
    expect([jsonDictionary valueForKey:@"email"]).to.equal(nil);

    // Check for correct types
    [self validateDataTypesForUserJsonDictionary:jsonDictionary];
}

// [Correct] From User to JSON only username
- (void)testUserJsonDictionaryWithOnlyUsername {

    TGUser *user = [[TGUser alloc] init];
    user.username = @"acc-1-app-1-user-2";

    NSDictionary *jsonDictionary = user.jsonDictionary;

    [self validateDataTypesForUserJsonDictionary:jsonDictionary];

    // Check for correct values
    expect([jsonDictionary valueForKey:@"user_name"]).to.equal(@"acc-1-app-1-user-2");
    expect(jsonDictionary.count).to.equal(1);

    expect([jsonDictionary valueForKey:@"custom_id"]).to.beNil();
    expect([jsonDictionary valueForKey:@"first_name"]).to.beNil();
    expect([jsonDictionary valueForKey:@"last_name"]).to.beNil();
    expect([jsonDictionary valueForKey:@"email"]).to.beNil();
    expect([jsonDictionary valueForKey:@"password"]).to.beNil();
    expect([jsonDictionary valueForKey:@"url"]).to.beNil();
    expect([jsonDictionary valueForKey:@"social_ids"]).to.beNil();


}


// [Correct] From User to JSON for values with nil
- (void)testJsonDictionaryWithLastLoginDate {

    TGUser *user = [[TGUser alloc] init];
    user.username = @"acc-1-app-1-user-2";
    user.lastLogin = [NSDate date];

    NSDictionary *jsonDictionary = user.jsonDictionary;
    expect([NSJSONSerialization isValidJSONObject:jsonDictionary]).to.beTruthy();

    // Check for correct values
    expect([jsonDictionary valueForKey:@"user_name"]).to.equal(@"acc-1-app-1-user-2");
    expect([jsonDictionary valueForKey:@"last_login"]).to.beNil();

    // Check for correct types
    [self validateDataTypesForUserJsonDictionary:jsonDictionary];
}

// [Correct] From User to JSON with images
- (void)testJsonDictionaryWithImagesAsNSDictionary {
    
    TGUser *user = [[TGUser alloc] init];
    user.username = @"acc-1-app-1-user-2";
    user.images =  @{@"profile_thumb" : @{
                             @"url": @"http://images.tapglue.com/1/demouser/profile.jpg",
                             @"type" : @"some type",
                             @"width" : @800,
                             @"height" : @600
                             }
                     };
    
    NSDictionary *jsonDictionary = user.jsonDictionary;
    expect([NSJSONSerialization isValidJSONObject:jsonDictionary]).to.beTruthy();
    
    // Check for correct values
    expect([jsonDictionary valueForKey:@"user_name"]).to.equal(@"acc-1-app-1-user-2");
    NSDictionary *imagesJsonDictionary = [jsonDictionary valueForKey:@"images"];
    expect(imagesJsonDictionary).to.beKindOf([NSDictionary class]);
    expect([imagesJsonDictionary valueForKey:@"profile_thumb"]).to.to.beKindOf([NSDictionary class]);
    expect([imagesJsonDictionary valueForKeyPath:@"profile_thumb.url"]).to.equal(@"http://images.tapglue.com/1/demouser/profile.jpg");
    expect([imagesJsonDictionary valueForKeyPath:@"profile_thumb.type"]).to.equal(@"some type");
    expect([imagesJsonDictionary valueForKeyPath:@"profile_thumb.width"]).to.equal(800);
    expect([imagesJsonDictionary valueForKeyPath:@"profile_thumb.height"]).to.equal(600);

    // Check for correct types
    [self validateDataTypesForUserJsonDictionary:jsonDictionary];
}

// [Correct] From User to JSON with images
- (void)testJsonDictionaryWithImagesAsTGImage {
    
    TGImage *image = [[TGImage alloc] init];
    image.url = [NSURL URLWithString:@"http://images.tapglue.com/1/demouser/profile.jpg"];
    image.type = @"some type";
    image.size = CGSizeMake(800, 600);
    
    TGUser *user = [[TGUser alloc] init];
    user.username = @"acc-1-app-1-user-2";
    user.images =  @{@"profile_thumb" : image};
    
    NSDictionary *jsonDictionary = user.jsonDictionary;
    expect([NSJSONSerialization isValidJSONObject:jsonDictionary]).to.beTruthy();
    
    // Check for correct values
    expect([jsonDictionary valueForKey:@"user_name"]).to.equal(@"acc-1-app-1-user-2");
    NSDictionary *imagesJsonDictionary = [jsonDictionary valueForKey:@"images"];
    expect(imagesJsonDictionary).to.beKindOf([NSDictionary class]);
    expect([imagesJsonDictionary valueForKey:@"profile_thumb"]).to.to.beKindOf([NSDictionary class]);
    expect([imagesJsonDictionary valueForKeyPath:@"profile_thumb.url"]).to.equal(@"http://images.tapglue.com/1/demouser/profile.jpg");
    expect([imagesJsonDictionary valueForKeyPath:@"profile_thumb.type"]).to.equal(@"some type");
    expect([imagesJsonDictionary valueForKeyPath:@"profile_thumb.width"]).to.equal(800);
    expect([imagesJsonDictionary valueForKeyPath:@"profile_thumb.height"]).to.equal(600);
    
    // Check for correct types
    [self validateDataTypesForUserJsonDictionary:jsonDictionary];
}



// [Correct] From User to JSON with connection counts
- (void)testJsonDictionaryDoesNotIncludeConnectionCounts {
    // execption: need to create the user with a dictionary as the connection count properties are read only
    TGUser *user = [[TGUser alloc] initWithDictionary:@{ @"id":@(858667),
                                                         @"user_name":@"acc-1-app-1-user-2",
                                                         @"friends" : @12,
                                                         @"followers" : @123,
                                                         @"following" : @57
                                                         }];
    
    NSDictionary *jsonDictionary = user.jsonDictionary;
    expect([NSJSONSerialization isValidJSONObject:jsonDictionary]).to.beTruthy();
    
    // Check for correct values
    expect([jsonDictionary valueForKey:@"user_name"]).to.equal(@"acc-1-app-1-user-2");
    expect([jsonDictionary valueForKey:@"friends"]).to.beNil();
    expect([jsonDictionary valueForKey:@"followers"]).to.beNil();
    expect([jsonDictionary valueForKey:@"following"]).to.beNil();
    
    // Check for correct types
    [self validateDataTypesForUserJsonDictionary:jsonDictionary];
}

// [Correct] From User to JSON with connection flags
- (void)testJsonDictionaryDoesNotIncludeConnectionFlags {
    // execption: need to create the user with a dictionary as the connection flags properties are read only
    TGUser *user;
    NSDictionary *jsonDictionary;
    
    // test for true value

    user = [[TGUser alloc] initWithDictionary:@{ @"id":@(858667),
                                                 @"user_name":@"acc-1-app-1-user-2",
                                                 @"is_friend" : @YES,
                                                 @"is_follower" : @YES,
                                                 @"is_followed" : @YES
                                                 }];
    jsonDictionary = user.jsonDictionary;
    expect([NSJSONSerialization isValidJSONObject:jsonDictionary]).to.beTruthy();
    
    // Check for correct values
    expect([jsonDictionary valueForKey:@"user_name"]).to.equal(@"acc-1-app-1-user-2");
    expect([jsonDictionary valueForKey:@"is_friend"]).to.beNil();
    expect([jsonDictionary valueForKey:@"is_follower"]).to.beNil();
    expect([jsonDictionary valueForKey:@"is_followed"]).to.beNil();
    
    // Check for correct types
    [self validateDataTypesForUserJsonDictionary:jsonDictionary];

    
    // test for false values
    
    user = [[TGUser alloc] initWithDictionary:@{ @"id":@(858667),
                                                 @"user_name":@"acc-1-app-1-user-2",
                                                 @"is_friend" : @NO,
                                                 @"is_follower" : @NO,
                                                 @"is_followed" : @NO
                                                 }];
    jsonDictionary = user.jsonDictionary;
    expect([NSJSONSerialization isValidJSONObject:jsonDictionary]).to.beTruthy();
    
    // Check for correct values
    expect([jsonDictionary valueForKey:@"user_name"]).to.equal(@"acc-1-app-1-user-2");
    expect([jsonDictionary valueForKey:@"is_friend"]).to.beNil();
    expect([jsonDictionary valueForKey:@"is_follower"]).to.beNil();
    expect([jsonDictionary valueForKey:@"is_followed"]).to.beNil();
    
    // Check for correct types
    [self validateDataTypesForUserJsonDictionary:jsonDictionary];
}


#pragma mark - Negative

// [Negative] From User to JSON no data
- (void)testUserJsonDictionaryNoData {

    TGUser *user = [[TGUser alloc] init];

    NSDictionary *jsonDictionary = user.jsonDictionary;
    expect([NSJSONSerialization isValidJSONObject:jsonDictionary]).to.beTruthy();

    [self falsifyJsonDictionary:jsonDictionary];
}

#pragma mark - Helper -

#pragma mark - JSONDictionary


// Helper to validate jsonDictionary types
- (void)validateDataTypesForUserJsonDictionary:(NSDictionary*)jsonDictionary {
    expect([NSJSONSerialization isValidJSONObject:jsonDictionary]).to.beTruthy();
    expect([jsonDictionary valueForKey:@"id"]).to.beKindOfOrNil([NSNumber class]);
    expect([jsonDictionary valueForKey:@"user_name"]).to.beKindOfOrNil([NSString class]);
    expect([jsonDictionary valueForKey:@"custom_id"]).to.beKindOfOrNil([NSString class]);
    expect([jsonDictionary valueForKey:@"first_name"]).to.beKindOfOrNil([NSString class]);
    expect([jsonDictionary valueForKey:@"last_name"]).to.beKindOfOrNil([NSString class]);
    expect([jsonDictionary valueForKey:@"email"]).to.beKindOfOrNil([NSString class]);
    expect([jsonDictionary valueForKey:@"url"]).to.beKindOfOrNil([NSString class]);
    expect([jsonDictionary valueForKey:@"social_ids"]).to.beKindOfOrNil([NSDictionary class]);
    expect([jsonDictionary valueForKey:@"metadata"]).to.beKindOfOrNil([NSDictionary class]);
    expect([jsonDictionary valueForKey:@"activated"]).to.beNil();
    expect([jsonDictionary valueForKey:@"last_login"]).to.beNil();
    expect([jsonDictionary valueForKey:@"random_key"]).to.beNil();
}

// Helper to falisfy jsonDictionary
- (void)falsifyJsonDictionary:(NSDictionary*)jsonDictionary {
    expect([NSJSONSerialization isValidJSONObject:jsonDictionary]).to.beTruthy();
    expect([jsonDictionary valueForKey:@"custom_id"]).to.beNil();
    expect([jsonDictionary valueForKey:@"user_name"]).to.beNil();
    expect([jsonDictionary valueForKey:@"password"]).to.beNil();
    expect([jsonDictionary valueForKey:@"first_name"]).to.beNil();
    expect([jsonDictionary valueForKey:@"last_name"]).to.beNil();
    expect([jsonDictionary valueForKey:@"random_key"]).to.beNil();
}

#pragma mark - Password

- (void)testPasswordHashing {
    TGUser *user = [[TGUser alloc] init];
    [user setPassword:@"password"];
    expect(user.hashedPassword).to.equal(@"89b1af261b009d79687506151b0367edabaae9ae");
}

- (void)testPBKDF2Hashing {
    expect([@"password" tg_stringHashedViaPBKDF2]).to.equal(@"89b1af261b009d79687506151b0367edabaae9ae");
    expect([@"blume1985" tg_stringHashedViaPBKDF2]).to.equal(@"566378eb56710135af9acd25deb1c0b25306a629");
    expect([@"er[orf=A>kij$G" tg_stringHashedViaPBKDF2]).to.equal(@"cffaf3a29be6fb7964b1a73874bc3fc4acb4d07c");
}

// TODO: test for setting meta data and checking the user json dict

#pragma mark - Social IDs

// [Correct] Social ID Setters
- (void)testSetSocialIdLanguageOnNewObject {
    TGUser *user = [TGUser new];
    expect(user.socialIds).to.equal(@{});
    expect([user socialIdForKey:@"facebook"]).to.beNil();
    [user setSocialId:@"acc-1-app-1-user-2-fb" forKey:@"facebook"];
    expect([user socialIdForKey:@"facebook"]).to.equal(@"acc-1-app-1-user-2-fb");
}

#pragma mark - Current User

- (void)testArchiveAndLoadCurrentUser {
    // need to comment out currentUser mock in TGEventManagerTests 
    [Tapglue setUpWithAppToken:self.appToken];
    
    NSDictionary *userData = @{
                               @"id":@(858667),
                               @"custom_id":@"123456abc",
                               @"social_ids":@{
                                       @"abook":@"acc-1-app-1-user-2-abk",
                                       @"facebook":@"acc-1-app-1-user-2-fb",
                                       @"gplus":@"acc-1-app-1-user-2-gpl",
                                       @"twitter":@"acc-1-app-1-user-2-tw"
                                       },
                               @"user_name":@"acc-1-app-1-user-2",
                               @"first_name":@"acc-1-app-1-user-2-first-name",
                               @"last_name":@"acc-1-app-1-user-2-last-name",
                               @"email":@"acc-1-app-1-user-2@tapglue-test.com",
                               @"url":@"app://tapglue.com/users/1/demouser",
                               @"friend_count" : @(14),
                               @"follower_count" : @(124),
                               @"followed_count" : @(40),
                               @"images" : @{
                                       @"thumbnail" : @{
                                               @"url" : @"http://images.tapglue.com/img55555555.png",
                                               @"type" : @"image/png",
                                               @"height" : @(200),
                                               @"width" : @(300)
                                               },
                                       @"medium" : @{
                                               @"url" : @"http://images.tapglue.com/img6666.png",
                                               @"type" : @"image/png",
                                               @"height" : @(400),
                                               @"width" : @(600)
                                               },
                                       @"large" :  @{
                                               @"url" : @"http://images.tapglue.com/imageurl634z34z734z7.png",
                                               @"type" : @"image/png",
                                               @"height" : @(1280),
                                               @"width" : @(720)
                                               }
                                       },
                               @"metadata" : @{
                                       @"foo" : @"bar",
                                       @"amount" : @12,
                                       @"progress" : @0.95
                                       },
                               @"created_at": @"2015-06-01T08:44:57.144996856Z",
                               @"updated_at": @"2014-02-10T06:25:10.144996856Z"
                               };
    TGUser *user = [[TGUser alloc] initWithDictionary:userData];
    [TGUser setCurrentUser:user];
    
    
    // setting the current user to nil will remove the data
    // so to simulate an cold app launch we need to save it and set it back in
    NSUserDefaults *userDefaults = [Tapglue sharedInstance].userDefaults;
    id currentUserData = [userDefaults objectForKey:@"current_user"];
    
    // remove the user to force reloading it for the user defaults
    [TGUser setCurrentUser:nil];
    
    // reset the user defaults which just have been removed by setting the current user to nil
    [[Tapglue sharedInstance].userDefaults setObject:currentUserData forKey:@"current_user"];

    TGUser *reloadedCurrentUser = [TGUser currentUser];
    expect(reloadedCurrentUser.userId).to.equal(@"858667");
    expect(reloadedCurrentUser.username).to.equal(@"acc-1-app-1-user-2");
    expect(reloadedCurrentUser.firstName).to.equal(@"acc-1-app-1-user-2-first-name");
    expect(reloadedCurrentUser.lastName).to.equal(@"acc-1-app-1-user-2-last-name");
    expect(reloadedCurrentUser.email).to.equal(@"acc-1-app-1-user-2@tapglue-test.com");
    expect(reloadedCurrentUser.url).to.equal(@"app://tapglue.com/users/1/demouser");
    expect(reloadedCurrentUser.friendsCount).to.equal(14);
    expect(reloadedCurrentUser.followersCount).to.equal(124);
    expect(reloadedCurrentUser.followingCount).to.equal(40);
    expect(reloadedCurrentUser.metadata).to.equal(@{
                    @"foo" : @"bar",
                    @"amount" : @12,
                    @"progress" : @0.95
                    });
    
    expect(reloadedCurrentUser.images.count).to.equal(3);
}

@end
