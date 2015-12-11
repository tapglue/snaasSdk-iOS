//
//  TGEventManager+Queries.m
//  Tapglue iOS SDK
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

#import "TGEventManager+Queries.h"
#import "TGEventManager+Private.h"
#import "TGEvent.h"
#import "TGModelObject+Private.h"
#import "TGApiClient.h"
#import "TGLogger.h"
#import "Tapglue+Private.h"
#import "TGUserManager.h"
#import "TGQuery+Private.h"
#import "TGApiRoutesBuilder.h"

@implementation TGEventManager (Queries)

- (void)retrieveEventsWithQuery:(TGQuery*)query andCompletionBlock:(TGGetEventListCompletionBlock)completionBlock {
    // route: /events
    [self retrieveEventsWithQuery:query
                          atRoute:TGEventManagerAPIEndpointEvents
              withCompletionBlock:completionBlock];
}

- (void)retrieveEventsForCurrentUserWithQuery:(TGQuery*)query andCompletionBlock:(TGGetEventListCompletionBlock)completionBlock {
    // rout: /me/events
    [self retrieveEventsWithQuery:query
                          atRoute:[TGApiRoutesBuilder routeForEventsOfUserWithId:nil]
              withCompletionBlock:completionBlock];
}

- (void)retrieveEventsFeedForCurrentUserWithQuery:(TGQuery*)query andCompletionBlock:(TGGetEventListCompletionBlock)completionBlock {
    // route: /me/feed
    [self retrieveEventsWithQuery:query
                          atRoute:[TGApiRoutesBuilder routeForMixedFeed]
              withCompletionBlock:completionBlock];
}

- (void)retrieveEventsWithQuery:(TGQuery*)query atRoute:(NSString*)route withCompletionBlock:(TGGetEventListCompletionBlock)completionBlock {
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
    [query addEventObjectWithIdEquals:objectId];
    return query;
}

@end
