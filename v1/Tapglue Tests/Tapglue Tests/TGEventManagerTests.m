//
//  TGEventManagerTests.m
//  Tapglue Tests
//
//  Created by Martin Stemmle on 05/06/15.
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

#import "TGEventManager.h"
#import "TGApiClientMock.h"
#import "TGObject+Private.h"
#import "TGEvent+RandomTestEvent.h"

@interface TGEventManager (Private)
@property (nonatomic, strong) NSMutableArray *writeQueue;
@property (nonatomic, strong) NSMutableSet *deleteQueue;
@property (nonatomic, strong) dispatch_queue_t serialQueue;
@end

@interface TGEventManagerTests : TGTestCase
@property (nonatomic, strong) TGApiClientMock *client;
@property (nonatomic, strong) TGEventManager *eventManager;

@property (nonatomic, strong) TGEvent *newTestEvent;
@property (nonatomic, strong) TGEvent *oldTestEvent;
@end


@implementation TGUser (CurrentUserMock)
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-protocol-method-implementation"
+ (TGUser*)currentUser {
    return [[TGUser alloc] initWithDictionary:@{@"id" : @"4711", @"user_name" : @"alfred"}];
}
#pragma clang diagnostic pop
@end

@implementation TGEventManagerTests

- (void)setUp {
    [super setUp];

    self.client = [[TGApiClientMock alloc] initWithAppToken:self.appToken andConfig:nil];
    self.client.offline = YES;
    self.eventManager = [[TGEventManager alloc] initWithClient:self.client];

    [self.eventManager resetCaches];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (TGEvent*)newTestEvent {
    if (!_newTestEvent) {
        TGEvent *event = [[TGEvent alloc] init];
        event.type = @"like";
        _newTestEvent = event;
    }
    return _newTestEvent;
}

- (TGEvent*)oldTestEvent {
    if (!_oldTestEvent) {
        TGEvent *event = [[TGEvent alloc] init];
        event.objectId = @"102-391-234";
        event.type = @"like";
        _oldTestEvent = event;
    }
    return _oldTestEvent;
}

- (void)testAddEventGetsQueuedWhenBeingOffline {
    expect(self.eventManager.writeQueue.count).to.equal(0);
    [self.eventManager addEvent:self.newTestEvent];
    [self waitForSerialQueue];
    expect(self.eventManager.writeQueue.count).to.equal(1);

    [self.eventManager flush];
    [self waitForSerialQueue];
    expect(self.eventManager.writeQueue.count).to.equal(1);
}

- (void)testAddEventGetsPushedWhenBeingOnline {
    self.client.offline = NO;
    expect(self.eventManager.writeQueue.count).to.equal(0);
    [self.eventManager addEvent:self.newTestEvent];
    [self waitForSerialQueue];
    expect(self.eventManager.writeQueue.count).to.equal(0);
}

- (void)testAddEventGetsDeletedWhenBeingOnline {
    [self testAddEventGetsPushedWhenBeingOnline];

    [self.eventManager deleteEvent:self.newTestEvent];
    [self waitForSerialQueue];
    expect(self.eventManager.deleteQueue.count).to.equal(0);
}

// TODO: test queue event(s) while being offline > go online > flush

// TODO: test queue event(s) while being offline > go online > flush

#pragma mark - test queue managemnt

- (void)testAddedEventGetsRemovedFromPushQueueWhenDeletingItBeforeFlushing {
    [self.eventManager addEvent:self.newTestEvent];
    [self waitForSerialQueue];
    expect(self.eventManager.writeQueue).to.contain(self.newTestEvent);

    [self.eventManager deleteEvent:self.newTestEvent];
    [self waitForSerialQueue];
    expect(self.eventManager.writeQueue).toNot.contain(self.newTestEvent);
}

- (void)testDeletingANewEventGetsRemovedFromPushQueueAndNotPutOnTheDeleteQueue {
    [self.eventManager addEvent:self.newTestEvent];
    [self waitForSerialQueue];
    expect(self.eventManager.writeQueue).to.contain(self.newTestEvent);

    [self.eventManager deleteEvent:self.newTestEvent];
    [self waitForSerialQueue];
    expect(self.eventManager.writeQueue).toNot.contain(self.newTestEvent);
    expect(self.eventManager.deleteQueue).toNot.contain(self.newTestEvent);
}

- (void)testDeletingAnUpdatingEventGetsRemovedFromPushQueueAndPutOnTheDeleteQueue {
    [self.eventManager addEvent:self.oldTestEvent];
    [self waitForSerialQueue];
    expect(self.eventManager.writeQueue).to.contain(self.oldTestEvent);

    [self.eventManager deleteEvent:self.oldTestEvent];
    [self waitForSerialQueue];
    expect(self.eventManager.writeQueue).toNot.contain(self.oldTestEvent);
    expect(self.eventManager.deleteQueue).to.contain(self.oldTestEvent);
}

- (void)testDeletingEventsNotAddedBeforePutOnTheDeleteQueue {
    [self.eventManager deleteEvent:self.newTestEvent];
    [self waitForSerialQueue];
    expect(self.eventManager.writeQueue).toNot.contain(self.newTestEvent);
    expect(self.eventManager.deleteQueue).to.contain(self.newTestEvent);

    [self.eventManager deleteEvent:self.oldTestEvent];
    [self waitForSerialQueue];
    expect(self.eventManager.writeQueue).toNot.contain(self.oldTestEvent);
    expect(self.eventManager.deleteQueue).to.contain(self.oldTestEvent);
}

- (void)testAddingAnEventTwiceWillOnlyContainItOnceInTheWriteQueue {
    expect(self.eventManager.writeQueue.count).to.equal(0);
    // add once
    [self.eventManager addEvent:self.newTestEvent];
    [self waitForSerialQueue];
    expect(self.eventManager.writeQueue).to.contain(self.newTestEvent);
    expect(self.eventManager.writeQueue.count).to.equal(1);
    // add again
    [self.eventManager addEvent:self.newTestEvent];
    [self waitForSerialQueue];
    expect(self.eventManager.writeQueue).to.contain(self.newTestEvent);
    expect(self.eventManager.writeQueue.count).to.equal(1);
}


- (void)testDeletingAnEventTwiceWillOnlyContainItOnceInTheDeleteQueue {
    expect(self.eventManager.deleteQueue.count).to.equal(0);
    // add once
    [self.eventManager deleteEvent:self.newTestEvent];
    [self waitForSerialQueue];
    expect(self.eventManager.deleteQueue).to.contain(self.newTestEvent);
    expect(self.eventManager.deleteQueue.count).to.equal(1);
    // add again
    [self.eventManager deleteEvent:self.newTestEvent];
    [self waitForSerialQueue];
    expect(self.eventManager.deleteQueue).to.contain(self.newTestEvent);
    expect(self.eventManager.deleteQueue.count).to.equal(1);
}

- (void)testQueueArchiving {
    expect(self.eventManager.writeQueue.count).to.equal(0);
    expect(self.eventManager.deleteQueue.count).to.equal(0);
    [self.eventManager addEvent:[TGEvent randomTestEvent]];
    [self.eventManager addEvent:[TGEvent randomTestEvent]];
    [self.eventManager addEvent:[TGEvent randomTestEvent]];
    [self.eventManager addEvent:[TGEvent randomTestEvent]];
    [self.eventManager addEvent:[TGEvent randomTestEvent]];
    [self waitForSerialQueue];
    expect(self.eventManager.writeQueue.count).to.equal(5);
    [self.eventManager deleteEvent:[TGEvent randomTestEvent]];
    [self.eventManager deleteEvent:[TGEvent randomTestEvent]];
    [self waitForSerialQueue];
    expect(self.eventManager.deleteQueue.count).to.equal(2);

    [self.eventManager archive];

    self.eventManager = [[TGEventManager alloc] initWithClient:self.client];
    [self waitForSerialQueue];
    expect(self.eventManager.writeQueue.count).to.equal(5);
    expect(self.eventManager.deleteQueue.count).to.equal(2);

}
// TODO: test case: add events to both queues > call resetCaches > check that queues are empty


#pragma mark - Helper

- (void)waitForSerialQueue
{
    NSLog(@"starting wait for serial queue...");
    dispatch_sync(self.eventManager.serialQueue, ^{ return; });
    NSLog(@"finished wait for serial queue");
}

@end
