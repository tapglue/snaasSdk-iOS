//
//  TGQueryBuilderTests.m
//  Tests
//
//  Created by Martin Stemmle on 07.12.15.
//
//

#import "TGTestCase.h"
#import "TGQuery.h"

@interface TGQueryTests : TGTestCase

@end

@implementation TGQueryTests

- (void)testComposeQueryDictionaryFromEventType {
    TGQuery *builder;
    NSDictionary *query;

    builder = [[TGQuery alloc] init];
    [builder addTypeEquals:@"foo"];
    [builder addObjectWithId:@"bar"];
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
    [builder addObjectWithId:@"bar"];
    query = builder.query;
    expect(query.count).to.equal(1);
    expect([query valueForKey:@"type"]).to.beNil();
    expect([query valueForKey:@"object"]).toNot.beNil();
}

- (void)testQueryDictToUrlString {
    TGQuery *builder = [[TGQuery alloc] init];
    [builder addObjectWithId:@"some-id-123"];
    expect(builder.queryAsString).to.equal(@"{\"object\":{\"id\":{\"eq\":\"some-id-123\"}}}");
}

@end
