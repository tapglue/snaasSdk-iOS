//
//  TGEventManager+Queries.h
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

#import "TGEventManager.h"

@interface TGEventManager (Queries)

/*!
 @abstract Retrieve all events for an object with id and type.
 @discussion This will retrieve the events for any object with an id and type.
 @param objectId The objectid for which the events should be retrieved.
 @param eventType The type of the object for which the events should be retrieved.
 */
- (void)retrieveEventsForObjectWithId:(NSString*)objectId andEventType:(NSString*)eventType withCompletionBlock:(void (^)(NSArray *events, NSError *error))completionBlock;

/*!
 @abstract Retrieve current user events for an object with id and type.
 @discussion This will retrieve current user events for any object with an id and type.
 @param objectId The objectid for which the events should be retrieved.
 @param eventType The type of the object for which the events should be retrieved.
 */
- (void)retrieveEventsForCurrentUserForObjectWithId:(NSString*)objectId andEventType:(NSString*)eventType withCompletionBlock:(void (^)(NSArray *events, NSError *error))completionBlock;

/*!
 @abstract Retrieve all feed events for an object with id and type.
 @discussion This will retrieve feed events for any object with an id and type.
 @param objectId The objectid for which the events should be retrieved.
 @param eventType The type of the object for which the events should be retrieved.
 */
- (void)retrieveFeedForCurrentUserForObjectWithId:(NSString*)objectId andEventType:(NSString*)eventType withCompletionBlock:(void (^)(NSArray *events, NSError *error))completionBlock;

@end
