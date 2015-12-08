//
//  TGEventManager+Queries.m
//  Tapglue iOS SDK
//
//  Created by Martin Stemmle on 07.12.15.
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

#import "TGEventManager+Queries.h"
#import "TGEventManager+Private.h"
#import "TGEvent.h"
#import "TGModelObject+Private.h"
#import "TGApiClient.h"
#import "TGLogger.h"
#import "Tapglue+Private.h"
#import "TGUserManager.h"
#import "TGQuery+Private.h"

/*!
 @abstract Completion block for a network requets.
 */
typedef void (^TGEventListCompletionBlock)(NSArray *events, NSError *error);

@implementation TGEventManager (Queries)

- (void)retrieveEventsForObjectWithId:(NSString*)objectId andEventType:(NSString*)eventType withCompletionBlock:(TGEventListCompletionBlock)completionBlock {
    // route: /events
    [self retrieveEventsWithQuery:[self composeQueryForEventType:eventType andObjectWithId:objectId]
                          atRoute:TGEventManagerAPIEndpointEvents
              withCompletionBlock:completionBlock];
}

- (void)retrieveEventsForCurrentUserForObjectWithId:(NSString*)objectId andEventType:(NSString*)eventType withCompletionBlock:(TGEventListCompletionBlock)completionBlock {
    // rout: /me/events
    [self retrieveEventsWithQuery:[self composeQueryForEventType:eventType andObjectWithId:objectId]
                          atRoute:TGEventManagerAPIEndpointCurrentUserEvents
              withCompletionBlock:completionBlock];
}

- (void)retrieveFeedForCurrentUserForObjectWithId:(NSString*)objectId andEventType:(NSString*)eventType withCompletionBlock:(TGEventListCompletionBlock)completionBlock {
    // route: /me/feed
    [self retrieveEventsWithQuery:[self composeQueryForEventType:eventType andObjectWithId:objectId]
                          atRoute:TGEventManagerAPIEndpointCurrentUserFeed
              withCompletionBlock:completionBlock];
}

- (void)retrieveEventsWithQuery:(TGQuery*)query atRoute:(NSString*)route withCompletionBlock:(TGEventListCompletionBlock)completionBlock {
    [self.client GET:route withURLParameters:@{@"where" : query.queryAsString} andCompletionBlock:^(NSDictionary *jsonResponse, NSError *error) {
        if (completionBlock) {
            if (!error) {
                NSArray *events = [self eventsFromJsonResponse:jsonResponse];
                if (completionBlock) {
                    completionBlock(events, nil);
                }
            }
            else if(completionBlock) {
                completionBlock(nil, error);
            }
        }
    }];
}

- (TGQuery*)composeQueryForEventType:(NSString*)eventType andObjectWithId:(NSString*)objectId {
    TGQuery *query = [[TGQuery alloc] init];
    [query addTypeEquals:eventType];
    [query addObjectWithId:objectId];
    return query;
}

@end
