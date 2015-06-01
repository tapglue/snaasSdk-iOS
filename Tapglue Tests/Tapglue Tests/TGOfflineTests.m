//
//  TGOfflineTests.m
//  Tapglue Tests
//
//  Created by Martin Stemmle on 09/06/15.
//
//

#import "TGIntegrationTestCase.h"
#import "TGEventManager.h"

@interface TGOfflineTests : TGIntegrationTestCase

@end

@implementation TGOfflineTests

- (void)testFeedCache {
    [Tapglue setUpWithAppToken:self.appToken andConfig:self.config];
    expect([Tapglue cachedFeedForCurrentUser]).to.beNil();
    [self runTestBlockAfterLogin:^(XCTestExpectation *expectation) {
        expect([Tapglue cachedFeedForCurrentUser]).to.beKindOfOrNil([NSArray class]);
        
        [Tapglue retrieveFeedForCurrentUserWithCompletionBlock:^(NSArray *events, NSInteger unreadCount, NSError *error) {
            expect(error).to.beNil();
            expect([Tapglue cachedFeedForCurrentUser]).to.beKindOfOrNil([NSArray class]);
            expect([Tapglue cachedFeedForCurrentUser]).to.equal(events);
            
            XCTAssertGreaterThan(events.count, 0, @"This test only works properly if the feed is not empty");
            
            Tapglue *tgInstance = [Tapglue sharedInstance];
            [tgInstance.eventManager archive];
            [Tapglue setUpWithAppToken:self.appToken andConfig:self.config]; // create a new Tapglue instance to release all caches
            expect([Tapglue sharedInstance]).toNot.equal(tgInstance);
            
            
            NSArray *cachedFeed = [Tapglue cachedFeedForCurrentUser];
            expect(cachedFeed).to.beKindOf([NSArray class]);
            expect(cachedFeed.count).to.equal(events.count);
            
            [expectation fulfill];
        }];
    }];
}


// TODO: same test for the unread feed

// TODO: test for unread count caching

@end
