//
//  TGPostTests.m
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
#import "TGImage.h"
#import "TGEventObject.h"
#import "TGModelObject+Private.h"
#import "TGEvent+RandomTestEvent.h"
#import "NSDateFormatter+TGISOFormatter.h"

@interface TGPostTests : TGTestCase

@end

@implementation TGPostTests

- (void)setUp {
    [super setUp];

    // create a test user
    [TGUser createOrLoadWithDictionary:@{
                                         @"id" : @(858667),
                                         @"user_name" : @"testuser"
                                         }];
}


- (void)testInitPostWithDictionaryAllButNoCounts {
    NSDictionary *postData = @{
                                @"id" : @(471739965702621007),
                                @"user_id" : @(858667),
                                @"visibility": @(30),
                                @"tags": @[@"fitness",@"running"],
                                @"attachments" : @[
                                        @{
                                            @"contents": @{@"en":@"http://bit.ly/123.gif"},
                                            @"name": @"teaser",
                                            @"type": @"url"
                                        },
                                        @{
                                            @"contents": @{@"es":@"Lorem ipsum..."},
                                            @"name": @"body",
                                            @"type": @"text"
                                        }
                                        ],
                                @"created_at": @"2015-06-01T08:44:57.144996856Z",
                                @"updated_at": @"2014-02-10T06:25:10.144996856Z"};
    
    TGPost *post = [[TGPost alloc] initWithDictionary:postData];
    
    expect(post).toNot.beNil();
    
    // Check for correct values
    expect(post.objectId).to.equal(@"471739965702621007");
    expect(post.user).toNot.beNil();
    expect(post.user.userId).to.equal(@"858667");
    expect(post.user.username).to.equal(@"testuser");
    expect(post.visibility).to.equal(TGVisibilityPublic);

    expect(post.tags.count).to.equal(2),
    expect(post.tags).to.contain(@"fitness");
    expect(post.tags).to.contain(@"running");

    expect(post.attachments.count).to.equal(2);
    TGAttachment *attachment1 = post.attachments[0];
    TGAttachment *attachment2 = post.attachments[1];
    expect(attachment1).to.beKindOf([TGAttachment class]);
    expect(attachment1.type).to.equal(@"url");
    expect(attachment1.name).to.equal(@"teaser");
    expect(attachment1.contents[@"en"]).to.equal(@"http://bit.ly/123.gif");
    
    expect(attachment2).to.beKindOf([TGAttachment class]);
    expect(attachment2.type).to.equal(@"text");
    expect(attachment2.name).to.equal(@"body");
    expect(attachment2.contents[@"es"]).to.equal(@"Lorem ipsum...");
    
    expect(post.commentsCount).to.equal(0);
    expect(post.likesCount).to.equal(0);
    expect(post.sharesCount).to.equal(0);

    expect(post.createdAt).to.equal([NSDate dateWithTimeIntervalSince1970:1433148297]);
    expect(post.updatedAt).to.equal([NSDate dateWithTimeIntervalSince1970:1392013510]);
}


- (void)testInitPostWithDictionaryWithCounts {
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
    
    TGPost *post = [[TGPost alloc] initWithDictionary:postData];
    
    expect(post).toNot.beNil();
    expect(post.commentsCount).to.equal(3);
    expect(post.likesCount).to.equal(12);
    expect(post.sharesCount).to.equal(1);
}

- (void)testInitPostWithDictionaryWithNewContents {
    NSDictionary *postData = @{
                               @"id" : @(471739965702621007),
                               @"user_id" : @(858667),
                               @"visibility": @(30),
                               @"tags": @[@"fitness",@"running"],
                               @"attachments" : @[
                                       @{
                                           @"contents": @{
                                                @"en":@"some content",
                                                @"es":@"algun contenido"
                                           },
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
    
    TGPost *post = [[TGPost alloc] initWithDictionary:postData];
    
    TGAttachment *attachment = post.attachments[0];
    
    expect(attachment.contents[@"en"]).to.equal(@"some content");
    expect(attachment.contents[@"es"]).to.equal(@"algun contenido");
}

- (void)testJsonDictionaryWithAll {

    TGPost *post = [TGPost new];
    post.objectId = @"858667";
    post.visibility = TGVisibilityPublic;
    post.tags = @[@"fitness",@"running"];
    [post addAttachment:[TGAttachment attachmentWithText:@{@"en":@"Lorem ipsum..."} andName:@"body"]];
    [post addAttachment:[TGAttachment attachmentWithURL:@{@"es":@"http://bit.ly/123.gif"} andName:@"teaser"]];

    NSDictionary *jsonDictionary = post.jsonDictionary;
    expect([NSJSONSerialization isValidJSONObject:jsonDictionary]).to.beTruthy();
    
    expect(jsonDictionary.count).to.equal(4);
    
    // Check for correct values
    expect([jsonDictionary valueForKey:@"id"]).to.equal(@"858667");
    
    expect([jsonDictionary valueForKey:@"visibility"]).to.equal(30);
    
    expect([jsonDictionary valueForKey:@"tags"]).to.beKindOf([NSArray class]);
    NSArray *jsonTags = [jsonDictionary valueForKey:@"tags"];
    expect(jsonTags.count).to.equal(2);
    expect(jsonTags).to.contain(@"fitness");
    expect(jsonTags).to.contain(@"running");

    expect([jsonDictionary valueForKey:@"attachments"]).to.beKindOf([NSArray class]);
    NSArray *jsonAttachments = [jsonDictionary valueForKey:@"attachments"];
    expect(jsonAttachments.count).to.equal(2);
    expect(jsonAttachments).to.contain((@{
                                          @"contents": @{@"es":@"http://bit.ly/123.gif"},
                                         @"name": @"teaser",
                                         @"type": @"url"
                                         }));
    expect(jsonAttachments).to.contain((@{
                                          @"contents": @{@"en":@"Lorem ipsum..."},
                                         @"name": @"body",
                                         @"type": @"text"
                                         }));
   
}


- (void)testJsonDictionaryWithTextAttachmentWithTwoEntries {
    
    TGPost *post = [TGPost new];
    [post addAttachment:[TGAttachment attachmentWithText:@{@"en": @"Lorem ipsum...", @"es":@"bacon ipsum..."} andName:@"body"]];
    
    NSDictionary *jsonDictionary = post.jsonDictionary;
    expect([NSJSONSerialization isValidJSONObject:jsonDictionary]).to.beTruthy();
    
    expect(jsonDictionary.count).to.equal(2);
    
    // Check for correct values
    expect([jsonDictionary valueForKey:@"id"]).to.beNil();
    expect([jsonDictionary valueForKey:@"visibility"]).to.equal(20);
    
    expect([jsonDictionary valueForKey:@"attachments"]).to.beKindOf([NSArray class]);
    NSArray *jsonAttachments = [jsonDictionary valueForKey:@"attachments"];
    expect(jsonAttachments.count).to.equal(1);
    expect(jsonAttachments).to.contain((@{
                                          @"contents": @{@"en":@"Lorem ipsum...", @"es": @"bacon ipsum..."},
                                          @"name": @"body",
                                          @"type": @"text"
                                          }));
    
}


- (void)testJsonDictionaryWillNotIncludeCounts {
    TGPost *post = [TGPost new];
    [post addAttachment:[TGAttachment attachmentWithText:@{@"en":@"Lorem ipsum..."} andName:@"body"]];
    
    NSDictionary *jsonDictionary = post.jsonDictionary;
    expect([NSJSONSerialization isValidJSONObject:jsonDictionary]).to.beTruthy();
    expect(jsonDictionary.count).to.equal(2);  // set proper count
}

@end
