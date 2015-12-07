//
//  TGConnectionTests.m
//  Tapglue Tests
//
//  Created by Martin Stemmle on 07.12.2015.
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
#import "TGModelObject+Private.h"
#import "TGUser+Private.h"
#import "TGConnection+Private.h"

@interface TGConnectionTests : TGTestCase

@end

@implementation TGConnectionTests


- (void)testInitWithDictionary {
    
    TGUser *user1 = [TGUser createOrLoadWithDictionary:@{@"id":@(4179086830210165), @"user_name":@"some-user-1"}];
    TGUser *user2 = [TGUser createOrLoadWithDictionary:@{@"id":@(14192598918894105), @"user_name":@"some-user-2"}];
    
    TGConnection *connection = [[TGConnection alloc] initWithDictionary:@{
        @"user_from_id": @(4179086830210165),
        @"user_to_id": @(14192598918894105),
        @"type": @"follow",
        @"state": @"confirmed",
        @"enabled": @NO,
        @"created_at": @"2015-12-07T15:58:29.468593382Z",
        @"updated_at": @"2015-12-07T15:58:29.468593382Z"
        }];
    
    expect(connection.fromUser).to.equal(user1);
    expect(connection.toUser).to.equal(user2);
    expect(connection.state).to.equal(TGConnectionStateConfirmed);
    expect(connection.createdAt).to.equal([NSDate dateWithTimeIntervalSince1970:1449503909]);
}


@end
