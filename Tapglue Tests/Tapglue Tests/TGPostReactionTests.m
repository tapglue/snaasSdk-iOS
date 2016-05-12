//
//  TGReactionTests.m
//  Tapglue Tests
//
//  Created by Martin Stemmle on 08/12/15.
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
#import "TGPost.h"
#import "TGAttachment.h"
#import "TGReaction+Private.h"
#import "TGComment.h"
#import "TGLike.h"
#import "TGModelObject+Private.h"
#import "TGEvent+RandomTestEvent.h"
#import "NSDateFormatter+TGISOFormatter.h"

@interface TGReactionTests : TGTestCase
@property (nonatomic, strong) TGUser *poster;
@property (nonatomic, strong) TGUser *reader;
@property (nonatomic, strong) TGPost *post;
@end

@implementation TGReactionTests

- (void)setUp {
    [super setUp];

    // create a test user
    self.poster = [TGUser createOrLoadWithDictionary:@{
                                                       @"id" : @(858667),
                                                       @"user_name" : @"awesome-poster-1984"
                                                       }];
    
    self.reader = [TGUser createOrLoadWithDictionary:@{
                                                       @"id" : @(998667),
                                                       @"user_name" : @"funTuber47"
                                                       }];
    
    self.post = [TGPost createOrLoadWithDictionary:@{
                                                     @"id" : @(471739965702621007),
                                                     @"user_id" : @(858667),
                                                     @"visibility": @(30),
                                                     @"tags": @[@"fitness",@"running"],
                                                     @"attachments" : @[
                                                             @{
                                                                 @"content": @"http://bit.ly/123.gif",
                                                                 @"name": @"teaser",
                                                                 @"type": @"url"
                                                                 },
                                                             @{
                                                                 @"content": @"Lorem ipsum...",
                                                                 @"name": @"body",
                                                                 @"type": @"text"
                                                                 }
                                                             ],
                                                     @"created_at": @"2015-06-01T08:44:57.144996856Z",
                                                     @"updated_at": @"2014-02-10T06:25:10.144996856Z"}];
}


- (void)testInitCommentWithDictionary {
    TGComment *comment = [[TGComment alloc] initWithDictionary:@{ @"id": @"12743631303647840",
                                                                         @"post_id": @"471739965702621007",
                                                                         @"user_id": @"998667",
                                                                         @"contents": @{@"en":@"Do like."},
                                                                         @"created_at": @"2015-06-01T08:44:57.144996856Z",
                                                                         @"updated_at": @"2014-02-10T06:25:10.144996856Z" }];

    expect(comment).toNot.beNil();

    // Check for correct values
    expect(comment.objectId).to.equal(@"12743631303647840");
    expect(comment.post).to.equal(self.post);
    expect(comment.user).to.equal(self.reader);
    expect(comment.contents).to.equal(@{@"en":@"Do like."});
    expect(comment.createdAt).to.equal([NSDate dateWithTimeIntervalSince1970:1433148297]);
    expect(comment.updatedAt).to.equal([NSDate dateWithTimeIntervalSince1970:1392013510]);
}


- (void)testJsonDictionaryForComment {
    TGComment *comment = [TGComment new];
    comment.post = self.post;
    comment.user = self.reader;
    comment.contents = @{@"es":@"funny 😀"};
    
    NSDictionary *jsonDictionary = comment.jsonDictionary;
    expect([NSJSONSerialization isValidJSONObject:jsonDictionary]).to.beTruthy();
    expect(jsonDictionary.count).to.equal(3);
    
    // Check for correct values
    expect([jsonDictionary valueForKey:@"user_id"]).to.equal(@"998667");
    expect([jsonDictionary valueForKey:@"post_id"]).to.equal(@"471739965702621007");
    expect([jsonDictionary valueForKey:@"contents"]).to.equal(@{@"es":@"funny 😀"});
}

- (void)testLoadDataOnComment {
    TGComment *comment = [TGComment new];
    comment.post = self.post;
    comment.user = self.reader;
    comment.contents = @{@"en":@"funny 😀"};
    
    NSMutableDictionary *jsonDictionary = comment.jsonDictionary.mutableCopy;
    expect([NSJSONSerialization isValidJSONObject:jsonDictionary]).to.beTruthy();
    expect(jsonDictionary.count).to.equal(3);
    jsonDictionary[@"id"] = @"1092381209";
    
    [comment loadDataFromDictionary:jsonDictionary];

    expect(comment.objectId).to.equal(@"1092381209");
    expect(comment.user).to.equal(self.reader);
    expect(comment.post).to.equal(self.post);
    expect(comment.contents).to.equal(@{@"en":@"funny 😀"});
}

- (void)testInitLikeWithDictionary {
    TGLike *like = [[TGLike alloc] initWithDictionary:@{ @"id": @"12743631303647840",
                                                                 @"post_id": @"471739965702621007",
                                                                 @"user_id": @"998667",
                                                                 @"created_at": @"2015-06-01T08:44:57.144996856Z",
                                                                 @"updated_at": @"2014-02-10T06:25:10.144996856Z" }];
    
    expect(like).toNot.beNil();
    
    // Check for correct values
    expect(like.objectId).to.equal(@"12743631303647840");
    expect(like.post).to.equal(self.post);
    expect(like.user).to.equal(self.reader);
    expect(like.createdAt).to.equal([NSDate dateWithTimeIntervalSince1970:1433148297]);
    expect(like.updatedAt).to.equal([NSDate dateWithTimeIntervalSince1970:1392013510]);
}


- (void)testJsonDictionaryForLike {
    TGLike *like = [TGLike new];
    like.post = self.post;
    like.user = self.reader;
    
    NSDictionary *jsonDictionary = like.jsonDictionary;
    expect([NSJSONSerialization isValidJSONObject:jsonDictionary]).to.beTruthy();
    expect(jsonDictionary.count).to.equal(2);
    
    // Check for correct values
    expect([jsonDictionary valueForKey:@"user_id"]).to.equal(@"998667");
    expect([jsonDictionary valueForKey:@"post_id"]).to.equal(@"471739965702621007");
}

@end
