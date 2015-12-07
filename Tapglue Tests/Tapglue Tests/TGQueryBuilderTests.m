//
//  TGQueryBuilderTests.m
//  Tests
//
//  Created by Martin Stemmle on 07.12.15.
//
//

#import "TGTestCase.h"
#import "TGQueryBuilder.h"

@interface TGQueryBuilderTests : TGTestCase

@end

@implementation TGQueryBuilderTests

- (void)testComposeQueryDictionaryFromEventType {
    TGQueryBuilder *builder;
    NSDictionary *query;

    builder = [[TGQueryBuilder alloc] init];
    [builder addTypeEquals:@"foo"];
    [builder addObjectWithId:@"bar"];
    query = builder.query;
    expect(query.count).to.equal(2);
    expect([query valueForKey:@"type"]).toNot.beNil();
    expect([query valueForKey:@"object"]).toNot.beNil();
    
    builder = [[TGQueryBuilder alloc] init];
    [builder addTypeEquals:@"foo"];
    query = builder.query;
    expect(query.count).to.equal(1);
    expect([query valueForKey:@"type"]).toNot.beNil();
    expect([query valueForKey:@"object"]).to.beNil();
    
    builder = [[TGQueryBuilder alloc] init];
    [builder addObjectWithId:@"bar"];
    query = builder.query;
    expect(query.count).to.equal(1);
    expect([query valueForKey:@"type"]).to.beNil();
    expect([query valueForKey:@"object"]).toNot.beNil();
}

- (void)testQueryDictToUrlString {
    TGQueryBuilder *builder = [[TGQueryBuilder alloc] init];
    [builder addObjectWithId:@"some-id-123"];
    // expect {"object":{"id":{"eq":"some-id-123"}}} as URL encoded string
    expect(builder.queryAsUrlString).to.equal(@"%7B%22object%22:%7B%22id%22:%7B%22eq%22:%22some-id-123%22%7D%7D%7D");
}

@end
