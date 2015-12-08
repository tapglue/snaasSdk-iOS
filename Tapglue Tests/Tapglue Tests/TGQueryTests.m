//
//  TGQueryBuilderTests.m
//  Tests
//
//  Created by Martin Stemmle on 07.12.15.
//
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
    [builder addObjectWithIdEquals:@"bar"];
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
    [builder addObjectWithIdEquals:@"bar"];
    query = builder.query;
    expect(query.count).to.equal(1);
    expect([query valueForKey:@"type"]).to.beNil();
    expect([query valueForKey:@"object"]).toNot.beNil();
}

- (void)testQueryDictToUrlString {
    TGQuery *builder = [[TGQuery alloc] init];
    [builder addObjectWithIdEquals:@"some-id-123"];
    expect(builder.queryAsString).to.equal(@"{\"object\":{\"id\":{\"eq\":\"some-id-123\"}}}");
}

- (void)testQueryWithTypeIn {
    TGQuery *query = [TGQuery new];
    [query addTypeIn:@[@"my_event_1", @"my_event_2"]];
    expect(query.queryAsString).to.equal(@"{\"type\":{\"in\":[\"my_event_1\",\"my_event_2\"]}}");
}

@end
