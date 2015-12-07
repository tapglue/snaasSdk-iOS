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
#import "TGQueryBuilder.h"

/*!
 @abstract Completion block for a network requets.
 */
typedef void (^TGEventListCompletionBlock)(NSArray *events, NSError *error);

@implementation TGEventManager (Queries)

- (void)retrieveEventsForObjectWithId:(NSString*)objectId andEventType:(NSString*)eventType withCompletionBlock:(TGEventListCompletionBlock)completionBlock {
    // route: /events
    [self retrieveEventsForQueryString:[self composeQueryStringFromEventType:eventType andObjectWithId:objectId]
                              andRoute:TGEventManagerAPIEndpointEvents
                   withCompletionBlock:completionBlock];
}

- (void)retrieveEventsForCurrentUserForObjectWithId:(NSString*)objectId andEventType:(NSString*)eventType withCompletionBlock:(TGEventListCompletionBlock)completionBlock {
    // rout: /me/events
    [self retrieveEventsForQueryString:[self composeQueryStringFromEventType:eventType andObjectWithId:objectId]
                              andRoute:TGEventManagerAPIEndpointCurrentUserEvents
                   withCompletionBlock:completionBlock];
}

- (void)retrieveFeedForCurrentUserForObjectWithId:(NSString*)objectId andEventType:(NSString*)eventType withCompletionBlock:(TGEventListCompletionBlock)completionBlock {
    // route: /me/feed
    [self retrieveEventsForQueryString:[self composeQueryStringFromEventType:eventType andObjectWithId:objectId]
                              andRoute:TGEventManagerAPIEndpointCurrentUserFeed
                   withCompletionBlock:completionBlock];
}

- (void)retrieveEventsForQuery:(NSDictionary*)query andRoute:(NSString*)route withCompletionBlock:(TGEventListCompletionBlock)completionBlock {
    [self retrieveEventsForQueryString:[TGQueryBuilder urlStringFromQuery:query]
                              andRoute:TGEventManagerAPIEndpointCurrentUserFeed
                   withCompletionBlock:completionBlock];
}

- (void)retrieveEventsForQueryString:(NSString*)query andRoute:(NSString*)route withCompletionBlock:(void (^)(NSArray *events, NSError *error))completionBlock {
    [self.client GET:route withURLParameters:@{@"where" : query} andCompletionBlock:^(NSDictionary *jsonResponse, NSError *error) {
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

- (NSString*)composeQueryStringFromEventType:(NSString*)eventType andObjectWithId:(NSString*)objectId {
    TGQueryBuilder *queryBuilder = [[TGQueryBuilder alloc] init];
    [queryBuilder addTypeEquals:eventType];
    [queryBuilder addObjectWithId:objectId];
    return queryBuilder.queryAsUrlString;
}

@end
