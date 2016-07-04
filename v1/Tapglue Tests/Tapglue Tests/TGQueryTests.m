//
//  TGQueryBuilderTests.m
//  Tests
//
//  Created by Martin Stemmle on 07/12/15.
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
#import "TGQuery+Private.h"

@interface TGQueryTests : TGTestCase

@end

@implementation TGQueryTests

- (void)testQueryWithObjectId {
    TGQuery *query = [TGQuery new];
    [query addObjectIdEquals:@"123"];
    expect(query.queryAsString).to.equal(@"{\"tg_object_id\":{\"eq\":\"123\"}}");
}

- (void)testQueryWithObjectIdGivenNil {
    TGQuery *query = [TGQuery new];
    [query addObjectIdEquals:nil];
    expect(query.queryAsString).to.equal(@"{}");
}

- (void)testQueryWithObjectIdInList {
    TGQuery *query = [TGQuery new];
    [query addObjectIdIn:@[@"123", @"abc"]];
    expect(query.queryAsString).to.equal(@"{\"tg_object_id\":{\"in\":[\"123\",\"abc\"]}}");
}

- (void)testQueryWithObjectIdAndType {
    TGQuery *query = [TGQuery new];
    [query addObjectIdEquals:@"123"];
    [query addTypeEquals:@"foovent"];
    
    NSString *queryStirng = query.queryAsString;
    expect(queryStirng).to.beginWith(@"{");
    expect(queryStirng).to.contain(@"\"tg_object_id\":{\"eq\":\"123\"}");
    expect(queryStirng).to.contain(@"\"type\":{\"eq\":\"foovent\"}");
    expect(queryStirng).to.endWith(@"}");
}


- (void)testComposeQueryDictionaryFromEventType {
    TGQuery *builder;
    NSDictionary *query;

    builder = [[TGQuery alloc] init];
    [builder addTypeEquals:@"foo"];
    [builder addEventObjectWithIdEquals:@"bar"];
    query = builder.query;
    expect(query.count).to.equal(2);
    expect([query valueForKey:@"type"]).toNot.beNil();
    expect([query valueForKey:@"object"]).toNot.beNil();
    
    builder = [[TGQuery alloc] init];
    [builder addTypeEquals:@"foo"];
    query = builder.query;
    expect(query.count).to.equal(1);
    expect([query valueForKey:@"type"]).toNot.beNil();
    expect([query valueForKey:@"object"]).to.beNil();
    
    builder = [[TGQuery alloc] init];
    [builder addEventObjectWithIdEquals:@"bar"];
    query = builder.query;
    expect(query.count).to.equal(1);
    expect([query valueForKey:@"type"]).to.beNil();
    expect([query valueForKey:@"object"]).toNot.beNil();
}

- (void)testQueryDictToUrlString {
    TGQuery *builder = [[TGQuery alloc] init];
    [builder addEventObjectWithIdEquals:@"some-id-123"];
    expect(builder.queryAsString).to.equal(@"{\"object\":{\"id\":{\"eq\":\"some-id-123\"}}}");
}

- (void)testQueryWithTypeIn {
    TGQuery *query = [TGQuery new];
    [query addTypeIn:@[@"my_event_1", @"my_event_2"]];
    expect(query.queryAsString).to.equal(@"{\"type\":{\"in\":[\"my_event_1\",\"my_event_2\"]}}");
}

@end
